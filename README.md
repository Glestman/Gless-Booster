
## _Gless-Booster_



[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Esta ferramenta foi desenvolvida para ser usada como uma ferramenta de suporte para técnicos. É possível remover atualizações conflitantes do Windows Update. Ele também é capaz de executar tarefas de otimização do sistema,parametrizando tempo melhor de resposta,menor delay de transição de janelas,diminuição de tempo de inicialização,reinicialização e desligamento da maquina,além de resolução de erros de fila de impressão em loop, e limpeza de cache e renovação de DNS da máquina.

A ferramenta foi realizada de diferentes formas, tanto em batch para maior performance e também em powershell afim de atender a atualização de aplicação.


![2022-03-23 21_47_39-Administrador_  Desinstalar atualizações do Windows by @DuanyDias](https://user-images.githubusercontent.com/30185749/159823440-815bd508-a933-42a4-b1b7-0b41082e8ba9.png)

Funciona por meio da linha de comando, mas requer requisitos básicos, como um sistema operacional compatível, execução com privilégios de administrador, etc.

Este documento foi criado para descrever as seqüências do processo para o uso correto da ferramenta de redefinição do Windows Update.



## Recursos

- Otimização do Sistema Operacional
- SpeedBooster Boot,Reinicio,e Desligamento
- Restart Spool de Imprensão e fila pendente
- Renovação de DNS/IP
- Remoção de atualizações do Windows Update



> A utilização do Batch têm o intuito de proporcionar
> uma aplicação ágil, e leve e fácil manuseio.


This text you see here is *actually- written in Markdown! To get a feel
for Markdown's syntax, type some text into the left window and
watch the results in the right.


## Instrução


Gless-Booster possui como requisito a execução como administrador.

Inicializando a aplicação.


![xcxc](https://user-images.githubusercontent.com/30185749/235239217-c3936be8-11f9-44ca-b656-02647200c891.png)


Selecione a opção desejada.

```sh
     1. Otimizacao do Sistema            
     2. Encerramento mais rapido                                  
     3. Reset Spool Impressora           
     4. Renovar IP da máquina           
     5. Desinstalar atualizações do Windows Update
     6. Desativar Windows Update
     7. Otimizacao Taxa de Transferência
     8. Modo  Desempenho Maximo Plano de Energia 
     9. Limpar Arquivos Temporários

```

1. Otimizacao do Sistema 
```sh
   Será realizado a execução de instruções que irá 
   interromper tarefas que exige do processado
   e não e utilizado muito, além de modificações
   em parametros, otimizando transições de telas 
   entre outros
 
```
2. Encerramento mais rapido  
```sh
   Modifica parâmetros de inicialização,
   reinicio,e desligamento da máquina
  
```

3. Reset Spool Impressora   
```sh
   Remove o loop na fila de impressão,
   limpa a pasta Spool,reinicia spool service
  
```
4. Renovar IP da máquina
```sh
   Renova o IP e o DNS
  
```
5. Desinstalar atualizações do Windows Update
```sh
   Possibilita remover a atualização conflitante apenas,
   ou todas atualizações do Windows de forma automática
  
```
6. Desativar Windows Update
```sh
  Desativa a atualização do Windows Update
  
  
```
7. Otimizacao Taxa de Transferência  
```sh
   Realiza otimização para máxima taxa de transferência USB
  
  
```
8. Modo  Desempenho Maximo Plano de Energia 
```sh
Realiza importação e ativação de plano de energia Desempenho Máximo,aproveitando o máximo do desempenho da máquina
  
  
```
9. Limpar Arquivos Temporários
```sh
Realiza limpeza dos arquivos da pasta Temp

  
  
```
## Requisitos
Microsoft Windows 7 ou mais atual.


## Contribuições são bem-vindas

## Licença
MIT

**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

 
