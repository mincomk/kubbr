# Kubbr
Kubernetes `kubectl` short command generator

## What is Kubbr?
If you use `kubectl`, you may experienced inconvenience of long commands like:
```
kubectl get pods
```
So Kubbr makes a lot of short command alias like:
```
kgp
```

## Alias Rule
Command are organized by rule.
```
<BASE><ACTION><RESOURCE>
```
- **Base** Base means `kubectl`. It is `k` by default.
- **Action** Action means something like `delete`, `describe`, `get`. By default, they are `del`, `d`, `g`, respectively.
- **Resource** Resource is like `pods`, `statefulset`. Also `p`, `ss` respectively.
There are bunch of more short definitions and they are configurable!

## Default Configuration
Default configuration is located in [abbr.yml](/abbr.yml).

## Installation
### Prerequisites
- Haskell GHC
- Cabal
- HPack

### Build
```
hpack
cabal build
```
Then, the location of the binary can be found by:
```
cabal list-bin
```
