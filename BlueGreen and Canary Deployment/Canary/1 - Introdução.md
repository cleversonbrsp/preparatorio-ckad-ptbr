# Introdução

O Canary Deployment no Kubernetes é uma estratégia de implantação progressiva em que uma nova versão de um aplicativo (Canary) é lançada para uma pequena parcela de usuários, enquanto a maioria continua usando a versão estável. O tráfego é redirecionado gradualmente para a nova versão, monitorando sua performance. Se a nova versão for validada com sucesso, ela pode ser escalada e, eventualmente, substituir a versão anterior. Caso contrário, o rollback é feito rapidamente.
