-- Criar tabela para perfil/informações gerais
CREATE TABLE public.profile (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL DEFAULT 'Filipe Cavalcante',
  subtitle TEXT NOT NULL DEFAULT 'Engenheiro Elétrico com foco em linhas Áudio e Vídeo além de Analista de Dados em Power BI e IA.',
  photo_url TEXT,
  about_title TEXT NOT NULL DEFAULT 'Sobre mim:',
  about_text TEXT NOT NULL DEFAULT 'Seja muito bem-vindo(a) ao meu portfólio. Conheça a minha trajetória:',
  about_highlight TEXT NOT NULL DEFAULT '10+',
  about_highlight_text TEXT NOT NULL DEFAULT 'anos de experiência profissional em Supply Chain e Análise de Dados',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar tabela para habilidades
CREATE TABLE public.skills (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon_name TEXT NOT NULL,
  display_order INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar tabela para projetos
CREATE TABLE public.projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  external_link TEXT NOT NULL,
  iframe_url TEXT,
  display_order INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar tabela para informações de contato
CREATE TABLE public.contact_info (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL, -- 'site', 'email', 'linkedin', 'instagram'
  label TEXT NOT NULL,
  url TEXT NOT NULL,
  icon_name TEXT NOT NULL,
  display_order INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir dados iniciais de perfil
INSERT INTO public.profile (name, subtitle, about_title, about_text, about_highlight, about_highlight_text)
VALUES (
  'Filipe Cavalcante',
  'Engenheiro Elétrico com foco em linhas Áudio e Vídeo além de Analista de Dados em Power BI e IA.',
  'Sobre mim:',
  'Seja muito bem-vindo(a) ao meu portfólio. Conheça a minha trajetória:',
  '10+',
  'anos de experiência profissional em Supply Chain e Análise de Dados'
);

-- Inserir habilidades iniciais
INSERT INTO public.skills (title, description, icon_name, display_order)
VALUES
  ('Visualização & Análise de Dados', 'Transformo dados complexos em insights visuais claros e acionáveis', 'BarChart3', 1),
  ('Design de Dashboards', 'Crio dashboards interativos e intuitivos em Power BI', 'Layout', 2),
  ('Gestão de Projetos', 'Coordeno projetos de dados do início ao fim com metodologias ágeis', 'CheckCircle', 3),
  ('Supply Chain', 'Otimizo processos logísticos através de análise de dados', 'TruckIcon', 4);

-- Inserir projetos iniciais
INSERT INTO public.projects (title, description, external_link, display_order)
VALUES
  ('Dashboard de Logística', 'Análise completa de operações logísticas com indicadores de performance, custos e eficiência operacional', 'https://lovable.dev/', 1),
  ('Dashboard de RH', 'Visualização de métricas de recursos humanos incluindo turnover, absenteísmo e performance de equipes', 'https://lovable.dev/', 2),
  ('Dashboard Financeiro', 'Controle financeiro com análise de receitas, despesas e projeções de fluxo de caixa', 'https://lovable.dev/', 3),
  ('Dashboard de Vendas', 'Acompanhamento de vendas com análise de performance por região, produto e vendedor', 'https://lovable.dev/', 4);

-- Inserir informações de contato iniciais
INSERT INTO public.contact_info (type, label, url, icon_name, display_order)
VALUES
  ('site', 'Site', 'https://exemplo.com', 'Globe', 1),
  ('email', 'Email', 'mailto:contato@exemplo.com', 'Mail', 2),
  ('linkedin', 'LinkedIn', 'https://linkedin.com/in/filipecavalcante', 'Linkedin', 3),
  ('instagram', 'Instagram', 'https://instagram.com/filipecavalcante', 'Instagram', 4);

-- Habilitar RLS nas tabelas
ALTER TABLE public.profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_info ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para leitura pública (qualquer visitante pode ver)
CREATE POLICY "Allow public read access on profile"
  ON public.profile FOR SELECT
  USING (true);

CREATE POLICY "Allow public read access on skills"
  ON public.skills FOR SELECT
  USING (true);

CREATE POLICY "Allow public read access on projects"
  ON public.projects FOR SELECT
  USING (true);

CREATE POLICY "Allow public read access on contact_info"
  ON public.contact_info FOR SELECT
  USING (true);

-- Criar bucket de armazenamento para imagens
INSERT INTO storage.buckets (id, name, public)
VALUES ('portfolio-images', 'portfolio-images', true);

-- Políticas de storage para leitura pública
CREATE POLICY "Allow public read access on portfolio images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'portfolio-images');

-- Criar função para atualizar timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar triggers para updated_at
CREATE TRIGGER update_profile_updated_at BEFORE UPDATE ON public.profile
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_skills_updated_at BEFORE UPDATE ON public.skills
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON public.projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contact_info_updated_at BEFORE UPDATE ON public.contact_info
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();