CREATE TABLE osoba(
    pesel NUMERIC PRIMARY KEY,
    imie VARCHAR,
    nazwisko VARCHAR,
    data_urodzenia DATE,
    data_zgonu DATE,
    miejsce_urodzenia VARCHAR
);

CREATE TABLE pokrewienstwo(
    id_pokrewienstwo SERIAL PRIMARY KEY,
    rodzaj_pokrewienstwa TEXT,
    osoba1_pesel NUMERIC,
    osoba2_pesel NUMERIC,
    FOREIGN KEY (osoba1_pesel)  REFERENCES osoba(pesel),
    FOREIGN KEY (osoba2_pesel)  REFERENCES osoba(pesel)
);

INSERT INTO osoba(pesel, imie, nazwisko, data_urodzenia, miejsce_urodzenia) VALUES (1, 'Kamil', 'Sudoł', '1999-05-19', 'Stalowa Wola');
INSERT INTO osoba(pesel, imie, nazwisko, data_urodzenia, miejsce_urodzenia) VALUES (2, 'Ewa', 'Sudoł', '1969-01-21', 'Kraków');
INSERT INTO osoba(pesel, imie, nazwisko, data_urodzenia, miejsce_urodzenia) VALUES (3, 'Adam', 'Sudoł', '1966-07-25', 'Kielce');
INSERT INTO osoba(pesel, imie, nazwisko, data_urodzenia, miejsce_urodzenia) VALUES (4, 'Aleksandra', 'Sudoł', '2004-11-05', 'Sandomierz');
INSERT INTO osoba(pesel, imie, nazwisko, data_urodzenia, data_zgonu, miejsce_urodzenia) VALUES (5, 'Tadeusz', 'Sudoł', '1929-02-25', '2017-03-23', 'Tarnobrzeg');

INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('syn', 1, 2);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('syn', 1, 3);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('brat', 1, 4);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('mama', 2, 1);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('żona', 2, 3);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('mama', 2, 4);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('tata', 3, 1);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('mąż', 3, 2);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('tata', 3, 4);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('syn', 3, 5);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('siostra', 4, 1);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('córka', 4, 2);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('córka', 4, 3);
INSERT INTO pokrewienstwo(rodzaj_pokrewienstwa, osoba1_pesel, osoba2_pesel) VALUES ('tata', 5, 3);

-- informacje o danej osobie
SELECT * FROM osoba WHERE imie = 'Kamil' AND nazwisko = 'Sudoł';

-- informacje o rodzicach dla danej osoby
SELECT * FROM osoba JOIN pokrewienstwo p ON osoba.pesel = p.osoba1_pesel WHERE p.osoba2_pesel = (SELECT pesel FROM osoba WHERE imie = 'Kamil' AND nazwisko = 'Sudoł') AND (p.rodzaj_pokrewienstwa = 'tata' OR p.rodzaj_pokrewienstwa = 'mama');

-- informacje o rodzeństwie dla danej osoby
SELECT * FROM osoba JOIN pokrewienstwo p ON osoba.pesel = p.osoba1_pesel WHERE p.osoba2_pesel = (SELECT pesel FROM osoba WHERE imie = 'Kamil' AND nazwisko = 'Sudoł') AND (p.rodzaj_pokrewienstwa = 'brat' OR p.rodzaj_pokrewienstwa = 'siostra');

-- imiona dla posiadanych dzieci
SELECT imie AS imiona_dzieci FROM osoba JOIN pokrewienstwo p ON osoba.pesel = p.osoba1_pesel WHERE p.osoba2_pesel = (SELECT pesel FROM osoba WHERE imie = 'Ewa' AND nazwisko = 'Sudoł') AND (p.rodzaj_pokrewienstwa = 'syn' OR p.rodzaj_pokrewienstwa = 'córka');

-- informacje o małżeństwach
SELECT o.imie, o.nazwisko, p.rodzaj_pokrewienstwa AS stosunek_do, d.imie, d.nazwisko FROM pokrewienstwo p, osoba o JOIN osoba d ON(o.pesel = (SELECT osoba2_pesel FROM pokrewienstwo WHERE osoba1_pesel = d.pesel AND (rodzaj_pokrewienstwa = 'mąż' OR rodzaj_pokrewienstwa = 'żona'))) WHERE (d.pesel = p.osoba2_pesel AND o.pesel = p.osoba1_pesel);

-- informacje o wszystkich relacjach
SELECT o.imie, o.nazwisko, p.rodzaj_pokrewienstwa , d.imie, d.nazwisko FROM pokrewienstwo p, osoba o, osoba d WHERE (d.pesel = p.osoba2_pesel AND o.pesel = p.osoba1_pesel);