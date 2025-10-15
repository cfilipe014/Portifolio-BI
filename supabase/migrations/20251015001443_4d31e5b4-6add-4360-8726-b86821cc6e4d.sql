-- Create site_settings table for theme management
CREATE TABLE public.site_settings (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  theme text NOT NULL DEFAULT 'dark' CHECK (theme IN ('dark', 'light')),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;

-- Allow public read access
CREATE POLICY "Allow public read access on site_settings"
ON public.site_settings
FOR SELECT
USING (true);

-- Insert default dark theme
INSERT INTO public.site_settings (theme) VALUES ('dark');

-- Create trigger for updated_at
CREATE TRIGGER update_site_settings_updated_at
BEFORE UPDATE ON public.site_settings
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();