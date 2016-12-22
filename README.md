# Climbing API Client

## Installation

```
$ git clone https://github.com/mastahyeti/climbing
$ cd climbing
$ bundle install
```

## Usage

To run the commands from the examples bellow, first launch `mp-shell`:

```
$ bin/mp-shell
```

## Examples

### Finding packages to download

#### Searching for packages

```
mp-shell> packages 'lander'
Wyoming → Lander Area → 110136004
```

#### Listing all packages

```
mp-shell> packages
International
  108057610 — Albania
  109056801 — Angola
  111933459 — Anguilla
  106070288 — Argentina
  107317326 — Armenia
  106661501 — Aruba
  ...
```

#### Downloading packages

```
mp-shell> packages 'Albania'
International → Albania → 108057610
mp-shell> download 108057610
```

### Querying routes and areas

#### Find big, moderate, multipitches in El Potrero Chico

```
$ bin/mp-shell
mp-shell> areas['El Potrero Chico'].where(
mp-shell>   type: 'Sport',
mp-shell>   rating: [:<, R['5.12a']],
mp-shell>   pitches: [:>=, 5]
mp-shell> )
+--------------------------------------+--------------+---------------+---------+
| Title                                | Rating       | Stars (votes) | Pitches |
+--------------------------------------+--------------+---------------+---------+
| Super Nova                           | 5.11a        | ★★★ (44)      | 8       |
| Excalibur                            | 5.10c        | ★★★★ (10)     | 6       |
| 3 Stone Place                        | 5.11d        | ★★★ (4)       | 6       |
| Off The Couch                        | 5.10d        | ★★★★ (26)     | 7       |
| Satori                               | 5.10c        | ★★★★ (67)     | 7       |
| Voodoo Trance                        | 5.10b/c      | ★★★ (3)       | 6       |
| Space Boyz                           | 5.10d        | ★★★★ (124)    | 11      |
| Black Cat Bone                       | 5.10d        | ★★★★ (51)     | 9       |
| Estrellita                           | 5.11a        | ★★★★ (150)    | 12      |
| Dope Ninja                           | 5.10b        | ★★★ (56)      | 6       |
| Snott Girlz                          | 5.10+        | ★★★★ (109)    | 7       |
| Pancho Villa Rides Again             | 5.10c        | ★★★★ (87)     | 5       |
| Treasure of the Sierra Madre         | 5.10c        | ★★★★ (98)     | 7       |
| Time Loves a Hero                    | 5.11c        | ★★★ (2)       | 8       |
| Pitch Black                          | 5.10+        | ★★★★ (48)     | 6       |
| El Sendero Diablo (The Devil's Path) | 5.11c        | ★★★★ (43)     | 6       |
| Devotion                             | 5.11d R      | ★★★★ (2)      | 15      |
+--------------------------------------+--------------+---------------+---------+
```

#### Find the most classic routes in Colorado

```
$ bin/mp-shell
mp-shell> areas['Colorado'].where(
mp-shell>   type: 'Sport',
mp-shell>   stars: [:>=, 4.5]
mp-shell> ).sort(:votes, reverse: true).limit(10)
+--------------------------+--------------+---------------+---------+
| Title                    | Rating       | Stars (votes) | Pitches |
+--------------------------+--------------+---------------+---------+
| Curvaceous               | 5.11c/d      | ★★★★ (264)    | 1       |
| Empire of the Fenceless  | 5.12a        | ★★★★ (220)    | 1       |
| Feline                   | 5.11b        | ★★★★ (205)    | 1       |
| Lats Don't Have Feelings | 5.11d        | ★★★★ (196)    | 1       |
| Animal Magnetism         | 5.11c        | ★★★★ (194)    | 1       |
| Ten-Digit Dialing        | 5.12c        | ★★★★ (193)    | 1       |
| Not My Cross To Bear     | 5.11a/b      | ★★★★ (185)    | 1       |
| Wet Dream                | 5.12a        | ★★★★ (176)    | 1       |
| Tabula Rasa              | 5.10c        | ★★★★ (169)    | 1       |
| Enchanted Porkfist       | 5.11a        | ★★★★ (144)    | 1       |
+--------------------------+--------------+---------------+---------+
```

#### Find the crags with the best 5.11's at Shelf Road

```
$ bin/mp-shell
mp-shell> areas['Colorado']['Canon City']['Shelf Road'].where(
mp-shell>   stars:  [:>=, 4.5],
mp-shell>   votes:  [:>=, 20],
mp-shell>   rating: [:>=, R['5.11a']]
mp-shell> ).where(
mp-shell>   rating: [:<, R['5.12a']]
mp-shell> ).areas

Colorado
    Canon City
        Shelf Road
            Cactus Cliff
                5.11b        ★★★★ (117)  Illegal Smile
                5.11d        ★★★★ (196)  Lats Don't Have Feelings
                5.11d        ★★★★ (96)   Gravitations
                5.11b        ★★★★ (141)  I Claudius
            Sand Gulch
                Contest Wall
                    5.11c        ★★★★ (25)   The Apple Bites Back
                    5.11b        ★★★★ (99)   Regroovable
                    5.11b        ★★★★ (67)   Silverado
                Free Form Wall
                    5.11c/d      ★★★★ (26)   Minimum Security
            Spiney Ridge
                5.11c        ★★★★ (83)   Purple Toe Nails
            The Bank
                5.11c        ★★★★ (31)   Thunder Tactics
                5.11b/c      ★★★★ (102)  Unusual Weather
                5.11b/c      ★★★★ (134)  Back To The Future
                5.11b        ★★★★ (89)   Lime Street
                5.11c        ★★★★ (56)   Lost Planet Airman
            The Dark Side
                5.11a        ★★★★ (144)  Enchanted Porkfist
            The Gallery
                Fish Wall
                    5.11d        ★★★★ (21)   Wading Through a Ventilator
                Menses Prow
                    5.11b/c      ★★★★ (97)   No Passion for Fashion
            The Gym
                5.11c        ★★★★ (115)  The Raw and the Roasted
                5.11d        ★★★★ (52)   In The Morning, You'll Be Mine
                5.11b        ★★★★ (52)   Crystal
            The North End
                5.11a        ★★★★ (20)   King Coral
                5.11b        ★★★★ (21)   The Function
            The Vault
                5.11a        ★★★★ (29)   Illusions
```
