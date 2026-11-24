Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505359;
	b=JnBuZ3C0kVxDEhnj5CgJ8jx/QLvZZtQ2fblHnKCcWF1zlPr5EgV8ebOjD51vh65Ccx8e
	 paKjULPan454UDN4WJOqu9MXkWSBBwS+3ZdZLbEi04/3i+nqwycShX3XimjDLjjYaITeP
	 /RJMp6xaftYgxQdJB0D5/61dZln/1A/1urs3DVSMzFeKDiPtRKjqZ1EU2S+tOC1n5khjJ
	 YvVkczYrC4I5OxRpmJYxYUPIHJTAchNNZGiL0w1XhI5p4Zddy2Y6O4UjkvIYRk1yPlwiT
	 SILAlTalurexILoCWb5gt1NDHP9RbityMrKci+8KaiWKLQTcE5KsrfkR+ls0uv3xcsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ff/cIHvuBVZnx7utLGrJmn640e8Haj+dm0NKl1pXUuU=;
	b=uMiTNMcsW/UGarAu0eWNkQ3xstWle+O27Ex/VWsRHi1kWFtBKWgVTHB3gEhsY+vD/BTE
	 9Pr1jmga8CjdAjUSaYTGqkKdVqBK7ddnO/PM6lhG1AptG34UdrCeSwiBmbMHcK16hNUNq
	 /vSruBHGVR3xF4XGgZQb3l2xA7uTW80do9Fxwzq33yvUTNHfh4IplTtNO+TQ9M776vCH/
	 B7kR/VG8gJw+ArI8aeG/hB+J1iBsFExHlRt542c8AwuFRlC73e/625RR//kcAIB/G8HXx
	 l9lrxecyYbCj7n/u4pD4/O8PqaloWs8gHqLYUJrdVllJ0A5InEH0KP4THPSJEL1b5Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ucmqpqnc;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD07606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 07:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AD07606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ucmqpqnc
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdb2893531bso2214558a12.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 23:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795505358; x=1796110158; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ff/cIHvuBVZnx7utLGrJmn640e8Haj+dm0NKl1pXUuU=;
        b=Ucmqpqnccjbj9PdQI0KJdYkmVPKb+A5q5QJjFGTEwbdad1o7vHAeliODepnaNiZQYw
         NJWztHrCr7wSYoNJTuSbQaFeF+vXmScRy5evJUEYUlZitg1QD75jY/bEN8NzqewwEfyp
         4/EkxePwiIse+km5wckl8e4xHoOaTyKL2PakL+UIyU1hTDRJkwmup9w/SwyCA+k0JKuT
         S7b/EtLoVLdTn5IgnxBxP/ARnxYNQlSsr+YhvMDc95IIphEtfxbE/CMKA6Xu9+/r7iLd
         jAQRASOlUP24itkMrQMxQ2sIzsMKi+FCMHfXqTnNrA2AJalwpf7DKQQgNF/Eso7sL6M1
         X+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795505358; x=1796110158;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ff/cIHvuBVZnx7utLGrJmn640e8Haj+dm0NKl1pXUuU=;
        b=G3Okwa/c+YFb9bIbYC+1CWA99aSfCs2bV2rPOpVSsxvJ8P6Xc785A79Kne59eQQBw8
         RaabfwanuVyiiAIO82khrNv2NKW0jHJY67Tuh8E4YAwAJsNpu7pNy8uPe37jjJ1mg2gr
         l+XGsKCErHFCLD2a0vPwB2OXqM+Dz09mmuHwLa0Vhh+aGkh+Eu0SDgDs8nx4VM6jjqtn
         pkyDw3JX+TUmmI0i0WdWKTIK/QrXwc1zNrxohSkEw4Pwk3cJgqLsZMqgfBLP4VIzIMuC
         LccTGDr1LYCz9z3CSq127ys4G10dLhFQMwvc8hAxQA9A2XENsWFG0PlLxBvgS7qEy27V
         qVVQ==
X-Forwarded-Encrypted: i=1; AL+hErFJU9YF+aufWNLUlIqqb06Cw1VxjgGuh/1GRSJ3PSvkmkdB/hrdrN+ywIAT5Z4AwTdQPG/YLgPmqvPp@vger.kernel.org
X-Gm-Message-State: APuU4Z/fc3hyfLz+GtVmiG6sg4IRv/323gr7KVgUppXN52W5IyBPyepA
	flWukZLa4WzaNJCS8DsIajy6vuRqSTSPxZWzVTaRUELGod3XY5pXxbQbFggoNw9JV7F3lCEU
X-Gm-Gg: AZFdTZfUQBLmqEObX37dCoPnrBWPBJxhVzWNhBGmeI8V4k14v4B6O3FKTVIoH1Tq+OA
	lU1aQQUWXISsT8ua3m410YR2w7FMn5F4F1KarObaJNiG6iA40fBXv9pJU/n86xv4DlOomcmZD/v
	y08NiElv76oXAd/14vl5SqaMbCltbzAilQULU3PD0M/aKyz5DAnVw7cUEvHDTl/Nv20S1LTjCXT
	vnN6dbplSWDC6+ISkB4nAQW5OFkTw8D1c9BNBjItzmtVxcby46rgbqmHj4vsZS5z29HM+IMVRG5
	jRQvli0Z+3wFQsMxE5c0n+GxAOGgRg0BAkVM7fPC1e/8bcH73R8eyxnooOjqIpDUPLYtEPBfQlN
	1gcBt1T2Q0HT2VPcHZvw2Lm8OSaOPF23b3UtFww30jjKq1iLtdTXaZsyYvsHOXvNrvpDCw7zyxj
	te9NyBvwEnU++JmrUvIpORQjW4ylf50L4eFu8zqNcH6QQ2YTtiM3rWVMw468QkuuMsWAbmujGif
	Vx0HIuj2MtLPpw5mbHd+k/V0kfwvr+ezDfGNZxn6ZrWm6Y5sHtlqE0zl3dHcIpfOMeoHzsGX9eJ
	304Q0jZCDUw4TzCklWBpgXP+hxssZq+5y2M5hxrwcZBWbwxKTG6ZErqd/PBqhWLivxHII0YfMqK
	NVWPW14u3EQjyTzOxbACloOb0lFN5iPJ4iqvk
X-Received: by 2002:a17:90b:2c87:b0:3b0:9e42:b67c with SMTP id 98e67ed59e1d1-3b41c96ed40mr12458674a91.61.1795505357803;
        Mon, 23 Nov 2026 23:29:17 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4b0f482bdsm5930398a91.14.2026.11.23.23.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:29:17 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net v2] net/smc: serialize clcsock release against CDC receive path
Date: Tue, 24 Nov 2026 15:29:11 +0800
Message-ID: <179550535135.21127.16258389542236461283@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

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
v2: resend via direct SMTP to fix line-wrapping corruption in v1;
    verified clean git am on net/main both standalone and on top of
    Bryam Vargas's v9 CDC cursor bounds series.

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
@@ -428,7 +428,8 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
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

