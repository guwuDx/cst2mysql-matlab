function hashValue = md5(str)
    md5Digest = java.security.MessageDigest.getInstance('MD5');
    hashMD5 = md5Digest.digest(uint8(str));
    hashValue = sprintf('%02x', typecast(hashMD5, 'uint8'));
end
