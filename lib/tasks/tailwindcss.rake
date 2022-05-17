def plugins?
  system('grep -q daisyui config/tailwind.config.js')
end

raise 'Consider removing this patch' unless Rails.version == '6.1.4.1' && Tailwindcss::VERSION == '2.0.8' && plugins?

Rake::Task['tailwindcss:build'].enhance(['yarn:install']) if Rails.env.production?
