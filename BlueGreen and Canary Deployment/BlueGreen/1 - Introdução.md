# Introdução

A estratégia Blue-Green de deploy no Kubernetes envolve manter duas versões do aplicativo (Blue e Green) em ambientes separados. A versão atual (Blue) atende o tráfego enquanto a nova versão (Green) é implantada e testada. Após a validação, o tráfego é redirecionado para a versão Green. Isso permite atualizações sem downtime, com a opção de rollback imediato para a versão Blue se houver problemas.
