use ig_clone;

-- INITIALLY ANALYZING THE COLUMNS THAT WE ARE HAVING IN TABLES FORMAT USING BASIC SELECT STATEMENTS

SELECT * FROM comments;
SELECT * FROM follows;
SELECT * FROM likes;
SELECT * FROM photo_tags;
SELECT * FROM photos;
SELECT * FROM tags;
SELECT * FROM users;

-- ANALYZING THE DATA EVEN MORE BY JUST USING DESC FUNCTION TO KNOW WHAT DATATYPE AND ANY NULL VALUES PRESENT 
DESC comments;
DESC follows;
DESC likes;
DESC photo_tags;
DESC photos;
DESC tags;
DESC users;

-- NOW WE WILL DEEP DIVE INTO OUR MANDATORY PROJECT QUESTIONS
-- NOTE : FOR BETTER UNDERSTANDING ALL KEYWORDS ARE DENOTED WITH UPPER CASE

-- 2)We want to reward the user who has been around the longest, Find the 5 oldest users.

SELECT * FROM users
ORDER BY created_at asc
LIMIT 5;

-- 3)To understand when to run the ad campaign,figure out the day of the week most users register on?

SELECT dayname(created_at) AS d, COUNT(*) AS user_count FROM users
GROUP BY d
ORDER BY user_count DESC; -- Hence on Thursday and Sunday more users Registered.

-- 4)To target inactive users in an email ad campaign, find the users who have never posted a photo.

SELECT id FROM users
WHERE id NOT IN(SELECT user_id FROM photos);

-- 5)Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

SELECT users.username,photos.image_url,COUNT(likes.user_id) AS co FROM likes
JOIN photos ON photos.id=likes.photo_id
JOIN users ON users.id=likes.photo_id
GROUP BY users.username
ORDER BY co DESC
LIMIT 5;

-- 6)The investors want to know how many times does the average user post.

SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users))AS average;

-- 7)A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags

SELECT tags.id AS tag_id,tags.tag_name,COUNT(*) as total_tags
FROM tags JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total_tags DESC
LIMIT 5;

-- 8)To find out if there are bots, find users who have liked every single photo on the site.

SELECT users.id AS user_id,users.username AS user_name,COUNT(*) AS total_likes
FROM users JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes = (SELECT COUNT(*) FROM photos);

-- 9)To know who the celebrities are, find users who have never commented on a photo

SELECT username FROM users
WHERE id NOT IN(SELECT user_id FROM comments);

-- 10)Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.

 WITH cte1 AS
     (
    WITH cte AS 
     (
     SELECT user_id,COUNT(photo_id) AS photo_id_count
	 FROM comments 
	 GROUP BY user_id
	 ORDER BY user_id
     ) SELECT * FROM cte
       WHERE photo_id_count = (SELECT count(id) FROM photos)
	)SELECT user_id FROM cte1
	 UNION 
     SELECT id FROM users
     WHERE id NOT IN(SELECT user_id FROM comments);

    
