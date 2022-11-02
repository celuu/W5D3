PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    questions_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY(questions_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    questions_id INTEGER NOT NULL,
    parent_id INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY(questions_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    questions_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    liked BOOLEAN,

    FOREIGN KEY(questions_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);


INSERT INTO 
    users (id, fname, lname)
VALUES
    (1,'Morgan', 'Rector'),
    (2, 'Christine', 'Luu'),
    (3, 'Taylor', 'Swift');

INSERT INTO
    questions (id, title, body, user_id)
VALUES
    (10, 'I love you Taylor Swift', 'What is your favorite song from the Midnights album?', (SELECT id FROM users WHERE fname = 'Morgan')),
    (25, 'Food', 'Where is your favorite place to eat in SF?', (SELECT id FROM users WHERE fname = 'Christine'));

INSERT INTO 
    question_follows (id, questions_id, user_id)
VALUES
    (5, (SELECT id FROM questions WHERE title = 'I love you Taylor Swift'), (SELECT id FROM users WHERE fname = 'Morgan')),
    (6, (SELECT id FROM questions WHERE title = 'Food'), (SELECT id FROM users WHERE fname = 'Christine')),
    (7, (SELECT id FROM questions WHERE title = 'Food'), (SELECT id FROM users WHERE fname = 'Morgan'));

INSERT INTO 
    replies (id, questions_id, parent_id, user_id, body)
VALUES
    (17,(SELECT id FROM questions WHERE title = 'I love you Taylor Swift'), NULL, (SELECT id FROM users WHERE fname = 'Morgan'), "midnight rain rocks!" ),
    (18,(SELECT id FROM questions WHERE title = 'I love you Taylor Swift'), 17, (SELECT id FROM users WHERE fname = 'Morgan'), "lavender haze is amazinggg!" );


