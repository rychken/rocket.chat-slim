# Publish commands

```
cd Rocket.Chat
vagrant-spk vm up && vagrant-spk dev
^C
vagrant-spk pack ../sequoia.spk && vagrant-spk publish ../sequoia.spk && vagrant-spk vm halt
```

# Reset commands

```
vagrant-spk vm halt && vagrant-spk vm destroy
```
