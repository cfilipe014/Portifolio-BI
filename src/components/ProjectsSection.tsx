import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { ExternalLink } from "lucide-react";

export const ProjectsSection = () => {
  const { data: projects } = useQuery({
    queryKey: ['projects'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('projects')
        .select('*')
        .order('display_order');
      
      if (error) throw error;
      return data;
    }
  });

  return (
    <section className="py-24 relative">
      <div className="container px-4">
        <div className="max-w-6xl mx-auto">
          <div className="flex items-center gap-3 mb-12">
            <div className="w-1 h-12 bg-accent rounded-full" />
            <h2 className="text-4xl md:text-5xl font-bold">
              Explore alguns projetos que já desenvolvi:
            </h2>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {projects?.map((project, index) => (
              <div
                key={project.id}
                className="group bg-card rounded-2xl overflow-hidden border border-border/50 hover:border-primary/50 transition-all hover-lift animate-fade-in"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                {/* Project Image */}
                <div className="aspect-video relative overflow-hidden bg-gradient-to-br from-primary/20 to-accent/20">
                  {project.image_url ? (
                    <img 
                      src={project.image_url} 
                      alt={project.title}
                      className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center">
                      <span className="text-4xl font-bold text-gradient">
                        {project.title.charAt(0)}
                      </span>
                    </div>
                  )}
                  {project.iframe_url && (
                    <div className="absolute top-2 right-2">
                      <span className="bg-accent text-accent-foreground text-xs font-semibold px-2 py-1 rounded-full">
                        Interativo
                      </span>
                    </div>
                  )}
                </div>

                {/* Project Content */}
                <div className="p-6 space-y-4">
                  <h3 className="text-2xl font-bold group-hover:text-primary transition-colors">
                    {project.title}
                  </h3>
                  <p className="text-muted-foreground leading-relaxed line-clamp-3">
                    {project.description}
                  </p>
                  
                  <Button 
                    variant="outline"
                    className="w-full group/btn border-primary/50 hover:bg-primary hover:text-primary-foreground transition-all"
                    onClick={() => window.open(project.external_link, '_blank')}
                  >
                    Ver detalhes
                    <ExternalLink className="ml-2 h-4 w-4 group-hover/btn:translate-x-1 transition-transform" />
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};
