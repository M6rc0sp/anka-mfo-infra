# ⭐ Fase 8 - Diferenciais

## 📋 Objetivo
Implementar funcionalidades extras que agregam valor ao projeto: autenticação, gestão de clientes, RBAC e melhorias de segurança.

---

## 🎯 Entregáveis desta Fase (Opcionais)

- [ ] Sistema de autenticação (login/registro)
- [ ] Gestão de clientes (CRUD + importação CSV)
- [ ] RBAC (Admin e Assessor)
- [ ] Proteção de rotas
- [ ] Melhorias de segurança na API

---

## 📝 Prompt 8.1 - Autenticação Backend

```markdown
Implemente sistema de autenticação JWT no backend:

### Dependências adicionais:

\`\`\`bash
npm install @fastify/jwt bcryptjs
npm install -D @types/bcryptjs
\`\`\`

### Arquivo: src/db/schema.ts (adicionar)

\`\`\`typescript
// Adicionar tabela de usuários
export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  password: varchar('password', { length: 255 }).notNull(),
  name: varchar('name', { length: 100 }).notNull(),
  role: varchar('role', { length: 20 }).notNull().default('assessor'), // 'admin' | 'assessor'
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

// Relacionamento usuário <-> clientes
export const userClients = pgTable('user_clients', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id').references(() => users.id).notNull(),
  clientId: uuid('client_id').references(() => clients.id).notNull(),
}, (table) => ({
  unique: unique().on(table.userId, table.clientId),
}));
\`\`\`

### Arquivo: src/infra/http/plugins/auth.ts

\`\`\`typescript
import { FastifyInstance, FastifyRequest } from 'fastify';
import fastifyJwt from '@fastify/jwt';
import { env } from '../../../env';

declare module '@fastify/jwt' {
  interface FastifyJWT {
    payload: {
      sub: string;
      email: string;
      role: 'admin' | 'assessor';
    };
    user: {
      sub: string;
      email: string;
      role: 'admin' | 'assessor';
    };
  }
}

declare module 'fastify' {
  interface FastifyRequest {
    getCurrentUserId(): string;
    getUserRole(): 'admin' | 'assessor';
  }
}

export async function authPlugin(app: FastifyInstance) {
  await app.register(fastifyJwt, {
    secret: env.JWT_SECRET,
    sign: {
      expiresIn: '7d',
    },
  });

  // Decorator para pegar user ID
  app.decorateRequest('getCurrentUserId', function () {
    return this.user.sub;
  });

  // Decorator para pegar role
  app.decorateRequest('getUserRole', function () {
    return this.user.role;
  });
}

// Hook de autenticação
export async function authenticate(request: FastifyRequest) {
  await request.jwtVerify();
}

// Hook de autorização (admin only)
export async function authorizeAdmin(request: FastifyRequest) {
  await request.jwtVerify();
  if (request.user.role !== 'admin') {
    throw { statusCode: 403, message: 'Acesso negado' };
  }
}
\`\`\`

### Arquivo: src/infra/http/controllers/auth-controller.ts

\`\`\`typescript
import { FastifyInstance } from 'fastify';
import { ZodTypeProvider } from '@fastify/type-provider-zod';
import { z } from 'zod';
import bcrypt from 'bcryptjs';

export async function authController(app: FastifyInstance) {
  const server = app.withTypeProvider<ZodTypeProvider>();

  // Registro
  server.post(
    '/auth/register',
    {
      schema: {
        tags: ['Auth'],
        summary: 'Registrar novo usuário',
        body: z.object({
          email: z.string().email(),
          password: z.string().min(6),
          name: z.string().min(2),
        }),
        response: {
          201: z.object({
            user: z.object({
              id: z.string(),
              email: z.string(),
              name: z.string(),
              role: z.string(),
            }),
          }),
          409: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { email, password, name } = request.body;

      // Verificar se email já existe
      const existing = await request.server.userRepository.findByEmail(email);
      if (existing) {
        return reply.status(409).send({ message: 'Email já cadastrado' });
      }

      // Hash da senha
      const hashedPassword = await bcrypt.hash(password, 10);

      // Criar usuário
      const user = await request.server.userRepository.create({
        email,
        password: hashedPassword,
        name,
        role: 'assessor', // Padrão
      });

      return reply.status(201).send({
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
        },
      });
    }
  );

  // Login
  server.post(
    '/auth/login',
    {
      schema: {
        tags: ['Auth'],
        summary: 'Fazer login',
        body: z.object({
          email: z.string().email(),
          password: z.string(),
        }),
        response: {
          200: z.object({
            token: z.string(),
            user: z.object({
              id: z.string(),
              email: z.string(),
              name: z.string(),
              role: z.string(),
            }),
          }),
          401: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { email, password } = request.body;

      // Buscar usuário
      const user = await request.server.userRepository.findByEmail(email);
      if (!user) {
        return reply.status(401).send({ message: 'Credenciais inválidas' });
      }

      // Verificar senha
      const validPassword = await bcrypt.compare(password, user.password);
      if (!validPassword) {
        return reply.status(401).send({ message: 'Credenciais inválidas' });
      }

      // Gerar token
      const token = await reply.jwtSign({
        sub: user.id,
        email: user.email,
        role: user.role,
      });

      return reply.send({
        token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
        },
      });
    }
  );

  // Perfil do usuário logado
  server.get(
    '/auth/me',
    {
      onRequest: [server.authenticate],
      schema: {
        tags: ['Auth'],
        summary: 'Obter perfil do usuário logado',
        security: [{ bearerAuth: [] }],
        response: {
          200: z.object({
            id: z.string(),
            email: z.string(),
            name: z.string(),
            role: z.string(),
          }),
        },
      },
    },
    async (request, reply) => {
      const userId = request.getCurrentUserId();
      const user = await request.server.userRepository.findById(userId);

      if (!user) {
        return reply.status(404).send({ message: 'Usuário não encontrado' });
      }

      return reply.send({
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
      });
    }
  );
}
\`\`\`

### Atualizar .env.example:

\`\`\`env
JWT_SECRET=sua-chave-secreta-muito-segura-aqui
\`\`\`

### Princípios:
- Senhas hasheadas com bcrypt
- JWT com expiração
- Decorators para fácil acesso ao usuário
```

---

## 📝 Prompt 8.2 - RBAC e Proteção de Rotas

```markdown
Implemente controle de acesso baseado em papéis:

### Arquivo: src/infra/http/middlewares/rbac.ts

\`\`\`typescript
import { FastifyRequest, FastifyReply } from 'fastify';

type Role = 'admin' | 'assessor';

export function requireRole(...roles: Role[]) {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    await request.jwtVerify();
    
    const userRole = request.getUserRole();
    
    if (!roles.includes(userRole)) {
      return reply.status(403).send({
        message: 'Você não tem permissão para acessar este recurso',
      });
    }
  };
}

export function requireOwnershipOrAdmin(getOwnerId: (request: FastifyRequest) => Promise<string>) {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    await request.jwtVerify();
    
    const userId = request.getCurrentUserId();
    const userRole = request.getUserRole();
    
    // Admin pode acessar tudo
    if (userRole === 'admin') {
      return;
    }
    
    // Assessor só pode acessar seus próprios recursos
    const ownerId = await getOwnerId(request);
    
    if (ownerId !== userId) {
      return reply.status(403).send({
        message: 'Você não tem permissão para acessar este recurso',
      });
    }
  };
}
\`\`\`

### Aplicar nos controllers:

\`\`\`typescript
// Exemplo: client-controller.ts

import { authenticate, authorizeAdmin } from '../plugins/auth';
import { requireRole, requireOwnershipOrAdmin } from '../middlewares/rbac';

export async function clientController(app: FastifyInstance) {
  const server = app.withTypeProvider<ZodTypeProvider>();

  // Listar clientes - Assessor vê só os seus, Admin vê todos
  server.get(
    '/clients',
    {
      onRequest: [authenticate],
      schema: {
        tags: ['Clients'],
        summary: 'Listar clientes',
        security: [{ bearerAuth: [] }],
      },
    },
    async (request, reply) => {
      const userId = request.getCurrentUserId();
      const role = request.getUserRole();

      let clients;
      if (role === 'admin') {
        // Admin vê todos
        clients = await request.server.clientRepository.findAll();
      } else {
        // Assessor vê só os seus
        clients = await request.server.clientRepository.findByUserId(userId);
      }

      return reply.send(clients);
    }
  );

  // Criar cliente - Qualquer um autenticado
  server.post(
    '/clients',
    {
      onRequest: [authenticate],
      schema: {
        tags: ['Clients'],
        summary: 'Criar cliente',
        security: [{ bearerAuth: [] }],
      },
    },
    async (request, reply) => {
      const userId = request.getCurrentUserId();
      const data = request.body;

      const client = await request.server.clientRepository.create(data);
      
      // Associar cliente ao usuário
      await request.server.userClientRepository.associate(userId, client.id);

      return reply.status(201).send(client);
    }
  );

  // Buscar cliente - Verificar ownership
  server.get(
    '/clients/:id',
    {
      onRequest: [
        requireOwnershipOrAdmin(async (request) => {
          const clientId = (request.params as { id: string }).id;
          const association = await request.server.userClientRepository
            .findByClientId(clientId);
          return association?.userId ?? '';
        }),
      ],
      schema: {
        tags: ['Clients'],
        summary: 'Buscar cliente por ID',
        security: [{ bearerAuth: [] }],
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      const client = await request.server.clientRepository.findById(id);
      
      if (!client) {
        return reply.status(404).send({ message: 'Cliente não encontrado' });
      }

      return reply.send(client);
    }
  );

  // Deletar cliente - Admin only
  server.delete(
    '/clients/:id',
    {
      onRequest: [requireRole('admin')],
      schema: {
        tags: ['Clients'],
        summary: 'Remover cliente',
        security: [{ bearerAuth: [] }],
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      await request.server.clientRepository.delete(id);
      return reply.status(204).send();
    }
  );
}
\`\`\`

### Configurar Swagger para Bearer Auth:

\`\`\`typescript
// Em app.ts, atualizar swagger config
await app.register(swagger, {
  openapi: {
    info: {
      title: 'MFO API',
      version: '1.0.0',
    },
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
  },
});
\`\`\`

### Princípios:
- Admin tem acesso total
- Assessor só acessa seus clientes
- Middlewares reutilizáveis
```

---

## 📝 Prompt 8.3 - Autenticação Frontend

```markdown
Implemente autenticação no frontend:

### Arquivo: src/contexts/auth-context.tsx

\`\`\`typescript
'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { useRouter } from 'next/navigation';
import { api } from '@/services/api';

interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'assessor';
}

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const router = useRouter();

  // Verificar token no carregamento
  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      fetchUser();
    } else {
      setIsLoading(false);
    }
  }, []);

  async function fetchUser() {
    try {
      const { data } = await api.get('/auth/me');
      setUser(data);
    } catch {
      localStorage.removeItem('token');
      delete api.defaults.headers.common['Authorization'];
    } finally {
      setIsLoading(false);
    }
  }

  async function login(email: string, password: string) {
    const { data } = await api.post('/auth/login', { email, password });
    
    localStorage.setItem('token', data.token);
    api.defaults.headers.common['Authorization'] = `Bearer ${data.token}`;
    setUser(data.user);
    
    router.push('/projecao');
  }

  async function register(email: string, password: string, name: string) {
    await api.post('/auth/register', { email, password, name });
    await login(email, password);
  }

  function logout() {
    localStorage.removeItem('token');
    delete api.defaults.headers.common['Authorization'];
    setUser(null);
    router.push('/login');
  }

  return (
    <AuthContext.Provider
      value={{
        user,
        isLoading,
        isAuthenticated: !!user,
        login,
        register,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
\`\`\`

### Arquivo: src/app/(auth)/login/page.tsx

\`\`\`typescript
'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useAuth } from '@/contexts/auth-context';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { useToast } from '@/components/ui/use-toast';

const loginSchema = z.object({
  email: z.string().email('Email inválido'),
  password: z.string().min(6, 'Mínimo 6 caracteres'),
});

type LoginForm = z.infer<typeof loginSchema>;

export default function LoginPage() {
  const { login } = useAuth();
  const { toast } = useToast();
  const [isLoading, setIsLoading] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema),
  });

  async function onSubmit(data: LoginForm) {
    setIsLoading(true);
    try {
      await login(data.email, data.password);
      toast({
        title: 'Login realizado!',
        description: 'Bem-vindo de volta.',
      });
    } catch (error) {
      toast({
        title: 'Erro no login',
        description: 'Verifique suas credenciais.',
        variant: 'destructive',
      });
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-background">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle className="text-2xl text-center">MFO</CardTitle>
          <p className="text-center text-muted-foreground">
            Entre na sua conta
          </p>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="seu@email.com"
                {...register('email')}
              />
              {errors.email && (
                <p className="text-sm text-destructive">{errors.email.message}</p>
              )}
            </div>

            <div className="space-y-2">
              <Label htmlFor="password">Senha</Label>
              <Input
                id="password"
                type="password"
                {...register('password')}
              />
              {errors.password && (
                <p className="text-sm text-destructive">{errors.password.message}</p>
              )}
            </div>

            <Button type="submit" className="w-full" disabled={isLoading}>
              {isLoading ? 'Entrando...' : 'Entrar'}
            </Button>
          </form>
        </CardContent>
        <CardFooter className="justify-center">
          <p className="text-sm text-muted-foreground">
            Não tem conta?{' '}
            <Link href="/register" className="text-primary hover:underline">
              Registre-se
            </Link>
          </p>
        </CardFooter>
      </Card>
    </div>
  );
}
\`\`\`

### Arquivo: src/components/layout/protected-route.tsx

\`\`\`typescript
'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/contexts/auth-context';

interface ProtectedRouteProps {
  children: React.ReactNode;
  requiredRole?: 'admin' | 'assessor';
}

export function ProtectedRoute({ children, requiredRole }: ProtectedRouteProps) {
  const { user, isLoading, isAuthenticated } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!isLoading && !isAuthenticated) {
      router.push('/login');
    }
  }, [isLoading, isAuthenticated, router]);

  useEffect(() => {
    if (!isLoading && user && requiredRole && user.role !== requiredRole) {
      router.push('/projecao'); // Redireciona se não tiver permissão
    }
  }, [isLoading, user, requiredRole, router]);

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
      </div>
    );
  }

  if (!isAuthenticated) {
    return null;
  }

  if (requiredRole && user?.role !== requiredRole) {
    return null;
  }

  return <>{children}</>;
}
\`\`\`

### Atualizar layout do dashboard:

\`\`\`typescript
// src/app/(dashboard)/layout.tsx
import { ProtectedRoute } from '@/components/layout/protected-route';
import { Sidebar } from '@/components/layout/sidebar';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <ProtectedRoute>
      <div className="flex h-screen overflow-hidden">
        <Sidebar />
        <main className="flex-1 overflow-auto">{children}</main>
      </div>
    </ProtectedRoute>
  );
}
\`\`\`

### Princípios:
- Token persistido em localStorage
- Proteção de rotas automática
- Verificação de papel para admin
```

---

## 📝 Prompt 8.4 - Gestão de Clientes e Importação CSV

```markdown
Implemente tela de gestão de clientes com importação CSV:

### Arquivo: src/app/(dashboard)/clientes/page.tsx

\`\`\`typescript
'use client';

import { useState, useRef } from 'react';
import { Header } from '@/components/layout/header';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { Plus, Upload, Search, Edit, Trash } from 'lucide-react';
import { useClients, useCreateClient, useDeleteClient } from '@/hooks/use-clients';
import { useAuth } from '@/contexts/auth-context';
import { CreateClientDialog } from '@/components/clients/create-client-dialog';
import { ImportCsvDialog } from '@/components/clients/import-csv-dialog';
import { formatDate } from '@/lib/utils';

export default function ClientesPage() {
  const [search, setSearch] = useState('');
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [showImportDialog, setShowImportDialog] = useState(false);

  const { user } = useAuth();
  const { data: clients = [], isLoading } = useClients();
  const deleteClient = useDeleteClient();

  const filteredClients = clients.filter(
    (c) =>
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      c.email.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="flex flex-col h-full">
      <Header
        title="Clientes"
        subtitle={`${clients.length} clientes cadastrados`}
      />

      <div className="flex-1 p-6 space-y-6 overflow-auto">
        {/* Barra de ações */}
        <div className="flex items-center justify-between">
          <div className="relative flex-1 max-w-md">
            <Search
              size={18}
              className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"
            />
            <Input
              placeholder="Buscar cliente..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="pl-10"
            />
          </div>

          <div className="flex items-center gap-2">
            <Button variant="outline" onClick={() => setShowImportDialog(true)}>
              <Upload size={16} className="mr-2" />
              Importar CSV
            </Button>
            <Button onClick={() => setShowCreateDialog(true)}>
              <Plus size={16} className="mr-2" />
              Novo Cliente
            </Button>
          </div>
        </div>

        {/* Tabela de clientes */}
        <Card>
          <CardContent className="p-0">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Nome</TableHead>
                  <TableHead>Email</TableHead>
                  <TableHead>Criado em</TableHead>
                  <TableHead className="text-right">Ações</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredClients.map((client) => (
                  <TableRow key={client.id}>
                    <TableCell className="font-medium">{client.name}</TableCell>
                    <TableCell className="text-muted-foreground">
                      {client.email}
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {formatDate(client.createdAt)}
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex items-center justify-end gap-2">
                        <Button variant="ghost" size="sm">
                          <Edit size={16} />
                        </Button>
                        {user?.role === 'admin' && (
                          <Button
                            variant="ghost"
                            size="sm"
                            className="text-destructive"
                            onClick={() => {
                              if (confirm('Excluir cliente?')) {
                                deleteClient.mutate(client.id);
                              }
                            }}
                          >
                            <Trash size={16} />
                          </Button>
                        )}
                      </div>
                    </TableCell>
                  </TableRow>
                ))}

                {filteredClients.length === 0 && (
                  <TableRow>
                    <TableCell
                      colSpan={4}
                      className="text-center text-muted-foreground py-8"
                    >
                      {isLoading ? 'Carregando...' : 'Nenhum cliente encontrado'}
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>

      {/* Dialogs */}
      <CreateClientDialog
        open={showCreateDialog}
        onOpenChange={setShowCreateDialog}
      />

      <ImportCsvDialog
        open={showImportDialog}
        onOpenChange={setShowImportDialog}
      />
    </div>
  );
}
\`\`\`

### Arquivo: src/components/clients/import-csv-dialog.tsx

\`\`\`typescript
'use client';

import { useState, useRef } from 'react';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Upload, FileText, Check, X } from 'lucide-react';
import { useToast } from '@/components/ui/use-toast';
import { useQueryClient } from '@tanstack/react-query';
import { api } from '@/services/api';

interface ImportCsvDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

interface ParsedClient {
  name: string;
  email: string;
  valid: boolean;
  error?: string;
}

export function ImportCsvDialog({ open, onOpenChange }: ImportCsvDialogProps) {
  const [file, setFile] = useState<File | null>(null);
  const [parsedData, setParsedData] = useState<ParsedClient[]>([]);
  const [isImporting, setIsImporting] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const { toast } = useToast();
  const queryClient = useQueryClient();

  function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const selectedFile = e.target.files?.[0];
    if (!selectedFile) return;

    setFile(selectedFile);
    parseCSV(selectedFile);
  }

  function parseCSV(file: File) {
    const reader = new FileReader();
    reader.onload = (e) => {
      const text = e.target?.result as string;
      const lines = text.split('\n').filter((line) => line.trim());
      
      // Pular header
      const dataLines = lines.slice(1);
      
      const parsed = dataLines.map((line) => {
        const [name, email] = line.split(',').map((s) => s.trim());
        
        const valid = !!name && !!email && email.includes('@');
        
        return {
          name: name || '',
          email: email || '',
          valid,
          error: !valid ? 'Dados inválidos' : undefined,
        };
      });

      setParsedData(parsed);
    };
    reader.readAsText(file);
  }

  async function handleImport() {
    const validClients = parsedData.filter((c) => c.valid);
    if (validClients.length === 0) {
      toast({
        title: 'Erro',
        description: 'Nenhum cliente válido para importar',
        variant: 'destructive',
      });
      return;
    }

    setIsImporting(true);
    try {
      await api.post('/clients/import', { clients: validClients });
      
      toast({
        title: 'Importação concluída!',
        description: `${validClients.length} clientes importados`,
      });
      
      queryClient.invalidateQueries({ queryKey: ['clients'] });
      onOpenChange(false);
      resetState();
    } catch (error) {
      toast({
        title: 'Erro na importação',
        description: 'Verifique os dados e tente novamente',
        variant: 'destructive',
      });
    } finally {
      setIsImporting(false);
    }
  }

  function resetState() {
    setFile(null);
    setParsedData([]);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  }

  const validCount = parsedData.filter((c) => c.valid).length;
  const invalidCount = parsedData.filter((c) => !c.valid).length;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle>Importar Clientes via CSV</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          {/* Upload area */}
          <div
            className="border-2 border-dashed border-muted rounded-lg p-8 text-center cursor-pointer hover:border-primary/50 transition-colors"
            onClick={() => fileInputRef.current?.click()}
          >
            <input
              ref={fileInputRef}
              type="file"
              accept=".csv"
              className="hidden"
              onChange={handleFileChange}
            />
            <Upload className="mx-auto h-12 w-12 text-muted-foreground" />
            <p className="mt-2 text-sm text-muted-foreground">
              Clique para selecionar ou arraste um arquivo CSV
            </p>
            <p className="mt-1 text-xs text-muted-foreground">
              Formato: nome, email
            </p>
          </div>

          {/* Preview */}
          {parsedData.length > 0 && (
            <div className="space-y-2">
              <div className="flex items-center gap-4 text-sm">
                <span className="text-green-500">
                  <Check size={16} className="inline mr-1" />
                  {validCount} válidos
                </span>
                {invalidCount > 0 && (
                  <span className="text-destructive">
                    <X size={16} className="inline mr-1" />
                    {invalidCount} inválidos
                  </span>
                )}
              </div>

              <div className="max-h-60 overflow-auto border rounded-lg">
                <table className="w-full text-sm">
                  <thead className="bg-muted">
                    <tr>
                      <th className="text-left p-2">Status</th>
                      <th className="text-left p-2">Nome</th>
                      <th className="text-left p-2">Email</th>
                    </tr>
                  </thead>
                  <tbody>
                    {parsedData.slice(0, 10).map((client, index) => (
                      <tr key={index} className="border-t">
                        <td className="p-2">
                          {client.valid ? (
                            <Check size={16} className="text-green-500" />
                          ) : (
                            <X size={16} className="text-destructive" />
                          )}
                        </td>
                        <td className="p-2">{client.name}</td>
                        <td className="p-2">{client.email}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
                {parsedData.length > 10 && (
                  <p className="text-center text-xs text-muted-foreground py-2">
                    ... e mais {parsedData.length - 10} registros
                  </p>
                )}
              </div>
            </div>
          )}

          {/* Ações */}
          <div className="flex justify-end gap-2">
            <Button variant="outline" onClick={() => onOpenChange(false)}>
              Cancelar
            </Button>
            <Button
              onClick={handleImport}
              disabled={validCount === 0 || isImporting}
            >
              {isImporting ? 'Importando...' : `Importar ${validCount} clientes`}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
\`\`\`

### Endpoint no backend:

\`\`\`typescript
// Adicionar em client-controller.ts
server.post(
  '/clients/import',
  {
    onRequest: [authenticate],
    schema: {
      tags: ['Clients'],
      summary: 'Importar clientes via CSV',
      body: z.object({
        clients: z.array(z.object({
          name: z.string(),
          email: z.string().email(),
        })),
      }),
    },
  },
  async (request, reply) => {
    const { clients } = request.body;
    const userId = request.getCurrentUserId();
    
    const created = await Promise.all(
      clients.map(async (clientData) => {
        const client = await request.server.clientRepository.create(clientData);
        await request.server.userClientRepository.associate(userId, client.id);
        return client;
      })
    );
    
    return reply.status(201).send({ imported: created.length });
  }
);
\`\`\`

### Princípios:
- Preview antes de importar
- Validação visual de cada linha
- Feedback claro de erros
```

---

## 📝 Prompt 8.5 - Melhorias de Segurança

```markdown
Implemente melhorias de segurança na API:

### Arquivo: src/infra/http/plugins/security.ts

\`\`\`typescript
import { FastifyInstance } from 'fastify';
import helmet from '@fastify/helmet';
import rateLimit from '@fastify/rate-limit';

export async function securityPlugin(app: FastifyInstance) {
  // Helmet - Headers de segurança
  await app.register(helmet, {
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        scriptSrc: ["'self'"],
        imgSrc: ["'self'", 'data:', 'https:'],
      },
    },
  });

  // Rate Limiting
  await app.register(rateLimit, {
    max: 100, // Máximo de requests
    timeWindow: '1 minute',
    errorResponseBuilder: () => ({
      statusCode: 429,
      message: 'Muitas requisições. Tente novamente em alguns minutos.',
    }),
  });

  // Rate limit específico para login
  app.addHook('onRoute', (routeOptions) => {
    if (routeOptions.url === '/auth/login') {
      routeOptions.config = {
        ...routeOptions.config,
        rateLimit: {
          max: 5,
          timeWindow: '1 minute',
        },
      };
    }
  });
}
\`\`\`

### Arquivo: src/infra/http/plugins/sanitize.ts

\`\`\`typescript
import { FastifyInstance, FastifyRequest } from 'fastify';

// Sanitizar inputs para prevenir XSS
function sanitizeString(str: string): string {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function sanitizeObject(obj: any): any {
  if (typeof obj === 'string') {
    return sanitizeString(obj);
  }
  if (Array.isArray(obj)) {
    return obj.map(sanitizeObject);
  }
  if (obj && typeof obj === 'object') {
    const sanitized: any = {};
    for (const key in obj) {
      sanitized[key] = sanitizeObject(obj[key]);
    }
    return sanitized;
  }
  return obj;
}

export async function sanitizePlugin(app: FastifyInstance) {
  app.addHook('preValidation', async (request: FastifyRequest) => {
    if (request.body) {
      request.body = sanitizeObject(request.body);
    }
    if (request.query) {
      request.query = sanitizeObject(request.query);
    }
  });
}
\`\`\`

### Atualizar src/infra/http/error-handler.ts:

\`\`\`typescript
import { FastifyError, FastifyReply, FastifyRequest } from 'fastify';
import { ZodError } from 'zod';

export function errorHandler(
  error: FastifyError,
  request: FastifyRequest,
  reply: FastifyReply
) {
  // Log do erro (sem dados sensíveis)
  request.log.error({
    errorId: error.code,
    path: request.url,
    method: request.method,
    message: error.message,
    // NÃO logar: password, tokens, dados sensíveis
  });

  // Não expor stack trace em produção
  const isDev = process.env.NODE_ENV === 'development';

  // Erro de validação Zod
  if (error instanceof ZodError) {
    return reply.status(400).send({
      message: 'Erro de validação',
      errors: error.errors.map((e) => ({
        path: e.path.join('.'),
        message: e.message,
      })),
    });
  }

  // Erro de autenticação
  if (error.statusCode === 401) {
    return reply.status(401).send({
      message: 'Não autorizado',
    });
  }

  // Erro de permissão
  if (error.statusCode === 403) {
    return reply.status(403).send({
      message: 'Acesso negado',
    });
  }

  // Erro de validação Fastify
  if (error.validation) {
    return reply.status(400).send({
      message: 'Dados inválidos',
      errors: error.validation,
    });
  }

  // Erro conhecido
  if (error.statusCode && error.statusCode < 500) {
    return reply.status(error.statusCode).send({
      message: error.message,
    });
  }

  // Erro interno - não expor detalhes
  return reply.status(500).send({
    message: 'Erro interno do servidor',
    ...(isDev && { stack: error.stack }),
  });
}
\`\`\`

### Adicionar logs de auditoria:

\`\`\`typescript
// src/infra/http/plugins/audit.ts
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';

export async function auditPlugin(app: FastifyInstance) {
  // Log de ações importantes
  app.addHook('onResponse', async (request: FastifyRequest, reply: FastifyReply) => {
    // Logar apenas ações mutáveis
    if (['POST', 'PUT', 'PATCH', 'DELETE'].includes(request.method)) {
      request.log.info({
        type: 'AUDIT',
        userId: (request as any).user?.sub,
        method: request.method,
        path: request.url,
        statusCode: reply.statusCode,
        timestamp: new Date().toISOString(),
      });
    }
  });
}
\`\`\`

### Princípios:
- Helmet para headers de segurança
- Rate limiting para prevenir abuso
- Sanitização de inputs
- Logs de auditoria
- Não expor erros sensíveis
```

---

## ✅ Validação da Fase 8

```bash
# Testar registro
curl -X POST http://localhost:3333/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456","name":"Test"}'

# Testar login
curl -X POST http://localhost:3333/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456"}'

# Testar rota protegida
curl http://localhost:3333/auth/me \
  -H "Authorization: Bearer <token>"

# Testar rate limiting
for i in {1..10}; do
  curl -X POST http://localhost:3333/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"wrong@example.com","password":"wrong"}'
done
```

### Critérios de Sucesso:
- [ ] Registro e login funcionando
- [ ] Token JWT válido
- [ ] Rotas protegidas bloqueando acesso
- [ ] RBAC diferenciando admin/assessor
- [ ] Rate limiting funcionando
- [ ] Importação CSV funcionando

---

## 📚 Arquivos Criados nesta Fase

```
backend/src/
├── db/
│   └── schema.ts (atualizado com users e user_clients)
├── infra/
│   ├── http/
│   │   ├── plugins/
│   │   │   ├── auth.ts
│   │   │   ├── security.ts
│   │   │   ├── sanitize.ts
│   │   │   └── audit.ts
│   │   ├── middlewares/
│   │   │   └── rbac.ts
│   │   └── controllers/
│   │       └── auth-controller.ts
│   └── repositories/
│       ├── drizzle-user-repository.ts
│       └── drizzle-user-client-repository.ts

frontend/src/
├── contexts/
│   └── auth-context.tsx
├── app/
│   └── (auth)/
│       ├── login/page.tsx
│       └── register/page.tsx
├── components/
│   ├── layout/
│   │   └── protected-route.tsx
│   └── clients/
│       ├── create-client-dialog.tsx
│       └── import-csv-dialog.tsx
└── app/(dashboard)/
    └── clientes/page.tsx
```

---

## 🎉 Projeto Completo!

Parabéns! Você completou todas as fases do projeto MFO.

### Resumo do que foi construído:

1. **Infraestrutura**: Docker Compose com PostgreSQL, Backend e Frontend
2. **Backend**: API REST com Fastify, Drizzle ORM, Zod validation
3. **Motor de Projeção**: Cálculo patrimonial com juros, inflação, seguros
4. **Frontend**: Next.js com shadcn/ui, React Query, gráficos Recharts
5. **Integração**: Docker otimizado, scripts de desenvolvimento
6. **Diferenciais**: Autenticação JWT, RBAC, importação CSV

### Próximos passos sugeridos:
- Melhorar cobertura de testes
- Adicionar testes E2E com Playwright
- Implementar cache Redis para projeções
- Adicionar exportação de relatórios PDF
