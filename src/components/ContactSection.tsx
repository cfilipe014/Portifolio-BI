import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import * as LucideIcons from "lucide-react";
import { LucideIcon } from "lucide-react";

export const ContactSection = () => {
  const { data: contacts } = useQuery({
    queryKey: ['contact_info'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('contact_info')
        .select('*')
        .order('display_order');
      
      if (error) throw error;
      return data;
    }
  });

  const getIcon = (iconName: string): LucideIcon => {
    const Icon = (LucideIcons as any)[iconName];
    return Icon || LucideIcons.Mail;
  };

  return (
    <section className="py-24 relative">
      <div className="container px-4">
        <div className="max-w-4xl mx-auto">
          <div className="flex items-center gap-3 mb-12">
            <div className="w-1 h-12 bg-accent rounded-full" />
            <h2 className="text-4xl md:text-5xl font-bold">
              Entre em contato comigo:
            </h2>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {contacts?.map((contact, index) => {
              const Icon = getIcon(contact.icon_name);
              return (
                <a
                  key={contact.id}
                  href={contact.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="group bg-card rounded-2xl p-6 border border-border/50 hover:border-primary/50 transition-all hover-lift text-center animate-fade-in"
                  style={{ animationDelay: `${index * 100}ms` }}
                >
                  <div className="flex flex-col items-center gap-4">
                    <div className="p-4 bg-primary/10 rounded-xl group-hover:bg-primary group-hover:scale-110 transition-all">
                      <Icon className="h-8 w-8 text-primary group-hover:text-primary-foreground transition-colors" />
                    </div>
                    <span className="font-semibold text-lg group-hover:text-primary transition-colors">
                      {contact.label}
                    </span>
                  </div>
                </a>
              );
            })}
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="text-center mt-20 pt-8 border-t border-border/50">
        <p className="text-muted-foreground">
          © 2025 Filipe Cavalcante. Todos os direitos reservados.
        </p>
      </div>
    </section>
  );
};
