import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useEffect } from "react";

export const useTheme = () => {
  const { data: settings } = useQuery({
    queryKey: ['site-settings'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('site_settings')
        .select('theme')
        .single();
      
      if (error) throw error;
      return data;
    }
  });

  useEffect(() => {
    const theme = settings?.theme || localStorage.getItem('site-theme') || 'dark';

    // Save to localStorage for instant loading on next visit
    try {
      localStorage.setItem('site-theme', theme);
    } catch {}

    if (theme === 'light') {
      document.documentElement.classList.add('light');
    } else {
      document.documentElement.classList.remove('light');
    }

    // Reveal content if it was hidden to prevent flash
    document.documentElement.classList.remove('theme-pending');
  }, [settings]);

  return settings?.theme || 'dark';
};
