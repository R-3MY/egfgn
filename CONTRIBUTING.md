# Guide de Contribution 🤝

Merci de l'intérêt que vous portez à ce projet ! Voici comment vous pouvez aider.

## Flux de Développement (Workflow)

Pour maintenir une base de code propre, nous utilisons le flux suivant :

1.  **Branche `develop`** : C'est la branche de travail principale. Tout nouveau code doit y être intégré.
2.  **Branches Feature** : Créez une branche depuis `develop` pour vos changements (`feature/ma-feature`).
3.  **Pull Request** : Une fois votre travail terminé, ouvrez une PR vers `develop`.
4.  **Release (Production)** : 
    *   Les releases se font via une PR de `develop` vers `main`.
    *   La version doit être mise à jour dans `pubspec.yaml` et le `CHANGELOG.md` complété sur `develop` avant la PR.
    *   Une fois la PR fusionnée sur `main`, créez un tag Git (ex: `v1.0.0`) pour déclencher la publication Docker.

## Règles de conduite

- Soyez respectueux dans les échanges.
- Respectez le style de code existant (utilisez `dart format .`).
- Assurez-vous que `dart analyze` ne renvoie aucune erreur.
- Les tests doivent passer avant toute soumission.

