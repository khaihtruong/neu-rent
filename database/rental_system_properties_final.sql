CREATE DATABASE IF NOT EXISTS rental_system;
USE rental_system;
DROP TABLE IF EXISTS broker_tenant;
DROP TABLE IF EXISTS rent;
DROP TABLE IF EXISTS bus;
DROP TABLE IF EXISTS subway;
DROP TABLE IF EXISTS bus_station;
DROP TABLE IF EXISTS subway_station;
DROP TABLE IF EXISTS public_transport_station;
DROP TABLE IF EXISTS convenience_store;
DROP TABLE IF EXISTS restaurant;
DROP TABLE IF EXISTS property_neighborhood;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS landlord;
DROP TABLE IF EXISTS tenant;
DROP TABLE IF EXISTS job;
DROP TABLE IF EXISTS occupation;
DROP TABLE IF EXISTS financial_provider_user;
DROP TABLE IF EXISTS financial_provider;
DROP TABLE IF EXISTS broker;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS international_student;
DROP TABLE IF EXISTS us_citizen;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS user_auth;

-- Create database
CREATE DATABASE IF NOT EXISTS rental_system;
USE rental_system;

-- Drop tables if they exist to allow for clean creation
DROP TABLE IF EXISTS broker_tenant;
DROP TABLE IF EXISTS rent;
DROP TABLE IF EXISTS bus;
DROP TABLE IF EXISTS subway;
DROP TABLE IF EXISTS bus_station;
DROP TABLE IF EXISTS subway_station;
DROP TABLE IF EXISTS public_transport_station;
DROP TABLE IF EXISTS convenience_store;
DROP TABLE IF EXISTS restaurant;
DROP TABLE IF EXISTS property_neighborhood;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS landlord;
DROP TABLE IF EXISTS tenant;
DROP TABLE IF EXISTS job;
DROP TABLE IF EXISTS occupation;
DROP TABLE IF EXISTS financial_provider_user;
DROP TABLE IF EXISTS financial_provider;
DROP TABLE IF EXISTS broker;
DROP TABLE IF EXISTS user_type;
DROP TABLE IF EXISTS neighborhood;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS international_student;
DROP TABLE IF EXISTS us_citizen;
DROP TABLE IF EXISTS user_auth;

CREATE TABLE user_auth (
    auth_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME,
    account_locked BOOLEAN DEFAULT FALSE,
    failed_attempts INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_username UNIQUE (username)
);

CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    auth_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT uk_user_phone UNIQUE (phone),
    CONSTRAINT uk_user_email UNIQUE (email),
    CONSTRAINT fk_user_auth FOREIGN KEY (auth_id) REFERENCES user_auth(auth_id) ON DELETE RESTRICT
);

CREATE TABLE landlord (
    user_id INT PRIMARY KEY,
    CONSTRAINT fk_landlord_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE tenant (
    user_id INT PRIMARY KEY,
    CONSTRAINT fk_tenant_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE neighborhood (
    neighborhood_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uk_neighborhood_name UNIQUE (name)
);

CREATE TABLE properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    street_number VARCHAR(10) NOT NULL,
    street_name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    square_foot DECIMAL(10,2) NOT NULL,
    for_rent BOOLEAN NOT NULL DEFAULT TRUE,
    price DECIMAL(10,2) NOT NULL,
    room_amount INT NOT NULL,
    landlord_id INT NOT NULL,
    CONSTRAINT uk_property_address_room UNIQUE (street_number, street_name, city, state, room_number),
    CONSTRAINT fk_property_landlord FOREIGN KEY (landlord_id) REFERENCES landlord(user_id) ON DELETE CASCADE
);

CREATE TABLE property_neighborhood (
    property_id INT,
    neighborhood_id INT,
    PRIMARY KEY (property_id, neighborhood_id),
    CONSTRAINT fk_property_neighborhood_property FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_property_neighborhood_neighborhood FOREIGN KEY (neighborhood_id) REFERENCES neighborhood(neighborhood_id) ON DELETE CASCADE
);

CREATE TABLE restaurant (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    street_number VARCHAR(20) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    neighborhood_id INT NOT NULL,
    CONSTRAINT uk_restaurant_address UNIQUE (street_number, street_name, city, state),
    CONSTRAINT fk_restaurant_neighborhood FOREIGN KEY (neighborhood_id) REFERENCES neighborhood(neighborhood_id) ON DELETE CASCADE
);

CREATE TABLE convenience_store (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    street_number VARCHAR(20) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    neighborhood_id INT NOT NULL,
    CONSTRAINT uk_store_address UNIQUE (street_number, street_name, city, state),
    CONSTRAINT fk_store_neighborhood FOREIGN KEY (neighborhood_id) REFERENCES neighborhood(neighborhood_id) ON DELETE CASCADE
);

CREATE TABLE public_transport_station (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    neighborhood_id INT NOT NULL,
    station_type ENUM('subway', 'bus') NOT NULL,
    CONSTRAINT fk_station_neighborhood FOREIGN KEY (neighborhood_id) REFERENCES neighborhood(neighborhood_id) ON DELETE CASCADE
);

CREATE TABLE subway_station (
    station_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uk_subway_station_name UNIQUE (name),
    CONSTRAINT fk_subway_station FOREIGN KEY (station_id) REFERENCES public_transport_station(station_id) ON DELETE CASCADE
);

CREATE TABLE bus_station (
    station_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uk_bus_station_name UNIQUE (name),
    CONSTRAINT fk_bus_station FOREIGN KEY (station_id) REFERENCES public_transport_station(station_id) ON DELETE CASCADE
);

CREATE TABLE subway (
    subway_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_license VARCHAR(20) NOT NULL,
    color VARCHAR(30) NOT NULL,
    station_id INT NOT NULL,
    CONSTRAINT uk_subway_license UNIQUE (vehicle_license),
    CONSTRAINT fk_subway_to_station FOREIGN KEY (station_id) REFERENCES subway_station(station_id) ON DELETE CASCADE
);

CREATE TABLE bus (
    bus_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_license VARCHAR(20) NOT NULL,
    bus_number VARCHAR(20) NOT NULL,
    station_id INT NOT NULL,
    CONSTRAINT uk_bus_license UNIQUE (vehicle_license),
    CONSTRAINT uk_bus_number UNIQUE (bus_number),
    CONSTRAINT fk_bus_to_station FOREIGN KEY (station_id) REFERENCES bus_station(station_id) ON DELETE CASCADE
);

CREATE TABLE occupation (
    occupation_id INT AUTO_INCREMENT PRIMARY KEY,
    occupation_name VARCHAR(100) NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_occupation_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE job (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    occupation_id INT NOT NULL,
    proof_of_income BLOB,
    CONSTRAINT fk_job_occupation FOREIGN KEY (occupation_id) REFERENCES occupation(occupation_id) ON DELETE CASCADE
);

CREATE TABLE financial_provider (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    passport_id VARCHAR(30) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    CONSTRAINT uk_financial_provider_passport UNIQUE (passport_id),
    CONSTRAINT uk_financial_provider_phone UNIQUE (phone)
);

CREATE TABLE financial_provider_user (
    provider_id INT,
    user_id INT,
    PRIMARY KEY (provider_id, user_id),
    CONSTRAINT fk_financial_user_provider FOREIGN KEY (provider_id) REFERENCES financial_provider(provider_id) ON DELETE CASCADE,
    CONSTRAINT fk_financial_user_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE broker (
    broker_id INT AUTO_INCREMENT PRIMARY KEY,
    ssn VARCHAR(11) NOT NULL,
    license_id VARCHAR(30) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    CONSTRAINT uk_broker_ssn UNIQUE (ssn),
    CONSTRAINT uk_broker_license UNIQUE (license_id),
    CONSTRAINT uk_broker_phone UNIQUE (phone)
);

CREATE TABLE broker_tenant (
    broker_id INT,
    tenant_id INT,
    PRIMARY KEY (broker_id, tenant_id),
    CONSTRAINT fk_broker_tenant_broker FOREIGN KEY (broker_id) REFERENCES broker(broker_id) ON DELETE CASCADE,
    CONSTRAINT fk_broker_tenant_tenant FOREIGN KEY (tenant_id) REFERENCES tenant(user_id) ON DELETE CASCADE
);

CREATE TABLE rent (
    rent_id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT NOT NULL,
    property_id INT NOT NULL,
    contract_length INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    broker_fee DECIMAL(10,2),
    broker_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT uk_tenant_property_date UNIQUE (tenant_id, property_id, start_date),
    CONSTRAINT fk_rent_tenant FOREIGN KEY (tenant_id) REFERENCES tenant(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_rent_property FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_rent_broker FOREIGN KEY (broker_id) REFERENCES broker(broker_id) ON DELETE SET NULL
);


CREATE TABLE us_citizen (
    user_id INT PRIMARY KEY,
    ssn VARCHAR(11) NOT NULL,
    CONSTRAINT uk_us_citizen_ssn UNIQUE (ssn),
    CONSTRAINT fk_us_citizen_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE international_student (
    user_id INT PRIMARY KEY,
    passport_id VARCHAR(30) NOT NULL,
    CONSTRAINT uk_intl_student_passport UNIQUE (passport_id),
    CONSTRAINT fk_intl_student_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE student (
    user_id INT PRIMARY KEY,
    transcript BLOB,
    CONSTRAINT fk_student_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);


-- ✅ All tables created. Proceeding with data inserts below.
SELECT 'All tables created. Proceeding with inserts...' AS status;

INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (1, 'user1', '10b842e7c83e2864348b78537d62abfb0352d47c5db4ed267e8658d4eff4dbce', 'ELIbL6wc44cWTDsH', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (2, 'user2', '826b753a95cac0841f2d5d47258d5f6eb6716371fada24c67af0e9f0652b5355', 'e3TK0wR33BiWeFq7', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (3, 'user3', '9aef918785da09e55772f6f155a00eee8f02faa6b47e379ec7014595dcac5975', 'oGsSAlHIJdEYwPwH', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (4, 'user4', 'a745484c58258e08b95851730a704243be4cdee44eb9c3f6be057db14d09856b', '2GKvWFb7YWPlDZ3E', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (5, 'user5', '04bab2cf176fd8b39f3c6943a9ad08374078cc3e6ca4ba2427c3dec9fec8cb56', '5B9hloIZ2b2Fyheo', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (6, 'user6', 'bca737596276995f73106f44616c7807e33945569bcc3dbc87190534006decdd', '1pKtdvbV1WQUQ5zy', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (7, 'user7', '9c45641f67f7a52cc77b30607bd3882482d90b012595ea8e9459c651c2d1eaec', '2wVLkXnE5G81UMMZ', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (8, 'user8', '2f4ab20c21aa2415602f07b24a11e37a07708e435705125ef32c99581967ad10', 'y1EWDL6pN68rCWSC', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (9, 'user9', 'c71f69b8fb65d7b7b17363ccc9427434dc0f0af868cdada89b988601b1ff5e36', 'Hd8vMYFs6e6oxbHT', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (10, 'user10', '5ac06cdd3c90ea87c074928970619167c395b7549036a9496e0b883e75928cd2', 'FfEUGa6bLPVGC8IL', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (11, 'user11', '63c62d761e7c953b96d12d0f5308857061c1bbf40d0925f9981def43aba369ea', '9gyM1cBrlmievGp1', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (12, 'user12', '540d2d7667dd19a2ca09ef95b653202ac86aa89a4dc1630d53e759be775918bd', 'VBJgh8lmYEWAHXiY', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (13, 'user13', '2f05f68a8838f9e3888b5c467fc671b8c2e22927264a3a070c4e093766908f40', 'wm5kSWR1Msp2wubx', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (14, 'user14', 'dfe1b49b403f665bdf06e56e488e5f146bca5c6e88a19da7daeda0bfa032f865', 'X9XdmowHK2GE4tYF', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (15, 'user15', '860b3f83ffc4a7c99b9495c4b879517dbe0e67e9781e36bc0531befd5dd0fe14', 'fmHCBqo8Vf6NTO71', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (16, 'user16', 'd1a02b0f4bf364d5b537b03a4d8d5dd1697963d38f2ae4af5db07dda497c922e', 'vtVozGEW7h7o5IMa', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (17, 'user17', '17ae3d1caefbbbdbd79959d9a5080e10ca747665341dc222c31d448b3dfaeb0c', 'Yq6P9zxIJmY55lsJ', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (18, 'user18', '6b25f1f08a9871144b4acdab2e91ca0586cb2b78cc1c34a2209578bd87e93cb0', 'OIy25In2GTDNJA34', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (19, 'user19', 'b078b3334eb6d8b5cdd021873c00f8d944c9abf2def7633d7a5fc3375aabc4df', '3Lvq9vCbV3yTKyNf', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (20, 'user20', '09543f01725014a6a10ad4a642daa6b1742acbea4c8645f6732e0a96b475d19d', 'LY9I9zksMuILYvtB', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (21, 'user21', 'f99169e1791aca14ff7e04a345b0950be63e79d881f2f978773c943fc3387f5d', 'R18lNzmjVSjWMIhX', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (22, 'user22', '90afd38586838779d80b1bafc101c2f5156094f202b466905547856d7ea7c258', 'Nb3HgCx2FHL77qFl', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (23, 'user23', '1e23a91c448dbece2705630a6203d7b0f509869629beb94abf2c4770f8595aac', 'fAvgXxHmpfoEWC9e', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (24, 'user24', 'ef3e8f4448b24f2c0667d59d6fc081532cae9a5164bbbef2f7335782534650ca', 'WQbjCJbO9E4gmxuL', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (25, 'user25', 'bc125577b6a5ad4c4e6ad1676c247b05c78ad603d95acd9d6a1059bd645fd47b', 'RNaOL7eicKz1p2Bw', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (26, 'user26', 'a74ea0ff96d94d8af8ffacef6516bbcd596965e95ced8b3f150aa7c3f179d1a3', 'AI4F5SqYN60cG8Ap', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (27, 'user27', '5eb594256a53b62d60ada1f3dfddbb4c2edddc8bec48d4cfd19cae4b219e8558', 'kR5AUGzdTGLthAmE', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (28, 'user28', 'd924fa927ff978623a69a6f1d160b13ebc31cb89d9b3158726f9305470384320', 'yzDakef6L0zdpIGa', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (29, 'user29', 'e0f94d2a020b6845b0a9fd8976d80e00c5664ca99117f48dc92a57f0dfe7d1ca', 'aszNlsna6RFZJT2K', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (30, 'user30', '8369e1f65011ccf338de689fa55e5011ec64890cddc1f6ea9c93048dbd4d32d5', 'NsrusK6QCfBw16vK', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (31, 'user31', '0a46fa5622dab25f68b8db38d00a1cc548f1e1b4d05ecfec813f4749a3d47710', 'XFn41fVAD3i8M8vd', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (32, 'user32', 'a4db9176df8a883c0a09ff8f37d5585ce51e6c63d36845feaad8b8919f760021', '2dAJ3WfEcDGeTmp2', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (33, 'user33', '3a1f6b7d631aa77c6a1ba3a647ce52b6fd0ae903d7c2e54403d6df63bfb643ea', 'BMLlE8GeZXqdrkaM', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (34, 'user34', '3fb824e0a2b7d51f7ffcc42331495ec8dbb770910339ccee4cf645245a1cbd65', 'PdTQU6HGdjsZUvqe', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (35, 'user35', '846cbb87cb4e66c37d8d8b3e425cf2879b60ed9b026bff7cbabe83e4acf4e611', 'e1jJcphJGjjKq1Rg', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (36, 'user36', 'a7ceca8287ea42e76c916bd6184e1ba82bc53603a380b804a8ee3a5c1cdb8549', 'PnGTVrasNx3Dzzah', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (37, 'user37', '046545df6d08b841a52a201afe5a3b08e568c37b43b958fbee625c6a48dd832d', 'aRgGjMhdVnY9b9Ul', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (38, 'user38', '41013218c71a687e69fec3f31ffc1c4f678ce5738e47ca1f58b838c2688f63db', 'OTmA2Yu7DqWUwNg6', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (39, 'user39', '6d94003addc4203be2823a5165ad1ea5c3956b6716088881d5b7202ca8595e9d', 'VXvt1jQxM6HRqkw7', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (40, 'user40', '7a7355c4bca0fc4dacbc5e16ba1b721c791dce616983a62e59f698ec3f86f8dc', 'oruhJ69S06HAN4p7', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (41, 'user41', '106cf2e8853e9c05a38700f5f406a7ba0cadc6c7713fbb26bb78c4d71892ecc8', '1VDcKetr2TTDK43A', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (42, 'user42', '3c4a853ae046177f5ce8d420fdab65ceaff20112568682abe30029c18519726d', 'Jl0SdNze4ue0yOnN', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (43, 'user43', '866eef1890b517d6acddddb47aa87406c243429754fcb3bffc30e734ad3cfca7', '7NDHAwmgiTHByFZr', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (44, 'user44', '9ed5eff316ba425d91f3f60c6b2db89c3b0b363628b7144532a655c2d9b69988', 'Ua3dcO0Z27jX903A', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (45, 'user45', 'e077e2fb96112150f7124ce788f41a3de2d112a97af9108f00d212ec70ae9c9b', 'ba0mDOGEhKkBqKLJ', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (46, 'user46', '4b85132b37c4c541ea410de3357b57f60ae0f2a1f431cb92cb198d618ec26342', 'KMYsRG5kTplE9Gnf', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (47, 'user47', 'b01a0036a4f1e314132c0afa9bc74efc7b91f3f5f4ebc3ab5484e1606bc79695', '888JAcqtoH7vdX9w', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (48, 'user48', '21fedba90776d52c23258a612df4c831c4206fafa3ae643d2c7d224cce277632', '0Er6ns6TD9T7hcNk', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (49, 'user49', 'ac923a7c581a8e5856b9bcddc4b6bc439d8eadcb2e0e6715e794577569927478', 's0NGGVGNFna0FHPu', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (50, 'user50', '2ccafb60fd6d449c29641c0fe382fa02043087b64cee5414022c1a84cdc7a0d4', 't2Sdo1wv0UawY2xN', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (51, 'user51', '8a06358b303df15ede74f4c1ab67e418495a2df95f96243ece51bfac3f15247f', '4TUeXqk6GbPy8Zxs', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (52, 'user52', '4af0fd470b8d5595e5815d67496deef54f7056fd4df684633b9408d67f48ddf8', 'xQAhPTvT1GwYN2J0', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (53, 'user53', 'd6ba80d79862903d0108ceb96aa7c38fe776dc4760ed1419524b5165b37bf899', 'Rgsi3MgXYPfYq8zE', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (54, 'user54', '40a9bee4c03b91e3480a579c3f972ac0cd35f0dbc52cedaed9584ba6fa1a915f', 'sqnV5s3ibfN034MZ', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (55, 'user55', 'e852585a6fab2a9408082e824405bc92dd36de265b7fcf64e8b41ba4e29e22c6', 'O5VIM8RumM9txwDu', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (56, 'user56', '5b0e7fbfb70d865b2e4f6580fcbe9968df66dcca6ae6968567be9b2f45df3154', 'rgmdaxo6XdxzHCWR', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (57, 'user57', 'bf0b24b3af8e7edbc452d98be23612485ceb20b83508b7f353bf79a8fad3e946', 'faocMNunKXf0COdk', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (58, 'user58', '45a719acc313d3a09e26a6333642fc42ab282cf26ad21828ac3c907b5a63cbc5', 'fFsqJe9fAG2RvAuC', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (59, 'user59', 'ec1c771e264e182b88561b1b1ac6ba5c96d358198ed4ab298617a271e21c146c', 'F0QIg12L5tEuw5gs', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (60, 'user60', '65a6a507bd43bef1db8eb4540825da40252bb29de02ae1b620e32f144d05d758', 'gSTG13mYSAYzxfcT', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (61, 'user61', '28ddb3ac0ac5d6e8505896b33a137003a992c5686120a258df910418706631f3', 'xB4yCJ1Z9lR9TPV0', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (62, 'user62', '9c5a04fb596670371c50ef1b1234f2b0bc2852fba09b3a84d9a93302f6675b1b', 'ql6tl8Hzx6lzPf2l', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (63, 'user63', '10f542f1f95b964dd9b1c61fbd93ec5781fff578654564e0f18dc4ee891428bc', 'EcKJ1Yuolp2f6Fft', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (64, 'user64', 'afbe8b398a90fa46f48c4e2271a8617699a4b6d8cdd959d2adc378863e5e9536', 'GGrjScAKbeTxODlJ', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (65, 'user65', '6f5ba6ba547651e2ece508d9481940e7c420074d29eee055a5aad021a6339e5c', 'idjFqAMKHaodSEFr', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (66, 'user66', '8b4cd843f212e4bfffbe284351e9fc1a5de1a4a04362873a9fa72a00174c6861', 'IdLQDZiipjAnLUJK', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (67, 'user67', '6ae2d9a85e2a9c85515a68d2e43e4ab21b5b61fb05a06ddde6c5915faacef9b5', '3AFn4NquxhTS8yj9', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (68, 'user68', '3feb9cd809f226ec2679965eae65f39bf267407da3246e46a1c00425bd440ae5', 'xdmyk4hwsWqIDo9G', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (69, 'user69', '4715825ce6db4a8747df7f1ac898584b28adac931bb465daebb1f3a3b332c8fb', '2CLKEqzkJPH0Wovt', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (70, 'user70', '19d957554f961a78fcb958e784492ece476f11532e6bb0372db5fb1fa5a05e46', 'wLC7KfSH5rtN6aRN', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (71, 'user71', 'fc4e706c87306719cae32dd3049e98eaae9c27766cd14c36636eedc9e1c1c8d4', '2N0k2p6kTmogyBxA', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (72, 'user72', 'a61dd6e38878dbc403f5cd1834f3435c4a71abbb84eca91d78f10bbcb96ce8db', 't0Qf0zCEmf33wsiB', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (73, 'user73', '6c124bc7b2e0fbb78eebe97ee80fb04615860db451ec1dfadb0436d53d5d1cf1', 'reoqTu1NqRNYWGDf', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (74, 'user74', '6a2e49eb0e43b4705519f129211fbbad3ad2b6a1d2f2c444cb155da1b7526a42', '19iIPGHsMDbndF8v', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (75, 'user75', '19016884b14b23a7e53801fd34471f748642678d724c03ded5bb513e31acb71b', '1JjKcVJX7UKtSfJg', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (76, 'user76', '5322ae62acd6164017422e239fa15715efe09032241c90f33731122350844cc6', 'dRRskVlBm5rEv9Te', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (77, 'user77', 'f6b986c5b8e6837356420e5fa3c2c30574ecc157ad5ffaf2201b6abfb1f106db', 'u8OdYWRQM7lCYgzh', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (78, 'user78', '69d063055ab6467b67c61d33cb6ad792813243e554844add9d448e68b555788a', 'TFPWqQ0JuxQRqSlu', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (79, 'user79', '979fba2173245a48f1d4150b16c7efaeb5b388925eef1bf3bce7dfc8c199a7a1', 'vCWGhdnklSNg8zEc', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (80, 'user80', '5304c00785dbdeb1ee4e555736a9deb46dbf13e3205e2132caad6ff6161e6902', '6vQ0ySRLPWDsq2Uk', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (81, 'user81', 'a3dc3729a725819eb173805ee032c4156f82519595919187d6eb9ceda30f7fd3', 'b08O68GfgplFxNYq', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (82, 'user82', '9b27c70e9191ea0e51558306c0e43682c085e4f658a246f4bcd1e8df8aa1f1a4', '98CyBOsZAhc0CEqV', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (83, 'user83', 'c5ac3c3538a261de2cdbd02849f947bc4cf2519f50192c6551340bde110d8e88', 'Fi93XpwLIGOCwfXB', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (84, 'user84', '074d5198f79615ee6af95687300fd59bea9582b4aa3c37a920d4ad24ef42a066', 'ZE4o6OZrsUxELXCz', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (85, 'user85', '7ab15e47e6e6e5d17fe7b44c50f88883c44efa71e6c78af6c62501d0e686e81e', 'io4Y79B7N5xhjMdz', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (86, 'user86', '5008a07b8669434720704f49d01f269aa5ecd559a170ad76de81cc4c9e6d9e85', 'acfZmnmpXGACp21B', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (87, 'user87', 'd334c0fcb5204b580aeb19d70cad73767ad030f9a2da793ac2e4769dee7a25ce', 'C3LytpnNpMNX8twJ', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (88, 'user88', '9ef27873b548ae1b834c9f4fffded1d04822b96f153f9191ee545dd84464c730', 'NwHmuz3L3HXzwgJh', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (89, 'user89', '2f9ac4da8c040c28fc667dfc490742579b69a5e312d73ce8f605e2ba402775e5', 'VOc3wHjUt9ITXVOY', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (90, 'user90', '2345c23725f4ca6b088390782b34fd1d1427fdb35706d1e0ceb32914984b9cbc', '57nTosqDinkHXNbp', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (91, 'user91', '0e060a7e6ef6ee338feb90bab5cacaf1f12715acf1e835341bad99ea70918b06', 'xp94ihKGz7kDhsGa', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (92, 'user92', '4bfeb912930422033f56524c0f154d95f16a3b7b64ebfe6981303c94b594d018', '6J7V1kafQYegwXOY', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (93, 'user93', 'ff3dd61da7df7971adbc28316961ed4d07349690265762facf9e69df22f244db', 'OjSdVUo9yEeDBvIW', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (94, 'user94', '13775419b67e50923404a594b2bbd1b36f62900df69cbafe3876bcc6d2ef4fcd', 'gEgR9374pVAj8KUO', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (95, 'user95', '58b85dfaaf7a3efca95bf6efed74e93fb12f9f71bf46bac3c35115cd0ddcc09f', 'FkgnpQ9RBFIFbk8U', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (96, 'user96', '77a3f0f081206fe960a1dc46d4b3a9b5f1f7fbe75704620cc8a4c9c50243fb20', 'jMnOGJ2M6S4TmFCw', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (97, 'user97', '0217539a593dbee1d2856dbf6bf20828d4818ed91d0e849c9f8bcde426ed4a15', 'WH4CLYZl25V0rj8P', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (98, 'user98', '2291c9f38eb6928a0bd295f671f712ee79422fa5f53ce3644679306fa56640d7', 'y8Nvwol9eAyCPwm0', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (99, 'user99', '46be5a4ed014aa73924a6b0fa5c0d64f61804d74daa99e14de22ae4c710b6a3c', 'BDBSuBQA0mOOLt1o', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (100, 'user100', '741cdaa1e5e5925029d0f31411c53ebcc345bd4ec1b0bf7a4512be89136fa8b4', '1JB7uxEr45t8744x', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (101, 'user101', 'dfb4c7058769a61a0b0e79667efa3415ca0713c247b257e14ad0cb432a3a1b30', 'PdeAqfq3HcKMFjBg', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (102, 'user102', '688840e3d0ded97ca1004bcb7d23e402df62bf73f62ea091d0541b53cbaa14c3', '7CzNOCpYTLl9vTr7', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (103, 'user103', 'b78921b1c65e52f764faede9e0e754572b9a247cda7cffe1a365d6d3e94357ab', 'eyWke2v3szKRVLyy', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (104, 'user104', '73987a11a72c6799cdf377213e6971ccdd5319b20a97b0bf98a672186b342f00', '1wKrUJEaxQaCzLPz', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (105, 'user105', '48c47e0503b8edcc4e9b7be8331fafb46c415cb08116b332f56e6c8f309f85f4', 'kdQac6QNbErCDYjp', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (106, 'user106', 'b721ae413ecb44c219be4220e6326f50471c59f7944ab5c659b338f203581c5c', 'RVUM4jyRjaFccEB0', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (107, 'user107', '46a09c7902e13bcfef96c74c6fd5393d09eedde475209d2d4cd48f9393ff77cb', 'pHEbV0IR2suhzBSp', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (108, 'user108', '4f82646ce14a4d81660859834718e2eb76f9af8b1323867884d60560fcbf8429', 'ML3PJJqV2aMXqAHW', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (109, 'user109', 'ebd4120beab975a4031fdc5f07cb45042add1c0e0573d97c3f058fba4baeabf2', 'PVzAhfySfE9dnqob', True, NULL, False, 0);
INSERT INTO user_auth (auth_id, username, password_hash, salt, is_active, last_login, account_locked, failed_attempts) VALUES (110, 'user110', '5bbb758a2fef8149074b03108f0daf7ebb268967244f8b2cdf61abc0148f30c6', 'pb2FcuUk9FtFCQVW', True, NULL, False, 0);
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (1, 1, 'Nathan', 'Barnes', '766-341-7399', 'user1@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (2, 2, 'Juan', 'Robertson', '844.165.0929x89283', 'user2@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (3, 3, 'Sonya', 'Blanchard', '528.960.1692', 'user3@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (4, 4, 'Ryan', 'Moore', '+1-725-836-5277x7425', 'user4@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (5, 5, 'Kent', 'Jefferson', '616.724.2869', 'user5@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (6, 6, 'Carolyn', 'Tyler', '(498)931-7088x0580', 'user6@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (7, 7, 'Daniel', 'Shields', '783-144-2771x480', 'user7@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (8, 8, 'Benjamin', 'Hill', '8820031806', 'user8@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (9, 9, 'Austin', 'Hoffman', '001-954-027-8080', 'user9@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (10, 10, 'Dana', 'Montgomery', '001-461-703-7191x4794', 'user10@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (11, 11, 'Maurice', 'Reyes', '001-245-693-3395x70538', 'user11@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (12, 12, 'Edward', 'Carter', '+1-329-741-5659x7202', 'user12@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (13, 13, 'Brianna', 'King', '618.793.4304x223', 'user13@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (14, 14, 'Kevin', 'Anderson', '714.990.9571x1758', 'user14@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (15, 15, 'Brenda', 'Morgan', '789.553.2769', 'user15@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (16, 16, 'Meagan', 'Cole', '(900)777-9062x97721', 'user16@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (17, 17, 'Eric', 'Montoya', '001-763-550-5633', 'user17@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (18, 18, 'Nicholas', 'Patterson', '742-945-7039x162', 'user18@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (19, 19, 'Melinda', 'Frey', '001-491-214-9449', 'user19@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (20, 20, 'David', 'Warner', '876-715-8317', 'user20@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (21, 21, 'Carolyn', 'Hendrix', '001-505-155-0034', 'user21@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (22, 22, 'Andrea', 'Donaldson', '001-384-859-8425', 'user22@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (23, 23, 'Gwendolyn', 'Gonzalez', '+1-195-197-3788x257', 'user23@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (24, 24, 'Tony', 'Rivera', '688.867.3802', 'user24@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (25, 25, 'Lauren', 'Cooper', '001-736-107-0844x3526', 'user25@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (26, 26, 'David', 'Martinez', '+1-492-002-6484x59998', 'user26@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (27, 27, 'James', 'Crawford', '+1-490-987-0339x92317', 'user27@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (28, 28, 'Regina', 'Martin', '941-097-5335x16581', 'user28@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (29, 29, 'Tammy', 'Anderson', '+1-174-369-6527x066', 'user29@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (30, 30, 'David', 'Cruz', '084.744.2252x12262', 'user30@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (31, 31, 'Laura', 'Bass', '783-581-4336', 'user31@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (32, 32, 'Sheryl', 'Haynes', '425.440.6665x9035', 'user32@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (33, 33, 'Richard', 'Berg', '821.138.0737', 'user33@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (34, 34, 'Carrie', 'Price', '+1-341-695-6234x6439', 'user34@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (35, 35, 'David', 'Boone', '635.149.4259', 'user35@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (36, 36, 'David', 'Orozco', '+1-931-071-8848x6888', 'user36@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (37, 37, 'Megan', 'Johnson', '(294)385-1288', 'user37@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (38, 38, 'Blake', 'Rivers', '0011208915', 'user38@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (39, 39, 'Ivan', 'Sanders', '549.750.5034x465', 'user39@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (40, 40, 'Michael', 'Williams', '3384934427', 'user40@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (41, 41, 'Roy', 'Miller', '001-483-342-1583x396', 'user41@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (42, 42, 'Melissa', 'Gates', '776-463-6286x5347', 'user42@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (43, 43, 'Scott', 'Wang', '873.129.4521x35891', 'user43@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (44, 44, 'Stephanie', 'Long', '+1-982-817-4972x30886', 'user44@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (45, 45, 'David', 'Reynolds', '029.108.9513x06842', 'user45@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (46, 46, 'Angie', 'Mcintosh', '001-742-533-8219x7261', 'user46@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (47, 47, 'Marissa', 'Rodriguez', '9301799153', 'user47@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (48, 48, 'Adam', 'Torres', '(689)471-4529', 'user48@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (49, 49, 'Steven', 'Hartman', '107-105-6524', 'user49@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (50, 50, 'Miranda', 'Ray', '001-759-050-1770x23860', 'user50@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (51, 51, 'Patricia', 'Robinson', '299.185.0221x1874', 'user51@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (52, 52, 'Angela', 'Rollins', '391.615.4467x99089', 'user52@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (53, 53, 'Phillip', 'Baker', '001-183-040-8054x96795', 'user53@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (54, 54, 'Ryan', 'Walker', '3048099035', 'user54@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (55, 55, 'Cathy', 'Blankenship', '+1-895-492-0658', 'user55@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (56, 56, 'Alfred', 'Hall', '001-003-983-8342', 'user56@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (57, 57, 'Craig', 'Robinson', '653.138.1064x88926', 'user57@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (58, 58, 'Tonya', 'Hernandez', '552.571.8296', 'user58@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (59, 59, 'Elizabeth', 'Hahn', '739.876.9650x43742', 'user59@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (60, 60, 'Christopher', 'Saunders', '695.005.6864x576', 'user60@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (61, 61, 'Brandy', 'Powell', '690.296.6067', 'user61@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (62, 62, 'Mary', 'Jordan', '609-053-8185', 'user62@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (63, 63, 'Stephen', 'Johnson', '954.439.2631x083', 'user63@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (64, 64, 'Christian', 'Nguyen', '(191)643-9535x6784', 'user64@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (65, 65, 'Molly', 'Smith', '(162)448-7540x26848', 'user65@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (66, 66, 'Jodi', 'Ellis', '670.045.0903', 'user66@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (67, 67, 'Michael', 'Wilson', '3602832540', 'user67@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (68, 68, 'Dennis', 'Jones', '238-089-8244', 'user68@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (69, 69, 'Mandy', 'Bray', '001-874-020-5459x98997', 'user69@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (70, 70, 'Jennifer', 'Hopkins', '677-222-1189', 'user70@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (71, 71, 'Anita', 'Lowe', '304-236-4819', 'user71@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (72, 72, 'Kimberly', 'Hodges', '001-079-401-2683x525', 'user72@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (73, 73, 'Susan', 'Leon', '7777365600', 'user73@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (74, 74, 'Jessica', 'Clay', '(611)835-0111', 'user74@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (75, 75, 'Felicia', 'Holloway', '574-164-6112x9096', 'user75@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (76, 76, 'Kristy', 'Vargas', '+1-974-731-6780x2340', 'user76@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (77, 77, 'Keith', 'Martin', '(342)653-0697x6356', 'user77@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (78, 78, 'Lisa', 'Lewis', '470.711.5885x04842', 'user78@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (79, 79, 'Clayton', 'Skinner', '(747)129-8736x036', 'user79@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (80, 80, 'Brian', 'Henderson', '001-649-714-1456x39012', 'user80@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (81, 81, 'Benjamin', 'Bishop', '+1-853-576-1187x83000', 'user81@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (82, 82, 'Timothy', 'Martin', '(175)243-3120', 'user82@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (83, 83, 'Rose', 'Doyle', '(631)475-2741', 'user83@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (84, 84, 'Jill', 'Finley', '582-972-6540', 'user84@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (85, 85, 'Pam', 'Johnson', '4583436809', 'user85@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (86, 86, 'Jessica', 'Gibbs', '(567)928-8450', 'user86@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (87, 87, 'Joshua', 'Guzman', '911.132.1183x66146', 'user87@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (88, 88, 'Carlos', 'Wang', '001-584-548-7556x634', 'user88@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (89, 89, 'Michele', 'Vaughan', '982-101-3340x9057', 'user89@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (90, 90, 'Jeremy', 'Mills', '001-394-280-2892x476', 'user90@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (91, 91, 'Paula', 'Hoffman', '+1-452-117-1797x135', 'user91@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (92, 92, 'Linda', 'Smith', '6206963067', 'user92@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (93, 93, 'Patricia', 'Johnson', '731-632-8464x6889', 'user93@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (94, 94, 'Marc', 'Perry', '351.613.8266x7705', 'user94@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (95, 95, 'Andrea', 'Blackwell', '(814)073-6935x79672', 'user95@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (96, 96, 'Emily', 'Williams', '(132)493-0826x8812', 'user96@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (97, 97, 'Paul', 'Banks', '(361)682-4536x22526', 'user97@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (98, 98, 'Steven', 'Cooke', '261-734-0551x2765', 'user98@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (99, 99, 'Erin', 'Jackson', '001-298-648-8762x7585', 'user99@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (100, 100, 'Brandy', 'Peters', '434.726.4137x91453', 'user100@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (101, 101, 'Michael', 'Mccormick', '1240594670', 'user101@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (102, 102, 'Philip', 'Ford', '418.737.9146x7938', 'user102@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (103, 103, 'David', 'Wang', '020.016.7601', 'user103@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (104, 104, 'Gregory', 'Harris', '+1-089-769-1491x50048', 'user104@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (105, 105, 'Frank', 'Chan', '748.038.3825x84980', 'user105@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (106, 106, 'Patricia', 'Mason', '(090)051-6831x14795', 'user106@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (107, 107, 'Logan', 'Owens', '(542)872-1310', 'user107@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (108, 108, 'Carlos', 'Reese', '+1-221-507-0822x383', 'user108@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (109, 109, 'Robert', 'Howell', '345.046.0942x963', 'user109@example.com');
INSERT INTO user (user_id, auth_id, first_name, last_name, phone, email) VALUES (110, 110, 'Jonathan', 'Harris', '0900828698', 'user110@example.com');
INSERT INTO us_citizen (user_id, ssn) VALUES (61, '785-90-8004');
INSERT INTO us_citizen (user_id, ssn) VALUES (62, '992-43-4918');
INSERT INTO us_citizen (user_id, ssn) VALUES (63, '567-61-1517');
INSERT INTO us_citizen (user_id, ssn) VALUES (64, '835-10-4788');
INSERT INTO us_citizen (user_id, ssn) VALUES (65, '965-70-6017');
INSERT INTO us_citizen (user_id, ssn) VALUES (66, '867-41-3105');
INSERT INTO us_citizen (user_id, ssn) VALUES (67, '452-13-6094');
INSERT INTO us_citizen (user_id, ssn) VALUES (68, '367-82-5866');
INSERT INTO us_citizen (user_id, ssn) VALUES (69, '599-33-8419');
INSERT INTO us_citizen (user_id, ssn) VALUES (70, '492-57-3698');
INSERT INTO us_citizen (user_id, ssn) VALUES (71, '136-71-4938');
INSERT INTO us_citizen (user_id, ssn) VALUES (72, '188-62-3985');
INSERT INTO us_citizen (user_id, ssn) VALUES (73, '271-48-2841');
INSERT INTO us_citizen (user_id, ssn) VALUES (74, '375-23-4418');
INSERT INTO us_citizen (user_id, ssn) VALUES (75, '780-15-6524');
INSERT INTO international_student (user_id, passport_id) VALUES (76, 'P00076');
INSERT INTO international_student (user_id, passport_id) VALUES (77, 'P00077');
INSERT INTO international_student (user_id, passport_id) VALUES (78, 'P00078');
INSERT INTO international_student (user_id, passport_id) VALUES (79, 'P00079');
INSERT INTO international_student (user_id, passport_id) VALUES (80, 'P00080');
INSERT INTO international_student (user_id, passport_id) VALUES (81, 'P00081');
INSERT INTO international_student (user_id, passport_id) VALUES (82, 'P00082');
INSERT INTO international_student (user_id, passport_id) VALUES (83, 'P00083');
INSERT INTO international_student (user_id, passport_id) VALUES (84, 'P00084');
INSERT INTO international_student (user_id, passport_id) VALUES (85, 'P00085');
INSERT INTO international_student (user_id, passport_id) VALUES (86, 'P00086');
INSERT INTO international_student (user_id, passport_id) VALUES (87, 'P00087');
INSERT INTO international_student (user_id, passport_id) VALUES (88, 'P00088');
INSERT INTO international_student (user_id, passport_id) VALUES (89, 'P00089');
INSERT INTO international_student (user_id, passport_id) VALUES (90, 'P00090');
INSERT INTO student (user_id, transcript) VALUES (76, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (77, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (78, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (79, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (80, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (81, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (82, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (83, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (84, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (85, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (86, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (87, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (88, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (89, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (90, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (91, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (92, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (93, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (94, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (95, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (96, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (97, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (98, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (99, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (100, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (101, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (102, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (103, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (104, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (105, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (106, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (107, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (108, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (109, 'PDF');
INSERT INTO student (user_id, transcript) VALUES (110, 'PDF');
INSERT INTO landlord (user_id) VALUES (1);
INSERT INTO landlord (user_id) VALUES (2);
INSERT INTO landlord (user_id) VALUES (3);
INSERT INTO landlord (user_id) VALUES (4);
INSERT INTO landlord (user_id) VALUES (5);
INSERT INTO landlord (user_id) VALUES (6);
INSERT INTO landlord (user_id) VALUES (7);
INSERT INTO landlord (user_id) VALUES (8);
INSERT INTO landlord (user_id) VALUES (9);
INSERT INTO landlord (user_id) VALUES (10);
INSERT INTO landlord (user_id) VALUES (11);
INSERT INTO landlord (user_id) VALUES (12);
INSERT INTO landlord (user_id) VALUES (13);
INSERT INTO landlord (user_id) VALUES (14);
INSERT INTO landlord (user_id) VALUES (15);
INSERT INTO landlord (user_id) VALUES (16);
INSERT INTO landlord (user_id) VALUES (17);
INSERT INTO landlord (user_id) VALUES (18);
INSERT INTO landlord (user_id) VALUES (19);
INSERT INTO landlord (user_id) VALUES (20);
INSERT INTO landlord (user_id) VALUES (21);
INSERT INTO landlord (user_id) VALUES (22);
INSERT INTO landlord (user_id) VALUES (23);
INSERT INTO landlord (user_id) VALUES (24);
INSERT INTO landlord (user_id) VALUES (25);
INSERT INTO landlord (user_id) VALUES (26);
INSERT INTO landlord (user_id) VALUES (27);
INSERT INTO landlord (user_id) VALUES (28);
INSERT INTO landlord (user_id) VALUES (29);
INSERT INTO landlord (user_id) VALUES (30);
INSERT INTO landlord (user_id) VALUES (31);
INSERT INTO landlord (user_id) VALUES (32);
INSERT INTO landlord (user_id) VALUES (33);
INSERT INTO landlord (user_id) VALUES (34);
INSERT INTO landlord (user_id) VALUES (35);
INSERT INTO landlord (user_id) VALUES (36);
INSERT INTO landlord (user_id) VALUES (37);
INSERT INTO landlord (user_id) VALUES (38);
INSERT INTO landlord (user_id) VALUES (39);
INSERT INTO landlord (user_id) VALUES (40);
INSERT INTO landlord (user_id) VALUES (41);
INSERT INTO landlord (user_id) VALUES (42);
INSERT INTO landlord (user_id) VALUES (43);
INSERT INTO landlord (user_id) VALUES (44);
INSERT INTO landlord (user_id) VALUES (45);
INSERT INTO landlord (user_id) VALUES (46);
INSERT INTO landlord (user_id) VALUES (47);
INSERT INTO landlord (user_id) VALUES (48);
INSERT INTO landlord (user_id) VALUES (49);
INSERT INTO landlord (user_id) VALUES (50);
INSERT INTO landlord (user_id) VALUES (51);
INSERT INTO landlord (user_id) VALUES (52);
INSERT INTO landlord (user_id) VALUES (53);
INSERT INTO landlord (user_id) VALUES (54);
INSERT INTO landlord (user_id) VALUES (55);
INSERT INTO landlord (user_id) VALUES (56);
INSERT INTO landlord (user_id) VALUES (57);
INSERT INTO landlord (user_id) VALUES (58);
INSERT INTO landlord (user_id) VALUES (59);
INSERT INTO landlord (user_id) VALUES (60);
INSERT INTO tenant (user_id) VALUES (61);
INSERT INTO tenant (user_id) VALUES (62);
INSERT INTO tenant (user_id) VALUES (63);
INSERT INTO tenant (user_id) VALUES (64);
INSERT INTO tenant (user_id) VALUES (65);
INSERT INTO tenant (user_id) VALUES (66);
INSERT INTO tenant (user_id) VALUES (67);
INSERT INTO tenant (user_id) VALUES (68);
INSERT INTO tenant (user_id) VALUES (69);
INSERT INTO tenant (user_id) VALUES (70);
INSERT INTO tenant (user_id) VALUES (71);
INSERT INTO tenant (user_id) VALUES (72);
INSERT INTO tenant (user_id) VALUES (73);
INSERT INTO tenant (user_id) VALUES (74);
INSERT INTO tenant (user_id) VALUES (75);
INSERT INTO tenant (user_id) VALUES (76);
INSERT INTO tenant (user_id) VALUES (77);
INSERT INTO tenant (user_id) VALUES (78);
INSERT INTO tenant (user_id) VALUES (79);
INSERT INTO tenant (user_id) VALUES (80);
INSERT INTO tenant (user_id) VALUES (81);
INSERT INTO tenant (user_id) VALUES (82);
INSERT INTO tenant (user_id) VALUES (83);
INSERT INTO tenant (user_id) VALUES (84);
INSERT INTO tenant (user_id) VALUES (85);
INSERT INTO tenant (user_id) VALUES (86);
INSERT INTO tenant (user_id) VALUES (87);
INSERT INTO tenant (user_id) VALUES (88);
INSERT INTO tenant (user_id) VALUES (89);
INSERT INTO tenant (user_id) VALUES (90);
INSERT INTO tenant (user_id) VALUES (91);
INSERT INTO tenant (user_id) VALUES (92);
INSERT INTO tenant (user_id) VALUES (93);
INSERT INTO tenant (user_id) VALUES (94);
INSERT INTO tenant (user_id) VALUES (95);
INSERT INTO tenant (user_id) VALUES (96);
INSERT INTO tenant (user_id) VALUES (97);
INSERT INTO tenant (user_id) VALUES (98);
INSERT INTO tenant (user_id) VALUES (99);
INSERT INTO tenant (user_id) VALUES (100);
INSERT INTO tenant (user_id) VALUES (101);
INSERT INTO tenant (user_id) VALUES (102);
INSERT INTO tenant (user_id) VALUES (103);
INSERT INTO tenant (user_id) VALUES (104);
INSERT INTO tenant (user_id) VALUES (105);
INSERT INTO tenant (user_id) VALUES (106);
INSERT INTO tenant (user_id) VALUES (107);
INSERT INTO tenant (user_id) VALUES (108);
INSERT INTO tenant (user_id) VALUES (109);
INSERT INTO tenant (user_id) VALUES (110);
INSERT INTO neighborhood (neighborhood_id, name) VALUES (1, 'Neighborhood 1');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (2, 'Neighborhood 2');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (3, 'Neighborhood 3');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (4, 'Neighborhood 4');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (5, 'Neighborhood 5');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (6, 'Neighborhood 6');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (7, 'Neighborhood 7');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (8, 'Neighborhood 8');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (9, 'Neighborhood 9');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (10, 'Neighborhood 10');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (11, 'Neighborhood 11');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (12, 'Neighborhood 12');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (13, 'Neighborhood 13');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (14, 'Neighborhood 14');
INSERT INTO neighborhood (neighborhood_id, name) VALUES (15, 'Neighborhood 15');
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (1, '2074', 'Michael Loaf', 'Philadelphia', 'PA', 'A4', 1044.8, True, 3750.7, 1, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (2, '750', 'Oliver Streets ', 'Los Angeles', 'CA', 'A8', 883.03, True, 3377.56, 2, 7);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (3, '205', 'Alison Springs ', 'Chicago', 'IL', 'A11', 1412.98, True, 3648.62, 3, 13);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (4, '595', 'Bryan Trail', 'San Diego', 'CA', 'A16', 1094.11, True, 1362.68, 4, 35);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (5, '302', 'Ryan Estate ', 'Houston', 'TX', 'A7', 1194.48, True, 3973.97, 2, 40);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (6, '66213', 'Paul Port', 'New York', 'NY', 'A16', 559.06, True, 2784.09, 4, 44);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (7, '0072', 'Veronica Park', 'Los Angeles', 'CA', 'A18', 1312.17, True, 2189.14, 4, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (8, '338', 'Strickland Avenue', 'San Antonio', 'TX', 'A19', 1118.73, True, 3594.58, 4, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (9, '2245', 'Micheal Branch', 'San Antonio', 'TX', 'A11', 535.91, True, 2498.94, 4, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (10, '6722', 'Katherine Creek', 'Phoenix', 'AZ', 'A3', 1474.95, True, 3256.09, 3, 43);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (11, '836', 'Smith Court ', 'Philadelphia', 'PA', 'A16', 524.57, True, 1942.6, 4, 37);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (12, '025', 'Davis Drive', 'New York', 'NY', 'A5', 809.32, True, 1382.41, 3, 14);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (13, '81380', 'Lauren Unions', 'Dallas', 'TX', 'A17', 702.71, True, 2347.38, 3, 22);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (14, '87804', 'Robert Motorway ', 'San Diego', 'CA', 'A14', 1483.44, True, 2947.05, 3, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (15, '9868', 'Rachel Ways', 'Philadelphia', 'PA', 'A16', 1041.71, True, 3924.27, 1, 58);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (16, '54582', 'Gould Curve ', 'San Antonio', 'TX', 'A9', 740.41, True, 2570.74, 2, 22);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (17, '883', 'Meghan Ford ', 'Houston', 'TX', 'A2', 960.92, True, 1947.06, 1, 17);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (18, '74113', 'Colon Trail ', 'Phoenix', 'AZ', 'A6', 667.82, True, 3204.34, 3, 30);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (19, '1164', 'Samantha Radial', 'New York', 'NY', 'A16', 1036.26, True, 2772.12, 3, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (20, '73152', 'Jackson Point', 'San Antonio', 'TX', 'A16', 1367.48, True, 3089.29, 3, 19);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (21, '051', 'Perkins Lock', 'Philadelphia', 'PA', 'A19', 507.46, True, 1319.81, 3, 9);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (22, '6873', 'Wilson Ford', 'San Jose', 'CA', 'A6', 1150.06, True, 2320.68, 3, 38);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (23, '6537', 'Christina Parkway', 'San Diego', 'CA', 'A15', 1319.41, True, 1830.47, 2, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (24, '62556', 'Casey Lock', 'Dallas', 'TX', 'A5', 1162.51, True, 1355.5, 4, 11);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (25, '4676', 'Timothy Parks ', 'New York', 'NY', 'A3', 740.21, True, 3467.51, 2, 10);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (26, '12926', 'Stephens Street', 'Los Angeles', 'CA', 'A19', 1377.92, True, 1753.48, 2, 31);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (27, '3912', 'Velasquez Vista ', 'Houston', 'TX', 'A8', 1354.53, True, 3917.0, 2, 23);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (28, '649', 'Jose Mission', 'San Antonio', 'TX', 'A11', 1477.25, True, 2429.67, 2, 48);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (29, '01614', 'Dominguez Courts', 'Los Angeles', 'CA', 'A4', 1154.97, True, 3675.8, 4, 9);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (30, '8698', 'Barr Forges ', 'Dallas', 'TX', 'A11', 576.99, True, 3876.93, 4, 17);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (31, '838', 'Long Locks', 'San Antonio', 'TX', 'A13', 897.13, True, 3418.5, 2, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (32, '772', 'Beard Gardens ', 'New York', 'NY', 'A19', 1203.9, True, 1883.61, 3, 46);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (33, '1892', 'Williams Corner ', 'Philadelphia', 'PA', 'A4', 932.73, True, 3588.17, 3, 56);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (34, '275', 'Meyer Expressway', 'Philadelphia', 'PA', 'A6', 694.44, True, 3801.89, 2, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (35, '0211', 'Sheila Crossing', 'Philadelphia', 'PA', 'A13', 1115.37, True, 1884.39, 2, 26);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (36, '9376', 'Darrell Route ', 'New York', 'NY', 'A5', 652.04, True, 3151.78, 1, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (37, '53608', 'Rachel Inlet ', 'Phoenix', 'AZ', 'A18', 781.36, True, 2250.84, 4, 54);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (38, '58452', 'Scott Camp', 'Los Angeles', 'CA', 'A5', 1022.64, True, 3493.98, 1, 58);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (39, '669', 'Thomas Track', 'Dallas', 'TX', 'A20', 1093.99, True, 3692.05, 1, 58);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (40, '371', 'Charlotte Viaduct ', 'Chicago', 'IL', 'A6', 1363.45, True, 1208.81, 2, 13);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (41, '877', 'Cantrell Place', 'San Diego', 'CA', 'A12', 1113.73, True, 2118.94, 2, 38);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (42, '196', 'Stephen Point ', 'New York', 'NY', 'A6', 1356.62, True, 3401.21, 3, 57);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (43, '59328', 'Danielle Underpass ', 'Chicago', 'IL', 'A5', 1327.25, True, 1382.56, 2, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (44, '9948', 'Ricky Knoll', 'Philadelphia', 'PA', 'A2', 1401.03, True, 1703.46, 3, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (45, '78268', 'Caleb Parkway', 'San Antonio', 'TX', 'A4', 704.35, True, 2648.94, 1, 26);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (46, '465', 'Lauren Canyon ', 'Houston', 'TX', 'A18', 814.24, True, 1851.65, 2, 44);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (47, '350', 'Alvarez Squares ', 'Chicago', 'IL', 'A5', 791.86, True, 2256.31, 3, 58);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (48, '3349', 'Vanessa Ways ', 'Philadelphia', 'PA', 'A16', 843.47, True, 3794.7, 4, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (49, '00703', 'Gomez Spur ', 'Los Angeles', 'CA', 'A9', 994.38, True, 3486.21, 4, 10);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (50, '0033', 'Stewart Port', 'San Diego', 'CA', 'A19', 728.82, True, 2124.81, 1, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (51, '92782', 'Cross Road', 'San Antonio', 'TX', 'A8', 592.06, True, 2553.13, 3, 11);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (52, '656', 'Sheila Harbors', 'Los Angeles', 'CA', 'A12', 560.02, True, 3898.2, 3, 17);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (53, '2264', 'Buckley Club', 'San Antonio', 'TX', 'A11', 653.69, True, 3289.27, 2, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (54, '5218', 'Carol Port', 'San Antonio', 'TX', 'A19', 561.88, True, 3600.69, 4, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (55, '605', 'Carr Club ', 'San Antonio', 'TX', 'A11', 1147.61, True, 2955.19, 4, 22);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (56, '4373', 'Samantha Underpass ', 'San Antonio', 'TX', 'A2', 917.18, True, 2219.12, 2, 31);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (57, '592', 'Omar Throughway ', 'San Diego', 'CA', 'A8', 1159.81, True, 2968.14, 3, 39);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (58, '617', 'Ashley Ranch ', 'Houston', 'TX', 'A4', 855.36, True, 3421.1, 2, 47);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (59, '4376', 'Allen Mount', 'Houston', 'TX', 'A7', 570.02, True, 3121.88, 2, 58);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (60, '8294', 'Young Station ', 'Los Angeles', 'CA', 'A18', 1308.97, True, 2167.54, 3, 55);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (61, '83549', 'Brittany Lakes', 'San Diego', 'CA', 'A18', 1353.23, True, 2783.95, 3, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (62, '513', 'Carr Fields ', 'San Antonio', 'TX', 'A15', 564.02, True, 3522.69, 4, 11);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (63, '868', 'Gregory Haven ', 'San Antonio', 'TX', 'A15', 1279.72, True, 2114.73, 2, 41);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (64, '17671', 'Morales Ridge', 'New York', 'NY', 'A7', 618.6, True, 3262.81, 3, 13);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (65, '7862', 'Roth Street', 'San Diego', 'CA', 'A4', 711.92, True, 1250.04, 4, 42);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (66, '53410', 'Steven Throughway ', 'Houston', 'TX', 'A15', 567.65, True, 1928.07, 4, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (67, '5883', 'Jeff Falls ', 'Houston', 'TX', 'A10', 929.56, True, 2015.61, 2, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (68, '5903', 'Brown Forest ', 'San Antonio', 'TX', 'A4', 1147.13, True, 3648.52, 2, 14);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (69, '93209', 'Misty Alley', 'Los Angeles', 'CA', 'A6', 703.46, True, 3555.29, 1, 22);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (70, '58118', 'Jonathan Mills', 'New York', 'NY', 'A8', 881.22, True, 3181.78, 4, 49);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (71, '52260', 'Taylor Spring', 'Dallas', 'TX', 'A18', 756.06, True, 1732.9, 3, 12);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (72, '6901', 'Edwards Place', 'Philadelphia', 'PA', 'A14', 548.93, True, 2786.08, 4, 31);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (73, '5857', 'Jessica Corners ', 'San Jose', 'CA', 'A19', 998.5, True, 3940.12, 3, 10);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (74, '133', 'Garrett Field ', 'Dallas', 'TX', 'A18', 590.1, True, 3870.37, 4, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (75, '27856', 'King Crossing', 'San Antonio', 'TX', 'A18', 1053.62, True, 1259.15, 1, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (76, '507', 'Howard Expressway', 'Los Angeles', 'CA', 'A2', 622.31, True, 3001.87, 2, 8);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (77, '177', 'Harris Harbor', 'Dallas', 'TX', 'A2', 543.62, True, 3263.56, 3, 39);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (78, '6629', 'Kathleen Brook', 'Philadelphia', 'PA', 'A17', 881.94, True, 3876.24, 3, 45);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (79, '872', 'Michelle Light ', 'Dallas', 'TX', 'A3', 672.49, True, 2223.77, 2, 44);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (80, '490', 'Parsons Garden', 'San Jose', 'CA', 'A8', 1286.23, True, 1664.9, 4, 27);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (81, '30473', 'Brenda Alley', 'New York', 'NY', 'A11', 928.14, True, 1510.49, 2, 13);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (82, '45400', 'Cheryl Road', 'Dallas', 'TX', 'A2', 1144.07, True, 3662.64, 3, 39);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (83, '968', 'Perry Terrace', 'Philadelphia', 'PA', 'A5', 907.83, True, 2443.72, 1, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (84, '35919', 'Diana Court', 'Phoenix', 'AZ', 'A8', 571.74, True, 3388.11, 4, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (85, '94036', 'Haynes Gardens', 'New York', 'NY', 'A1', 577.0, True, 3043.15, 4, 22);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (86, '745', 'Wilkerson Motorway', 'Dallas', 'TX', 'A20', 1004.02, True, 3644.91, 2, 8);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (87, '670', 'Diaz Walk', 'San Jose', 'CA', 'A18', 772.02, True, 3985.93, 2, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (88, '84772', 'Figueroa Knolls ', 'New York', 'NY', 'A14', 1196.87, True, 3590.05, 4, 49);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (89, '2952', 'Benjamin Drives', 'San Jose', 'CA', 'A5', 787.6, True, 2109.95, 4, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (90, '246', 'Mark Valleys ', 'San Diego', 'CA', 'A13', 817.68, True, 3615.71, 3, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (91, '1972', 'Brandon Glen', 'Dallas', 'TX', 'A20', 793.54, True, 1770.48, 2, 43);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (92, '15162', 'Jeffery Extension', 'Dallas', 'TX', 'A6', 1201.32, True, 3694.54, 2, 43);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (93, '91068', 'Candice Shoal', 'Philadelphia', 'PA', 'A17', 933.28, True, 1234.13, 2, 19);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (94, '441', 'Stacy Rest ', 'San Diego', 'CA', 'A10', 1035.11, True, 1893.42, 4, 30);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (95, '14272', 'Riggs Knolls ', 'San Jose', 'CA', 'A5', 853.96, True, 1425.34, 2, 33);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (96, '43152', 'Sandra Square', 'San Antonio', 'TX', 'A3', 1042.25, True, 3575.6, 1, 41);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (97, '5843', 'Hughes Inlet', 'San Diego', 'CA', 'A5', 615.78, True, 2738.11, 1, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (98, '5559', 'Regina Knolls ', 'Houston', 'TX', 'A20', 1028.3, True, 2377.66, 2, 28);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (99, '8084', 'Johnson Club ', 'Dallas', 'TX', 'A20', 1106.3, True, 3362.31, 4, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (100, '8302', 'Monica Lodge ', 'Philadelphia', 'PA', 'A2', 912.73, True, 2378.28, 1, 13);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (101, '3620', 'Aguilar Harbor ', 'Philadelphia', 'PA', 'A6', 875.3, True, 2917.21, 2, 38);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (102, '102', 'Michael Trail ', 'Houston', 'TX', 'A8', 505.13, True, 2734.13, 3, 46);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (103, '9827', 'Fox Brooks', 'San Antonio', 'TX', 'A10', 1441.13, True, 1363.84, 3, 28);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (104, '693', 'Beck Mountains', 'San Antonio', 'TX', 'A3', 521.24, True, 1457.2, 1, 17);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (105, '0374', 'Hale Streets ', 'San Jose', 'CA', 'A19', 795.08, True, 1292.85, 1, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (106, '223', 'Turner Isle', 'San Antonio', 'TX', 'A6', 1251.13, True, 1970.06, 4, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (107, '60830', 'Evans Brook', 'Dallas', 'TX', 'A19', 525.44, True, 2896.63, 3, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (108, '0754', 'Miller Heights ', 'San Antonio', 'TX', 'A19', 1057.71, True, 2392.68, 1, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (109, '7885', 'Snyder Lodge', 'Phoenix', 'AZ', 'A11', 829.13, True, 2476.42, 3, 26);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (110, '4740', 'Christopher Mountains ', 'Houston', 'TX', 'A2', 878.42, True, 1591.87, 4, 43);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (111, '1185', 'Albert Run', 'Los Angeles', 'CA', 'A3', 837.74, True, 1633.16, 2, 54);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (112, '0000', 'Bennett Canyon ', 'Phoenix', 'AZ', 'A3', 1263.63, True, 1634.61, 3, 15);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (113, '4646', 'Manning Canyon ', 'Dallas', 'TX', 'A19', 1038.91, True, 3848.62, 1, 2);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (114, '0735', 'Martin Pines', 'New York', 'NY', 'A9', 1338.31, True, 3711.99, 3, 10);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (115, '031', 'Bennett Plains', 'Chicago', 'IL', 'A2', 697.68, True, 2920.34, 1, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (116, '0304', 'Rogers Court', 'Los Angeles', 'CA', 'A10', 1179.76, True, 2113.83, 1, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (117, '939', 'Dorothy Glen ', 'San Jose', 'CA', 'A8', 559.76, True, 1727.68, 2, 35);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (118, '61191', 'Hoover Isle ', 'New York', 'NY', 'A10', 1073.56, True, 1292.19, 1, 18);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (119, '9538', 'Byrd Views', 'Chicago', 'IL', 'A1', 1315.85, True, 3001.03, 3, 13);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (120, '2755', 'Leah Skyway ', 'San Diego', 'CA', 'A1', 833.99, True, 2429.44, 4, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (121, '021', 'Patel Views', 'San Antonio', 'TX', 'A16', 1408.84, True, 2901.95, 3, 5);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (122, '39557', 'Ashley Ways ', 'New York', 'NY', 'A11', 1180.65, True, 1733.4, 1, 38);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (123, '52466', 'Dunlap Forks', 'San Jose', 'CA', 'A10', 936.93, True, 2787.98, 2, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (124, '2005', 'Coleman Square ', 'San Antonio', 'TX', 'A4', 853.55, True, 1954.79, 3, 48);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (125, '30020', 'Julia Extensions', 'San Antonio', 'TX', 'A10', 1480.28, True, 1571.74, 1, 49);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (126, '099', 'Ashley Views', 'Los Angeles', 'CA', 'A6', 1148.88, True, 2179.03, 2, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (127, '0345', 'Victor Drive ', 'New York', 'NY', 'A19', 676.16, True, 3854.98, 1, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (128, '7762', 'Carla Centers', 'Chicago', 'IL', 'A10', 691.83, True, 3996.92, 3, 54);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (129, '562', 'Smith Divide', 'Houston', 'TX', 'A10', 1350.42, True, 1312.7, 4, 51);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (130, '0891', 'Young Circles', 'San Antonio', 'TX', 'A1', 514.25, True, 2050.26, 3, 38);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (131, '491', 'Nicholas Springs ', 'San Diego', 'CA', 'A10', 1297.68, True, 3337.76, 2, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (132, '44318', 'Amanda Mountains', 'New York', 'NY', 'A14', 1422.68, True, 2626.29, 4, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (133, '514', 'Morris Run ', 'San Jose', 'CA', 'A9', 757.3, True, 3031.02, 4, 56);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (134, '9071', 'Young Pines ', 'San Antonio', 'TX', 'A19', 804.51, True, 2210.35, 3, 17);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (135, '6913', 'Rebecca Bridge ', 'New York', 'NY', 'A4', 692.79, True, 3211.52, 1, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (136, '3641', 'Andersen Mountains ', 'San Jose', 'CA', 'A6', 1174.71, True, 3754.17, 3, 26);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (137, '463', 'Jeffery Fort ', 'Chicago', 'IL', 'A9', 618.09, True, 2829.81, 1, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (138, '5803', 'Brian Haven', 'New York', 'NY', 'A14', 896.47, True, 2296.28, 3, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (139, '943', 'Ray Rest', 'Dallas', 'TX', 'A2', 833.66, True, 2233.56, 2, 39);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (140, '373', 'Shepard Lake ', 'Phoenix', 'AZ', 'A5', 650.71, True, 3475.32, 1, 57);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (141, '116', 'Dwayne Flat ', 'Chicago', 'IL', 'A14', 512.54, True, 3914.32, 4, 28);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (142, '59069', 'Patricia Squares', 'Houston', 'TX', 'A10', 729.0, True, 2750.47, 2, 7);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (143, '09069', 'Jenkins Rue', 'San Antonio', 'TX', 'A5', 789.29, True, 2089.47, 2, 47);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (144, '89735', 'Schwartz Corner ', 'Phoenix', 'AZ', 'A18', 919.49, True, 3247.83, 4, 30);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (145, '358', 'Singleton Lights', 'Phoenix', 'AZ', 'A8', 1412.99, True, 1224.39, 4, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (146, '1369', 'Renee Parkways ', 'Chicago', 'IL', 'A11', 730.49, True, 3062.2, 3, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (147, '30403', 'Torres Plain ', 'San Antonio', 'TX', 'A19', 616.97, True, 3285.44, 1, 15);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (148, '09942', 'Smith Brook', 'San Antonio', 'TX', 'A13', 1493.18, True, 1206.73, 4, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (149, '21017', 'Melissa Club', 'San Jose', 'CA', 'A19', 657.35, True, 3944.22, 3, 25);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (150, '260', 'Stephanie Garden', 'San Antonio', 'TX', 'A12', 1126.49, True, 1957.51, 2, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (151, '13757', 'Wood Extension ', 'San Diego', 'CA', 'A17', 1176.55, True, 3744.34, 1, 12);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (152, '529', 'Lee Mountains ', 'Phoenix', 'AZ', 'A11', 592.14, True, 2369.01, 4, 48);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (153, '1736', 'Randolph Radial ', 'San Jose', 'CA', 'A7', 580.58, True, 3378.36, 4, 8);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (154, '169', 'Valdez Stravenue', 'Dallas', 'TX', 'A10', 938.48, True, 3725.96, 1, 16);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (155, '465', 'Taylor Estate', 'Phoenix', 'AZ', 'A15', 755.72, True, 2154.37, 2, 56);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (156, '72361', 'Robin Station ', 'Phoenix', 'AZ', 'A16', 1134.02, True, 3907.19, 1, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (157, '65392', 'Ruiz Mission ', 'San Diego', 'CA', 'A16', 836.08, True, 2323.2, 2, 17);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (158, '75520', 'Stacey Rest', 'San Jose', 'CA', 'A3', 1391.71, True, 3182.89, 4, 44);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (159, '6712', 'Carter Trail ', 'San Diego', 'CA', 'A16', 1437.73, True, 2835.12, 2, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (160, '90474', 'Smith Trace ', 'New York', 'NY', 'A20', 1197.83, True, 2816.84, 3, 37);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (161, '846', 'Taylor Harbors', 'San Antonio', 'TX', 'A2', 858.45, True, 3005.75, 4, 45);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (162, '543', 'Kimberly Mall ', 'San Antonio', 'TX', 'A17', 1111.39, True, 2016.97, 2, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (163, '77531', 'Sloan Greens', 'Chicago', 'IL', 'A15', 742.66, True, 3131.2, 4, 60);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (164, '363', 'Walker Locks', 'New York', 'NY', 'A1', 832.4, True, 3794.11, 3, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (165, '5928', 'Wade Views', 'Philadelphia', 'PA', 'A13', 1475.3, True, 2932.83, 1, 15);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (166, '33078', 'Jessica Plains', 'Dallas', 'TX', 'A19', 704.73, True, 1237.08, 3, 14);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (167, '3523', 'Perez Rapids ', 'San Diego', 'CA', 'A19', 899.2, True, 1971.54, 1, 14);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (168, '14622', 'Reyes Isle ', 'San Diego', 'CA', 'A5', 1134.42, True, 3687.28, 2, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (169, '9851', 'Scott Burgs', 'San Jose', 'CA', 'A9', 1271.19, True, 3155.57, 4, 11);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (170, '4590', 'Johnson Underpass ', 'New York', 'NY', 'A12', 1258.14, True, 3466.71, 3, 57);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (171, '8468', 'Norris Way', 'Philadelphia', 'PA', 'A18', 1030.3, True, 3917.97, 1, 1);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (172, '379', 'Hensley Parkways', 'Los Angeles', 'CA', 'A2', 1412.22, True, 2463.02, 3, 26);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (173, '64438', 'Miller Corners', 'Houston', 'TX', 'A14', 1345.96, True, 3328.32, 1, 12);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (174, '77482', 'Christopher Pass ', 'Houston', 'TX', 'A19', 625.16, True, 1940.45, 1, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (175, '09796', 'Adams Ports', 'Dallas', 'TX', 'A20', 793.96, True, 3638.54, 4, 30);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (176, '4621', 'Lindsey Plain ', 'San Diego', 'CA', 'A10', 937.48, True, 3196.78, 1, 24);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (177, '2402', 'Paul Springs', 'San Antonio', 'TX', 'A19', 697.97, True, 3628.8, 4, 38);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (178, '101', 'Kimberly Row', 'Philadelphia', 'PA', 'A10', 1421.83, True, 1356.07, 2, 39);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (179, '8581', 'Baxter Place ', 'Dallas', 'TX', 'A8', 1281.43, True, 3604.43, 1, 39);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (180, '538', 'Sara Curve ', 'Phoenix', 'AZ', 'A1', 563.87, True, 1736.52, 3, 47);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (181, '31245', 'Ruben Pine ', 'Dallas', 'TX', 'A10', 1130.11, True, 2638.88, 4, 40);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (182, '070', 'Matthew Via', 'Dallas', 'TX', 'A2', 973.48, True, 1700.77, 2, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (183, '2174', 'Anderson Green ', 'Los Angeles', 'CA', 'A1', 743.02, True, 3762.83, 2, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (184, '647', 'Kelsey Vista ', 'Philadelphia', 'PA', 'A19', 1119.79, True, 3661.75, 2, 7);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (185, '09426', 'William Causeway ', 'Houston', 'TX', 'A1', 835.66, True, 2718.51, 3, 1);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (186, '16826', 'Scott Plaza', 'Dallas', 'TX', 'A11', 1248.66, True, 2714.92, 3, 28);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (187, '3706', 'Donald Shore ', 'Dallas', 'TX', 'A16', 1226.32, True, 3284.37, 1, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (188, '65589', 'Tammy Points', 'Houston', 'TX', 'A11', 964.06, True, 3831.74, 4, 40);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (189, '69310', 'Clark Branch ', 'San Jose', 'CA', 'A12', 1350.43, True, 1807.21, 4, 8);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (190, '44839', 'Valdez Passage', 'San Jose', 'CA', 'A18', 1312.49, True, 3635.38, 2, 2);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (191, '22426', 'Tammy Port', 'Los Angeles', 'CA', 'A13', 669.18, True, 3451.94, 4, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (192, '06593', 'Madison Ramp ', 'New York', 'NY', 'A2', 1462.13, True, 1924.84, 3, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (193, '113', 'Ashley Mountains', 'Los Angeles', 'CA', 'A11', 556.99, True, 2080.95, 4, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (194, '8101', 'Heather Expressway ', 'Phoenix', 'AZ', 'A6', 1088.86, True, 2846.11, 2, 27);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (195, '1969', 'Andrew Views ', 'Los Angeles', 'CA', 'A17', 1008.27, True, 3369.11, 4, 33);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (196, '303', 'Lisa Plains', 'San Diego', 'CA', 'A12', 618.75, True, 2887.08, 2, 14);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (197, '3439', 'Adam Unions', 'San Antonio', 'TX', 'A15', 985.26, True, 3905.84, 4, 18);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (198, '13886', 'Daniel Well', 'San Antonio', 'TX', 'A8', 1080.27, True, 1892.5, 2, 8);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (199, '456', 'Young Stream ', 'Phoenix', 'AZ', 'A1', 963.56, True, 3789.83, 1, 11);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (200, '35015', 'Roberts Mall ', 'San Jose', 'CA', 'A10', 1039.86, True, 2208.2, 2, 34);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (201, '518', 'Washington Turnpike ', 'Philadelphia', 'PA', 'A7', 821.52, True, 2529.21, 3, 22);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (202, '72166', 'Dylan Ridges', 'Chicago', 'IL', 'A16', 1425.61, True, 2498.1, 2, 56);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (203, '132', 'Fernandez Radial', 'Los Angeles', 'CA', 'A10', 1207.8, True, 2418.43, 1, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (204, '15246', 'Delgado Place', 'Houston', 'TX', 'A15', 1262.65, True, 3671.74, 4, 1);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (205, '95026', 'Christian Mountains ', 'Los Angeles', 'CA', 'A6', 1346.57, True, 1687.22, 4, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (206, '2484', 'Christopher Coves ', 'Dallas', 'TX', 'A18', 1352.62, True, 3211.31, 4, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (207, '35789', 'Maddox Keys', 'San Jose', 'CA', 'A13', 714.86, True, 3717.42, 2, 51);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (208, '99214', 'Lisa Ramp', 'Houston', 'TX', 'A6', 1484.71, True, 1700.05, 2, 15);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (209, '91472', 'Deanna Lights ', 'San Antonio', 'TX', 'A1', 995.27, True, 3997.15, 2, 33);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (210, '5359', 'Jessica Mountains ', 'San Antonio', 'TX', 'A8', 1300.57, True, 3914.37, 1, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (211, '58367', 'Jason Vista ', 'San Antonio', 'TX', 'A7', 636.07, True, 2642.71, 3, 18);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (212, '70500', 'Andrea Ridges ', 'San Jose', 'CA', 'A14', 919.27, True, 3772.45, 3, 13);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (213, '4568', 'Sharon Rapid ', 'Los Angeles', 'CA', 'A11', 674.28, True, 3372.36, 3, 7);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (214, '16265', 'Alyssa Road', 'San Diego', 'CA', 'A5', 1473.1, True, 3859.86, 1, 37);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (215, '435', 'Smith Plaza', 'Los Angeles', 'CA', 'A3', 1359.47, True, 3457.87, 2, 40);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (216, '980', 'Ellis Summit ', 'New York', 'NY', 'A2', 503.06, True, 1844.6, 4, 12);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (217, '04339', 'Richard Junction', 'Los Angeles', 'CA', 'A18', 822.13, True, 1980.22, 1, 29);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (218, '099', 'Paul Island', 'Phoenix', 'AZ', 'A18', 509.92, True, 1751.85, 4, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (219, '195', 'Chase Grove', 'San Jose', 'CA', 'A10', 1231.58, True, 1657.58, 4, 33);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (220, '11057', 'Robertson Vista', 'San Diego', 'CA', 'A15', 642.45, True, 1743.7, 1, 5);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (221, '665', 'Richard Corners ', 'Houston', 'TX', 'A8', 847.86, True, 2408.89, 2, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (222, '68427', 'Adams Stream', 'New York', 'NY', 'A1', 794.33, True, 3282.49, 3, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (223, '27194', 'King Turnpike ', 'Dallas', 'TX', 'A9', 1124.31, True, 2534.78, 4, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (224, '858', 'Erin Drive ', 'Houston', 'TX', 'A3', 1486.11, True, 2253.01, 2, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (225, '893', 'Contreras Rapids', 'Houston', 'TX', 'A7', 747.97, True, 2589.72, 1, 26);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (226, '399', 'Eric Common', 'Chicago', 'IL', 'A6', 1448.19, True, 2212.48, 4, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (227, '097', 'Scott Corners', 'Phoenix', 'AZ', 'A10', 1356.89, True, 3938.95, 2, 14);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (228, '3716', 'Angela Avenue', 'Houston', 'TX', 'A18', 1025.7, True, 3906.53, 3, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (229, '907', 'Hernandez Meadows ', 'Chicago', 'IL', 'A10', 534.49, True, 3553.85, 1, 49);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (230, '12821', 'Shea Skyway', 'San Antonio', 'TX', 'A12', 935.66, True, 2297.44, 2, 8);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (231, '8900', 'Harris Summit', 'Phoenix', 'AZ', 'A20', 529.02, True, 2966.13, 2, 6);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (232, '973', 'Richards Curve', 'Chicago', 'IL', 'A2', 934.8, True, 2837.34, 2, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (233, '51448', 'Williams Vista', 'San Antonio', 'TX', 'A12', 1389.02, True, 2272.16, 2, 5);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (234, '816', 'Juan Hill', 'Chicago', 'IL', 'A19', 1125.7, True, 1403.2, 1, 50);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (235, '827', 'Katelyn Stream ', 'San Antonio', 'TX', 'A17', 1102.69, True, 1469.04, 3, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (236, '64139', 'Madden Glen ', 'Chicago', 'IL', 'A16', 1113.94, True, 2742.88, 2, 24);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (237, '6049', 'Matthew Tunnel', 'Philadelphia', 'PA', 'A6', 542.88, True, 3719.44, 3, 37);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (238, '92640', 'Williams Ferry', 'San Antonio', 'TX', 'A19', 872.2, True, 3539.7, 3, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (239, '31059', 'Jonathan Locks', 'Philadelphia', 'PA', 'A7', 929.58, True, 2165.69, 3, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (240, '746', 'Miller Glens', 'Houston', 'TX', 'A2', 1493.75, True, 2787.32, 3, 39);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (241, '585', 'Jenna Circles', 'Houston', 'TX', 'A13', 1332.77, True, 2854.61, 2, 46);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (242, '94400', 'Hill Rest ', 'Phoenix', 'AZ', 'A8', 1212.08, True, 3991.06, 1, 41);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (243, '546', 'Tracey Drive ', 'Houston', 'TX', 'A13', 786.72, True, 3489.13, 1, 34);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (244, '759', 'Jones Valley', 'Philadelphia', 'PA', 'A7', 1359.37, True, 1843.45, 3, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (245, '0003', 'Julia Gardens ', 'San Antonio', 'TX', 'A2', 1018.96, True, 2553.3, 1, 32);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (246, '32100', 'Donald Causeway ', 'Dallas', 'TX', 'A3', 596.3, True, 3489.95, 1, 42);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (247, '15456', 'Dustin Brooks ', 'Houston', 'TX', 'A3', 1421.71, True, 3926.75, 4, 14);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (248, '58260', 'Garcia Vista ', 'Phoenix', 'AZ', 'A5', 1313.72, True, 2009.93, 3, 25);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (249, '74917', 'James Terrace ', 'New York', 'NY', 'A20', 559.57, True, 2100.06, 1, 1);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (250, '79180', 'Aguirre Hills', 'Dallas', 'TX', 'A18', 1421.35, True, 2470.33, 2, 56);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (251, '406', 'Bailey Rue ', 'Chicago', 'IL', 'A13', 877.22, True, 3862.19, 2, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (252, '83372', 'Ortega Center', 'Los Angeles', 'CA', 'A2', 1413.88, True, 3763.43, 3, 19);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (253, '78297', 'Tran Throughway', 'Los Angeles', 'CA', 'A1', 1222.44, True, 3891.56, 4, 15);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (254, '017', 'Yates Pike', 'San Diego', 'CA', 'A4', 1112.87, True, 1831.96, 1, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (255, '730', 'Cody Spring ', 'Philadelphia', 'PA', 'A3', 624.38, True, 3778.17, 1, 2);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (256, '518', 'Martinez Lake', 'Philadelphia', 'PA', 'A6', 533.79, True, 2727.98, 4, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (257, '44663', 'Newton Villages', 'Los Angeles', 'CA', 'A14', 992.11, True, 3598.29, 1, 34);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (258, '382', 'Carrie Springs ', 'Dallas', 'TX', 'A18', 1327.28, True, 3071.48, 2, 15);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (259, '1784', 'Acosta Fall ', 'Philadelphia', 'PA', 'A12', 1228.01, True, 3868.29, 1, 54);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (260, '118', 'Chad Motorway', 'Phoenix', 'AZ', 'A14', 1092.62, True, 2375.69, 3, 1);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (261, '271', 'Steven Road', 'San Diego', 'CA', 'A12', 1373.55, True, 3763.54, 3, 24);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (262, '904', 'Mack Lakes', 'San Jose', 'CA', 'A2', 839.07, True, 1741.45, 1, 54);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (263, '8720', 'Nicholas Crest', 'Phoenix', 'AZ', 'A2', 587.88, True, 1908.57, 3, 25);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (264, '080', 'Kellie Highway', 'Los Angeles', 'CA', 'A16', 523.05, True, 3164.74, 1, 20);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (265, '680', 'Martin Mills', 'Los Angeles', 'CA', 'A4', 594.49, True, 3615.1, 3, 5);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (266, '742', 'Daniel Mountains', 'Philadelphia', 'PA', 'A15', 1419.48, True, 2616.1, 3, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (267, '91058', 'Maxwell Pine ', 'Houston', 'TX', 'A12', 781.76, True, 1502.44, 4, 30);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (268, '8647', 'Sara Inlet', 'Philadelphia', 'PA', 'A16', 819.6, True, 3068.03, 4, 37);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (269, '10668', 'Adam Parks ', 'Phoenix', 'AZ', 'A18', 618.42, True, 3163.17, 2, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (270, '085', 'Chandler Manor ', 'Phoenix', 'AZ', 'A6', 1482.29, True, 3693.86, 2, 25);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (271, '84093', 'Marshall Park ', 'Los Angeles', 'CA', 'A13', 1463.81, True, 1633.6, 3, 42);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (272, '2482', 'Joshua Court ', 'Dallas', 'TX', 'A2', 851.86, True, 2245.36, 1, 21);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (273, '0692', 'Ronald Ville ', 'New York', 'NY', 'A7', 582.09, True, 2718.78, 4, 48);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (274, '495', 'Lewis Squares ', 'San Antonio', 'TX', 'A4', 1478.52, True, 3323.95, 4, 45);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (275, '55357', 'Kayla Rest', 'Dallas', 'TX', 'A18', 671.72, True, 3947.22, 3, 25);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (276, '180', 'Joseph Knolls', 'Philadelphia', 'PA', 'A17', 881.32, True, 1348.74, 1, 36);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (277, '99111', 'Dixon Turnpike ', 'Phoenix', 'AZ', 'A19', 827.83, True, 1786.99, 3, 28);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (278, '3275', 'Lindsey Expressway', 'Chicago', 'IL', 'A9', 1412.22, True, 2267.8, 3, 26);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (279, '8549', 'Alicia Ridges', 'San Antonio', 'TX', 'A17', 1343.46, True, 3861.93, 2, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (280, '4328', 'Taylor Neck ', 'Chicago', 'IL', 'A19', 679.03, True, 1579.24, 4, 52);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (281, '33798', 'Alejandra Trafficway ', 'New York', 'NY', 'A4', 1446.48, True, 1905.11, 3, 15);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (282, '9839', 'Myers Key ', 'Houston', 'TX', 'A1', 1379.52, True, 1275.19, 4, 5);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (283, '300', 'Sandra Mountain', 'San Diego', 'CA', 'A6', 1490.24, True, 3185.64, 3, 59);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (284, '564', 'Erik Isle ', 'Phoenix', 'AZ', 'A19', 1423.24, True, 1699.45, 2, 34);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (285, '725', 'Megan Crossroad ', 'Dallas', 'TX', 'A8', 1177.83, True, 2324.22, 2, 25);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (286, '2715', 'Cruz Village', 'Houston', 'TX', 'A16', 801.63, True, 3344.89, 3, 17);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (287, '38192', 'Christina Skyway', 'Philadelphia', 'PA', 'A7', 800.22, True, 1283.38, 3, 29);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (288, '5180', 'Frank Cliff ', 'Dallas', 'TX', 'A2', 841.6, True, 3539.81, 4, 45);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (289, '085', 'Jason Crest ', 'San Diego', 'CA', 'A4', 903.29, True, 1523.91, 4, 45);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (290, '4238', 'Brenda Ports ', 'Phoenix', 'AZ', 'A20', 1088.27, True, 3320.33, 1, 28);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (291, '98342', 'Wilson Knoll', 'New York', 'NY', 'A11', 1358.03, True, 3178.83, 2, 19);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (292, '8743', 'Monique Branch ', 'Houston', 'TX', 'A7', 732.72, True, 2864.79, 2, 53);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (293, '351', 'Danielle Burg ', 'Philadelphia', 'PA', 'A20', 1235.81, True, 2365.03, 4, 57);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (294, '204', 'Arnold Path ', 'Dallas', 'TX', 'A8', 650.26, True, 2094.72, 1, 4);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (295, '599', 'Walsh Harbor ', 'Los Angeles', 'CA', 'A4', 1147.84, True, 1784.53, 3, 34);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (296, '91255', 'Harris Canyon', 'New York', 'NY', 'A3', 515.64, True, 2268.59, 4, 37);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (297, '7416', 'Gonzalez Rapid ', 'San Diego', 'CA', 'A13', 1021.29, True, 2083.73, 2, 60);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (298, '5374', 'Andrews Knolls ', 'San Jose', 'CA', 'A6', 947.79, True, 3493.0, 4, 5);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (299, '57547', 'Huerta Green ', 'San Diego', 'CA', 'A3', 789.11, True, 2292.56, 2, 24);
INSERT INTO properties (property_id, street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id) VALUES (300, '1085', 'Jennifer Pine', 'San Diego', 'CA', 'A4', 1358.86, True, 2152.49, 2, 52);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (1, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (2, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (3, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (4, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (5, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (6, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (7, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (8, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (9, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (10, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (11, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (12, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (13, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (14, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (15, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (16, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (17, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (18, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (19, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (20, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (21, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (22, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (23, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (24, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (25, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (26, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (27, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (28, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (29, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (30, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (31, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (32, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (33, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (34, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (35, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (36, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (37, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (38, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (39, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (40, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (41, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (42, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (43, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (44, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (45, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (46, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (47, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (48, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (49, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (50, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (51, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (52, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (53, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (54, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (55, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (56, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (57, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (58, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (59, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (60, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (61, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (62, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (63, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (64, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (65, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (66, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (67, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (68, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (69, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (70, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (71, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (72, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (73, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (74, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (75, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (76, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (77, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (78, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (79, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (80, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (81, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (82, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (83, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (84, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (85, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (86, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (87, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (88, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (89, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (90, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (91, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (92, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (93, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (94, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (95, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (96, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (97, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (98, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (99, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (100, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (101, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (102, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (103, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (104, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (105, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (106, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (107, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (108, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (109, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (110, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (111, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (112, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (113, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (114, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (115, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (116, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (117, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (118, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (119, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (120, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (121, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (122, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (123, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (124, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (125, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (126, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (127, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (128, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (129, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (130, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (131, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (132, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (133, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (134, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (135, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (136, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (137, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (138, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (139, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (140, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (141, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (142, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (143, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (144, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (145, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (146, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (147, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (148, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (149, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (150, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (151, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (152, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (153, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (154, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (155, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (156, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (157, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (158, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (159, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (160, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (161, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (162, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (163, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (164, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (165, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (166, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (167, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (168, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (169, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (170, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (171, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (172, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (173, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (174, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (175, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (176, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (177, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (178, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (179, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (180, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (181, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (182, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (183, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (184, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (185, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (186, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (187, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (188, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (189, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (190, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (191, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (192, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (193, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (194, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (195, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (196, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (197, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (198, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (199, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (200, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (201, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (202, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (203, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (204, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (205, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (206, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (207, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (208, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (209, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (210, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (211, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (212, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (213, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (214, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (215, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (216, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (217, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (218, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (219, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (220, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (221, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (222, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (223, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (224, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (225, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (226, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (227, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (228, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (229, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (230, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (231, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (232, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (233, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (234, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (235, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (236, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (237, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (238, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (239, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (240, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (241, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (242, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (243, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (244, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (245, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (246, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (247, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (248, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (249, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (250, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (251, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (252, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (253, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (254, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (255, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (256, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (257, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (258, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (259, 6);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (260, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (261, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (262, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (263, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (264, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (265, 2);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (266, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (267, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (268, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (269, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (270, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (271, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (272, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (273, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (274, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (275, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (276, 7);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (277, 10);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (278, 11);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (279, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (280, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (281, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (282, 4);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (283, 13);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (284, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (285, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (286, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (287, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (288, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (289, 1);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (290, 15);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (291, 9);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (292, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (293, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (294, 8);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (295, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (296, 5);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (297, 14);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (298, 3);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (299, 12);
INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (300, 8);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (1, 'Martin-Krause', '701', 'Jessica Vista', 'Rodneytown', 'Colorado', 11);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (2, 'Vaughan-Bailey', '523', 'Rios Street', 'Macdonaldbury', 'West Virginia', 11);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (3, 'Hansen-King', '1040', 'Hatfield Pine', 'East Chadshire', 'Connecticut', 10);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (4, 'Rangel Group', '71748', 'Sara Junction', 'Lake Derrickshire', 'Hawaii', 15);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (5, 'Brooks-Gibbs', '80101', 'Atkins Courts', 'East Lindachester', 'Rhode Island', 10);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (6, 'Watson-Hernandez', '073', 'Sharon Cliffs', 'East Margaret', 'Florida', 5);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (7, 'Sullivan-Moreno', '70170', 'Lisa Centers', 'Camposborough', 'Kentucky', 12);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (8, 'Williams LLC', '658', 'Welch Locks', 'Carriestad', 'New Mexico', 15);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (9, 'Mcintyre-Atkinson', '1072', 'Sandra Knoll', 'South Antoniomouth', 'South Carolina', 5);
INSERT INTO restaurant (restaurant_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (10, 'Jones Group', '44940', 'David Parkways', 'Port Mariaville', 'Arkansas', 1);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (1, 'Monroe Group', '25014', 'Whitney Drive', 'South Karlshire', 'Ohio', 11);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (2, 'Gonzales and Sons', '03563', 'Rachel Greens', 'Johnland', 'Tennessee', 11);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (3, 'Owens Inc', '546', 'Katherine Extension', 'Kyleville', 'Ohio', 10);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (4, 'Jenkins, Smith and Hickman', '1708', 'Crawford Shoal', 'Lake Marilynburgh', 'North Dakota', 15);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (5, 'Williams-Cole', '2585', 'Blevins Inlet', 'New Antonio', 'Texas', 10);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (6, 'Schmidt, Gutierrez and Lynch', '844', 'Edward Islands', 'Castroport', 'Montana', 5);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (7, 'Madden, Evans and Christian', '2276', 'Elizabeth Circle', 'Seanbury', 'New Jersey', 12);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (8, 'Williams, Simmons and Meyers', '32905', 'Arnold Road', 'Laurabury', 'Mississippi', 15);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (9, 'Vasquez-Smith', '083', 'Courtney Oval', 'Lake Jamesbury', 'Illinois', 5);
INSERT INTO convenience_store (store_id, name, street_number, street_name, city, state, neighborhood_id) VALUES (10, 'Morrison Inc', '53352', 'Michael Lodge', 'Kennethhaven', 'South Dakota', 1);
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (1, 11, 'bus');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (2, 11, 'bus');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (3, 10, 'subway');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (4, 15, 'subway');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (5, 10, 'subway');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (6, 5, 'subway');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (7, 12, 'bus');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (8, 15, 'bus');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (9, 5, 'subway');
INSERT INTO public_transport_station (station_id, neighborhood_id, station_type) VALUES (10, 1, 'subway');
INSERT INTO subway_station (station_id, name) VALUES (3, 'Subway Station 3');
INSERT INTO subway_station (station_id, name) VALUES (4, 'Subway Station 4');
INSERT INTO subway_station (station_id, name) VALUES (5, 'Subway Station 5');
INSERT INTO subway_station (station_id, name) VALUES (6, 'Subway Station 6');
INSERT INTO subway_station (station_id, name) VALUES (9, 'Subway Station 9');
INSERT INTO subway_station (station_id, name) VALUES (10, 'Subway Station 10');
INSERT INTO bus_station (station_id, name) VALUES (1, 'Bus Station 1');
INSERT INTO bus_station (station_id, name) VALUES (2, 'Bus Station 2');
INSERT INTO bus_station (station_id, name) VALUES (7, 'Bus Station 7');
INSERT INTO bus_station (station_id, name) VALUES (8, 'Bus Station 8');
INSERT INTO subway (subway_id, vehicle_license, color, station_id) VALUES (3, 'S-3', 'Red', 3);
INSERT INTO subway (subway_id, vehicle_license, color, station_id) VALUES (4, 'S-4', 'Red', 4);
INSERT INTO subway (subway_id, vehicle_license, color, station_id) VALUES (5, 'S-5', 'Red', 5);
INSERT INTO subway (subway_id, vehicle_license, color, station_id) VALUES (6, 'S-6', 'Red', 6);
INSERT INTO subway (subway_id, vehicle_license, color, station_id) VALUES (9, 'S-9', 'Red', 9);
INSERT INTO subway (subway_id, vehicle_license, color, station_id) VALUES (10, 'S-10', 'Red', 10);
INSERT INTO bus (bus_id, vehicle_license, bus_number, station_id) VALUES (1, 'B-1', 'Bus-1', 1);
INSERT INTO bus (bus_id, vehicle_license, bus_number, station_id) VALUES (2, 'B-2', 'Bus-2', 2);
INSERT INTO bus (bus_id, vehicle_license, bus_number, station_id) VALUES (7, 'B-7', 'Bus-7', 7);
INSERT INTO bus (bus_id, vehicle_license, bus_number, station_id) VALUES (8, 'B-8', 'Bus-8', 8);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (1, 'Theatre director', 61);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (2, 'Stage manager', 62);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (3, 'Phytotherapist', 63);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (4, 'Seismic interpreter', 64);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (5, 'Medical technical officer', 65);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (6, 'Advertising account executive', 66);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (7, 'Passenger transport manager', 67);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (8, 'Structural engineer', 68);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (9, 'Data scientist', 69);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (10, 'Medical sales representative', 70);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (11, 'Teacher, secondary school', 71);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (12, 'Careers adviser', 72);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (13, 'Hydrographic surveyor', 73);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (14, 'Conservation officer, nature', 74);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (15, 'Scientist, marine', 75);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (16, 'Hotel manager', 76);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (17, 'Research scientist (physical sciences)', 77);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (18, 'Holiday representative', 78);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (19, 'Chief of Staff', 79);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (20, 'Warehouse manager', 80);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (21, 'Surveyor, minerals', 81);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (22, 'Actor', 82);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (23, 'Biomedical scientist', 83);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (24, 'Advice worker', 84);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (25, 'Nurse, adult', 85);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (26, 'Cartographer', 86);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (27, 'Architectural technologist', 87);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (28, 'Chiropodist', 88);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (29, 'Research scientist (medical)', 89);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (30, 'Leisure centre manager', 90);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (31, 'Printmaker', 91);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (32, 'Volunteer coordinator', 92);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (33, 'Engineering geologist', 93);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (34, 'Technical brewer', 94);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (35, 'Contractor', 95);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (36, 'Data processing manager', 96);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (37, 'Printmaker', 97);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (38, 'Journalist, newspaper', 98);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (39, 'Sport and exercise psychologist', 99);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (40, 'Manufacturing systems engineer', 100);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (41, 'Clinical cytogeneticist', 101);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (42, 'Youth worker', 102);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (43, 'Archaeologist', 103);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (44, 'Advertising art director', 104);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (45, 'Engineer, building services', 105);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (46, 'Conference centre manager', 106);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (47, 'Biochemist, clinical', 107);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (48, 'Sales professional, IT', 108);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (49, 'Education officer, museum', 109);
INSERT INTO occupation (occupation_id, occupation_name, user_id) VALUES (50, 'Loss adjuster, chartered', 110);
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (1, 1, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (2, 2, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (3, 3, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (4, 4, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (5, 5, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (6, 6, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (7, 7, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (8, 8, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (9, 9, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (10, 10, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (11, 11, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (12, 12, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (13, 13, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (14, 14, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (15, 15, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (16, 16, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (17, 17, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (18, 18, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (19, 19, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (20, 20, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (21, 21, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (22, 22, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (23, 23, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (24, 24, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (25, 25, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (26, 26, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (27, 27, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (28, 28, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (29, 29, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (30, 30, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (31, 31, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (32, 32, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (33, 33, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (34, 34, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (35, 35, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (36, 36, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (37, 37, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (38, 38, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (39, 39, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (40, 40, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (41, 41, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (42, 42, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (43, 43, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (44, 44, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (45, 45, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (46, 46, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (47, 47, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (48, 48, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (49, 49, 'PDF');
INSERT INTO job (job_id, occupation_id, proof_of_income) VALUES (50, 50, 'PDF');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (1, 'FP0001', '850-171-2350x6724', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (2, 'FP0002', '(917)479-4964', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (3, 'FP0003', '(892)107-2420x49667', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (4, 'FP0004', '(330)361-5887', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (5, 'FP0005', '001-507-797-3327x4144', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (6, 'FP0006', '001-197-432-4200x686', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (7, 'FP0007', '001-187-614-5730', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (8, 'FP0008', '(940)236-9323', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (9, 'FP0009', '+1-717-420-5066x57345', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (10, 'FP0010', '956-969-5642x706', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (11, 'FP0011', '789-868-1217x38807', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (12, 'FP0012', '001-522-845-1627x32940', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (13, 'FP0013', '001-434-038-1651', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (14, 'FP0014', '387.146.8435', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (15, 'FP0015', '+1-730-015-6594', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (16, 'FP0016', '325-568-2018', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (17, 'FP0017', '+1-354-050-6470x153', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (18, 'FP0018', '(273)618-0648', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (19, 'FP0019', '745.259.1205x83467', 'Parent');
INSERT INTO financial_provider (provider_id, passport_id, phone, relationship) VALUES (20, 'FP0020', '+1-495-282-2318x629', 'Parent');
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (1, 102);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (2, 105);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (3, 85);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (4, 106);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (5, 86);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (6, 78);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (7, 77);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (8, 74);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (9, 96);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (10, 67);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (11, 103);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (12, 91);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (13, 76);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (14, 64);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (15, 66);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (16, 81);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (17, 74);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (18, 88);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (19, 85);
INSERT INTO financial_provider_user (provider_id, user_id) VALUES (20, 109);
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (1, '370-93-1618', 'LIC0001', '475.865.0966x2796', 'Benjamin', 'Monroe');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (2, '488-33-6981', 'LIC0002', '806-560-8022x960', 'Tiffany', 'Frank');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (3, '247-26-2706', 'LIC0003', '755.149.2432x32012', 'Lee', 'Christian');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (4, '481-92-5377', 'LIC0004', '+1-735-768-4489x5318', 'Edward', 'Wagner');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (5, '459-33-9765', 'LIC0005', '896-624-7860', 'Brenda', 'Lee');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (6, '322-78-4820', 'LIC0006', '001-336-553-7630', 'Karen', 'Zuniga');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (7, '155-13-9091', 'LIC0007', '+1-609-055-3282x475', 'Ralph', 'Casey');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (8, '779-88-6828', 'LIC0008', '295-894-7420', 'Jason', 'Jimenez');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (9, '572-35-4369', 'LIC0009', '365.170.9424x70054', 'Vanessa', 'Pugh');
INSERT INTO broker (broker_id, ssn, license_id, phone, first_name, last_name) VALUES (10, '881-56-5340', 'LIC0010', '(850)006-7880', 'Gary', 'Jackson');
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 81);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 88);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (10, 103);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 84);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (4, 64);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (1, 63);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (2, 102);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (6, 107);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 66);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (1, 94);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (10, 71);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 74);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 64);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (3, 65);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (3, 100);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (10, 87);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 102);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (9, 70);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (10, 74);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (6, 96);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (1, 77);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (10, 85);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (10, 98);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (7, 104);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (8, 109);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (10, 79);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (1, 87);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (9, 89);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (6, 87);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (7, 72);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (2, 65);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (9, 102);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (2, 98);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (4, 87);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (2, 105);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (4, 76);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (6, 61);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (7, 93);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (1, 82);
INSERT INTO broker_tenant (broker_id, tenant_id) VALUES (7, 92);
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (1, 105, 290, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (2, 76, 224, 12, 2000.0, 100.0, 8, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (3, 108, 174, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (4, 97, 109, 12, 2000.0, 100.0, 6, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (5, 87, 237, 12, 2000.0, 100.0, 5, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (6, 82, 247, 12, 2000.0, 100.0, 2, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (7, 70, 239, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (8, 88, 117, 12, 2000.0, 100.0, 4, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (9, 74, 4, 12, 2000.0, 100.0, 7, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (10, 103, 164, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (11, 76, 100, 12, 2000.0, 100.0, 10, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (12, 85, 129, 12, 2000.0, 100.0, 7, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (13, 90, 288, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (14, 86, 206, 12, 2000.0, 100.0, 3, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (15, 78, 82, 12, 2000.0, 100.0, 5, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (16, 98, 285, 12, 2000.0, 100.0, 1, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (17, 67, 248, 12, 2000.0, 100.0, 5, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (18, 94, 9, 12, 2000.0, 100.0, 5, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (19, 105, 139, 12, 2000.0, 100.0, 6, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (20, 90, 91, 12, 2000.0, 100.0, 3, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (21, 82, 89, 12, 2000.0, 100.0, 6, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (22, 90, 137, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (23, 93, 38, 12, 2000.0, 100.0, 3, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (24, 61, 45, 12, 2000.0, 100.0, 1, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (25, 80, 142, 12, 2000.0, 100.0, 1, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (26, 93, 82, 12, 2000.0, 100.0, 6, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (27, 100, 247, 12, 2000.0, 100.0, 6, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (28, 89, 63, 12, 2000.0, 100.0, 10, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (29, 90, 194, 12, 2000.0, 100.0, 8, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (30, 68, 148, 12, 2000.0, 100.0, 1, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (31, 109, 119, 12, 2000.0, 100.0, 4, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (32, 102, 79, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (33, 79, 5, 12, 2000.0, 100.0, 10, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (34, 61, 95, 12, 2000.0, 100.0, 3, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (35, 96, 224, 12, 2000.0, 100.0, 4, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (36, 105, 83, 12, 2000.0, 100.0, 7, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (37, 83, 275, 12, 2000.0, 100.0, 7, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (38, 81, 270, 12, 2000.0, 100.0, 4, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (39, 92, 243, 12, 2000.0, 100.0, 2, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (40, 104, 164, 12, 2000.0, 100.0, 10, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (41, 105, 41, 12, 2000.0, 100.0, 5, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (42, 103, 294, 12, 2000.0, 100.0, 3, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (43, 69, 288, 12, 2000.0, 100.0, 1, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (44, 69, 13, 12, 2000.0, 100.0, 6, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (45, 104, 133, 12, 2000.0, 100.0, 5, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (46, 63, 181, 12, 2000.0, 100.0, 9, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (47, 64, 271, 12, 2000.0, 100.0, 1, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (48, 87, 149, 12, 2000.0, 100.0, 7, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (49, 103, 138, 12, 2000.0, 100.0, 10, '2023-01-01', '2024-01-01');
INSERT INTO rent (rent_id, tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date) VALUES (50, 97, 71, 12, 2000.0, 100.0, 4, '2023-01-01', '2024-01-01');