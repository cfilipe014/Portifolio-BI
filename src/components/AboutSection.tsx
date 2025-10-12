import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

export const AboutSection = () => {
  const { data: profile } = useQuery({
    queryKey: ['profile'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('profile')
        .select('*')
        .single();
      
      if (error) throw error;
      return data;
    }
  });

  return (
    <section id="sobre-mim" className="py-24 relative">
      <div className="container px-4">
        <div className="max-w-4xl mx-auto">
          <div className="space-y-8 animate-fade-in">
            <div className="flex items-center gap-3 mb-8">
              <div className="w-1 h-12 bg-accent rounded-full" />
              <h2 className="text-4xl md:text-5xl font-bold">
                {profile?.about_title}
              </h2>
            </div>

            <div className="bg-card rounded-2xl p-8 md:p-12 border border-border/50 shadow-lg backdrop-blur-sm">
              <p className="text-xl md:text-2xl text-muted-foreground leading-relaxed mb-8">
                {profile?.about_text}
              </p>
              
              <div className="flex flex-col md:flex-row items-center gap-6 pt-8 border-t border-border/50">
                <div className="text-center md:text-left">
                  <div className="text-7xl md:text-8xl font-bold text-accent mb-2">
                    {profile?.about_highlight}
                  </div>
                  <p className="text-lg md:text-xl text-foreground font-medium">
                    {profile?.about_highlight_text}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};
