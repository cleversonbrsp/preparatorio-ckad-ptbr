# preparatorio-ckad-ptbr

Repositório destinado a documentar minha jornada de preparação para prova CKAD.

Nessa jornada, estarei utilizando o 'minikube' como ambiente principal.
fonte oficial: https://minikube.sigs.k8s.io/docs/

---

# Para quem é essa certificação?

Essa certificação é destinada a engenheiros de Kubernetes, engenheiros de cloud e outros profissionais de TI responsáveis por construir, implantar e configurar aplicações nativas em cloud usando Kubernetes.

# O que essa certificação demonstra?

O Certified Kubernetes Application Developer (CKAD) pode projetar, construir e implantar aplicações nativas em cloud para Kubernetes.
Um CKAD pode definir recursos de aplicação e usar primitivas centrais do Kubernetes para criar/migrar, configurar, expor e observar aplicações escaláveis.
O exame pressupõe conhecimento prático sobre runtimes de contêineres e arquitetura de microsserviços.

# O candidato bem-sucedido terá familiaridade com:

– trabalhar com imagens de contêineres compatíveis com OCI
– aplicar conceitos e arquiteturas de aplicações nativas em cloud
– trabalhar com definições de recursos do Kubernetes e validá-las

# O que está incluído?

Duração de 2 horas
Exame baseado em desempenho
Certificação válida por 2 anos
Inclui elegibilidade de 12 meses
Inclui uma repetição do exame
Certificado em PDF e Badge digital
Simulador de exame

---

# Application Design and Build (20%)

Define, build and modify container images
Choose and use the right workload resource (Deployment, DaemonSet, CronJob, etc.)
Understand multi-container Pod design patterns (e.g. sidecar, init and others)
Utilize persistent and ephemeral volumes

# Application Deployment (20%)

Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
Understand Deployments and how to perform rolling updates
Use the Helm package manager to deploy existing packages
Kustomize

# Application Observability and Maintenance (15%)

Understand API deprecations
Implement probes and health checks
Use built-in CLI tools to monitor Kubernetes applications
Utilize container logs
Debugging in Kubernetes

# Application Environment, Configuration and Security (25%)

Discover and use resources that extend Kubernetes (CRD, Operators)
Understand authentication, authorization and admission control
Understand Requests, limits, quotas
Understand ConfigMaps
Define resource requirements
Create & consume Secrets
Understand ServiceAccounts
Understand Application Security (SecurityContexts, Capabilities, etc.)

# Services and Networking (20%)

Demonstrate basic understanding of NetworkPolicies
Provide and troubleshoot access to applications via services
Use Ingress rules to expose applications

fonte oficial: https://trainingportal.linuxfoundation.org/courses/certified-kubernetes-application-developer-ckad
