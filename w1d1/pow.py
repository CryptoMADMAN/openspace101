import hashlib
import time


def proof_of_work(difficulty=5):
    start_time = time.time()
    nonce = 0
    while True:
        nonce += 1
        hash_result = hashlib.sha256(f"bigmoney{nonce}".encode('utf-8')).hexdigest()
        if hash_result[:difficulty] == '0' * difficulty:
            break
    end_time = time.time()
    print(f"Hash with {difficulty} leading zeros found: {hash_result}")
    print(f"Time taken: {end_time - start_time} seconds")
    return hash_result, end_time - start_time


if __name__ == '__main__':
    # Replace 'your_nickname' with your actual nickname
    proof_of_work(7)  # Change the difficulty to 5 for the second attempt
