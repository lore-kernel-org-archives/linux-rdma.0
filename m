Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795490469;
	b=UVKN8k7vu1wy35jRKs9do9uCHCJgdj+5OOLagySwsWim0poXxxw8jdpZmI1Hf1/X5tD+
	 SjIo7cslOmukjxcMTl7cZTcZxRtsPTp0tqWMUiv6q+Ew3Rh1KTLQn04/1vmLBdYs8MXv6
	 FpqbYs2Pb9nxq2pRg8cs7hgD6nH+bgfnS5+EQ0sSxRW+sWGPeH/HVQ7xiAYi5h5fD1/5K
	 iTm2aZAHkiMsa2y7Mk3tdcPRNaP8QWlL2rQR6/PPG5vIIsshjMASHmD16lCTqKsgMopfz
	 b/sPEDHXZXRwWM0Ku2u0uA8Rxa3wZyjEkjDnAnnFuVAjjRR0uW9+08IvB8X3dhhh3EA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795490469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=ZWDg+cYEzmZ1vYvzbJGAnTzFCORxgLKMXanTjf9ODFg=;
	b=CLy2r7Fb1cJ8PZQ91O5EatzDlDfphbEYgFqeAApzDjjalYmAckGjbhRNiUy0GOvVd9Cy
	 7cT2v4PQamTdRZb1BT7z92jNbfTTJuXhHA3+e/iM7fXmKAp0qEGlg3a2hGvl9tr0JC8kk
	 9F/5uIWSSf31m0W06vMNhSqUsG+M3KDsz/rGCv4LWuOnBRRvkdPP/IILqJag1wlek3MVM
	 lYH75RDb5gdp9K6TAjYhzk+8Et/U3qy64oL9JFgNtbtcdv7X2qf7xP6piCmJHVB/JiatA
	 2RA3fiIrf2/bM0+hRelHHxTqmmvKymbTjByloeUfDaxYILQ+OA8Hbqs2DV5sVkzRB0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZA4ozIKd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.54
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA3F606A32D
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 03:21:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EA3F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZA4ozIKd
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-679aeeddc6bso3744736d50.2
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 19:21:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795490467; cv=none;
        d=google.com; s=arc-20260327;
        b=noW3+HTsnmiAJBiBRngASxCr1pKPQdP5TnVi1VaYjxIGuljxQAsEFkKn6FgF+YVbTc
         EudICyXQqLef6QUg92a0iWYxkQyallDTO/GJvGLczYQkA8LvTk9reghGho2GM6z8bnLl
         YP83PQh9iI9WPv6qyXHjK35E4cIi/U94QTdIUMLf7YuoYD9QEB7ESY2myMpNKRcflL8Q
         G12TwXbSzuyT2u1qKTzVNUkV+1bUj1526ylnI5SAo7SrqDKPrYT2uqm70sidDXrnC79x
         e3vjUjwW69r/46zeeKTI3gqgoDWnneUY3gp3H2IaL2ckx6J/wrjsj5xmz1n/AFpHV95F
         BnHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=ZWDg+cYEzmZ1vYvzbJGAnTzFCORxgLKMXanTjf9ODFg=;
        fh=r5rcDUH6dyWmM1CvuBtoKUquYHdrhvqgKAxLLVZCW1E=;
        b=g5+D+/BOvtuH2t2TTpiYrf3tlxFH7BVt2i7gn5+YCOhY5lKmkst4U4a+eGy/kAi3Lv
         Vwk/QH2w/kmbRC6c0sT6JwqnEWuyH/3E2fM0i6q3ruL2p50zsgfXn907zgu+sIsaHErg
         YNSEmfrLbagYKexSaQlg/6N5ZqiQAfuxzqCdnq8VlFU7o/eV7tRxIrqW5Er6kXwrZPZA
         jgFD6dAcLZbF84QzU4c6GQFRGEc+G/CVS6AH5nQiEOrMw5GXnLwb4U95XeesNeKz3Vxd
         rXWqov0OZrRiqRcHQrgqkE1hiKGKB5w3sXHHPyVJwO+Qi9EknVUql6TeFiN2Fr6NzQRO
         29AQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795490467; x=1796095267; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZWDg+cYEzmZ1vYvzbJGAnTzFCORxgLKMXanTjf9ODFg=;
        b=ZA4ozIKdl81b1ff899siClY9b3FPWUK+FeslD9UvwKLAjcj3ZhON1AYyzagGeCHFnt
         82vZuTYRetYc5UdSeMtg20/XLuI74Kal1khr92UKfyMTnsqKq7hWmSNMKVJrm+g+Biel
         VjlzUV48TlPKI3/q7LWDDslWbXDJiVjPTr00k2tpdeDahIRxQcdf4bbkFI9rAwIu17KV
         jr80iJfN0LW9LqFMkYdxPJRMNylOmXAaaTpgOpnPHF9B4Ua6H1SymjsQw73LcGMdmkrp
         a85vYd+owM3tsi1JzmQaHeszwNwLSXQROcIxONXG87X31pGky31cVpgxrIWEFMfGOZRV
         Q+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795490467; x=1796095267;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZWDg+cYEzmZ1vYvzbJGAnTzFCORxgLKMXanTjf9ODFg=;
        b=2locd9lpkOw2Cdu2mtwI0C3YjpGSpGHiRqRIXMfmUiyWMYOJR0EBgoba8Mac+FU6MN
         jo/7ce0G+5VOrI2RwS8wKrbDGNJrvjX6+Vmpn8YdS16wGkPQ4X14g5HirW0is2Gn6k65
         SSHJnp/4gkZGGV2ILQeBRtn3A2+6G0zUYLfVdNqq0TSJdHH9h1c1ytZ2e+dFX8ktG+OK
         SbQVi6jYdeXmY30PorpnLldVoYH8dVwrb8NjW/j5i+WziVIKB+U3H3QLQXlYQ3XW08io
         t3pIIEVdi2aYm9zdRkPKt8sh15hjb50U4gwgiuGvfnHhzULBBYoBa+hvk2VhsIIU6ILR
         E74A==
X-Forwarded-Encrypted: i=1; AL+hErGRs34oMC1QhkTxmfMZaLtQh6MDTY58G4C8tMHCGaZXmlrWeVdo//wo8XUr6CCxfYmk5tMnciLKpa+B@vger.kernel.org
X-Gm-Message-State: APuU4Z94eWc17YVd9B2dapiJajofoH4FuEg75z8H06nNFC6Rmsq6pP3m
	maQGUkx5rFpcxPpXzTLxvhbUFaUMcxGz4vUHlCzEs+rHTKL1jyblEdPuohaYqpwBQFzKUball9J
	w96sHBykL4PmePHgj2I+uAmjpjwkOdzI=
X-Gm-Gg: AZFdTZdJfLSup0RvP9Edx+NSe3Jyza5hJdzUd7avZcarAMyywLqx7ZIxi0hSNSQYqoO
	RlROGZ7CRp9HppAG9D67wtFNjNxwDBQLL+6lRZxpvLmZkpqKZZebFyC4avCYJX6k3C0t3Ke7sOx
	gQ0srhTKcq920+uaL/BlXlKmcVWXg8biCclDX6SxdpsGeS01kDUIoLwIHl2iS2WSqp0GF562j4p
	jHXZ7jbrk68o6NnM8Oo2L03gYTwCRoevhfqWYFu2JrcGrp7/EsZjpnBtTb8n92HUBzW37H6d/ap
	fYAEXPCXfqgnjHs6yQhaauDPX2j+0Yhts6te6cB9DZhfToBywArJDtFTowhSRReFbGJS1kVGi7q
	jmPXhQjN/bWT/p7nQnhkubs2UyaYv8uHlN+KvJhhaGHLfRNo+QW4+61UDgw==
X-Received: by 2002:a05:690e:1905:b0:67b:e67a:da38 with SMTP id
 956f58d0204a3-67df4423620mr4510969d50.21.1795490467284; Mon, 23 Nov 2026
 19:21:07 -0800 (PST)
Received: from 723974502065 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Nov 2026 19:21:06 -0800
From: Qican Ma <goonsomeway@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 23 Nov 2026 19:21:06 -0800
X-Gm-Features: Aa3M54oi5W3hts7IvD6RqrKWmrg1C4_Je8YHGmDB5ytcVLRAJrf4yW87opup_rg
Message-ID: <CA+OT+OPkNsk2QHczVmb6KVJ+z_1tpH9DXm8JmACc5E6x-YFwPA@mail.gmail.com>
Subject: [PATCH net] net/smc: serialize clcsock release against CDC receive path
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, 
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net, 
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In smc_cdc_msg_recv_action(), receiving a close or senddone flag writes
RCV_SHUTDOWN to smc->clcsock->sk->sk_shutdown while holding only
bh_lock_sock(&smc->sk). Meanwhile __smc_release() drops the socket lock
and calls smc_clcsock_release() (which clears smc->clcsock and calls
sock_release() under clcsock_release_lock) before calling
smc_conn_free(&smc->conn). Even on paths that call smc_conn_free() first,
an in-flight SMC-R softirq that already looked up the connection in
smc_cdc_rx_handler() can still enter smc_cdc_msg_recv() concurrently with
smc_clcsock_release() and dereference or write through a freed clcsock.

Free the SMC connection before releasing clcsock in __smc_release(),
matching smc_close_active_abort() and smc_close_passive_work(). Because
smc_conn_free() sets conn->freed = 1 while lock_sock(sk) is held and
release_sock(sk) synchronizes on sk->sk_lock.slock before
smc_clcsock_release() runs, checking !smc->conn.freed under
bh_lock_sock(&smc->sk) in smc_cdc_msg_recv() guarantees that no CDC
handler accesses smc->clcsock once smc_clcsock_release() can start.

Found with an LLM-assisted code review tool and verified by inspection on
v7.4-rc4 (b6a9fa34ce4). Build-tested only; not runtime-tested due to lack
of an SMC-R/SMC-D setup.

Fixes: b38d732477e4 ("smc: socket closing and linkgroup cleanup")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
 net/smc/af_smc.c  | 4 ++--
 net/smc/smc_cdc.c | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bfc0c7e71a1..1d8a602729c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -313,13 +313,13 @@ static int __smc_release(struct smc_sock *smc)
 	sk->sk_prot->unhash(sk);

 	if (sk->sk_state == SMC_CLOSED) {
+		if (!smc->use_fallback)
+			smc_conn_free(&smc->conn);
 		if (smc->clcsock) {
 			release_sock(sk);
 			smc_clcsock_release(smc);
 			lock_sock(sk);
 		}
-		if (!smc->use_fallback)
-			smc_conn_free(&smc->conn);
 	}

 	return rc;
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df32..499a2473b79 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -428,7 +428,8 @@ static void smc_cdc_msg_recv(struct smc_sock *smc,
struct smc_cdc_msg *cdc)
 {
 	sock_hold(&smc->sk);
 	bh_lock_sock(&smc->sk);
-	smc_cdc_msg_recv_action(smc, cdc);
+	if (!smc->conn.freed)
+		smc_cdc_msg_recv_action(smc, cdc);
 	bh_unlock_sock(&smc->sk);
 	sock_put(&smc->sk); /* no free sk in softirq-context */
 }
-- 
2.50.1 (Apple Git-155)
