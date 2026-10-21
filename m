Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602808;
	b=LGsfptCnKWDtSCGkGk/M+S8+p2jd+NCeY2FZS35m+CmnjB9z2RdgAgOITApASHwa2nCv
	 gxUX5JEnu3C+1zdPaR9GYhyzKGQ10f+WIhJj24IaOaUdu4CVG4F04dqPJcKwxwN5IEBXQ
	 9yB5mrFXZtFjAVuu06Mghfy28jafikPK+Unvlvp1XFKF0ElHJ67dlB0CCVDC+34K9h2bY
	 6ecgrhQuePPuH0Trr1DZx3d82noJqYi5UKarFKfkdAccaHkQRgX0G42f+eMxMv8o4h+sm
	 UP2aLDqEVB7kOKWqlIB728uJcqsYHXzE43CqfZ8/AJIMzpcHFsfLTNhKXcrwMIwnMbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TFjFXEQ8daX1SDzZ+zKTu3JqP3e56krBVno7avFksg8=;
	b=TIHy4GkJEY41CZDmnk+Vsj22CIMAj3qrrc60wtnrwpNHfVzcOZNerjoJmsUK9icIL9Rt
	 HzqkEkfWpEBf0UurD0B15m0cjKQiaLIbb+DUzDo8aQz+fFw7G2jMDP/nFNcV1oOCKzkhR
	 ATnderrmGPCHha+BA87xECDYOvLqJeyDDu3Y/9s63wvmW6feBOgEfG+0Lb2I0/GikEavS
	 XaD/4KzxrZxNoc9z+7YVy5hqHRDx/hDCW/bZNCOvMpXykmSXC8qUdC1TtsIIlAjj6Ly3P
	 a80AVsjUNrxmMrRBs4ENGA7SSAnEwSQzs5iBokZSTNoR74YtvGeI9ioaHLiU04/7Agw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=soWqeg8C;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88135606A328
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 17:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88135606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=soWqeg8C
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36681e85e87so1929378eec.1
        for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 10:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792602808; x=1793207608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TFjFXEQ8daX1SDzZ+zKTu3JqP3e56krBVno7avFksg8=;
        b=soWqeg8ClTWjGsUdU6T/pu3svwM0Pfxg2zZh/n9lNcDLCmLtKefWVOKifpL0zHAq1Q
         D6LtACxIh9ec8/1K2mp5qmfBvdxKMULxhe/jNV/dPtt5jFHja1SYX0/Qk340szBict3V
         QuZ38mRsn87CyEawQEZkkBVayuKUAZhkj9wst3LID72z3mWvw7f1HlpsHuR4B29d+rrF
         xNjBWHfVxPKiYyPiUwPc9mgdKoaBp28JqcNrF0lORvsQqW6BEXnCaE6rPU0vEBprTg33
         XKoK9jeF5X1sV46+j/eReNTBzPEMozvHY6FOKd82RD7CTFY/OSL1i7R6qF84ZAZO5HpP
         YEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792602808; x=1793207608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TFjFXEQ8daX1SDzZ+zKTu3JqP3e56krBVno7avFksg8=;
        b=B7rYXxYBj9XNkBx88lOrKhiUftvFS6h9kGhuSffgsjCLp7CkqztqtJlctYmYAWZpX7
         xgHhHaOq/SbDjLM6oWvDPh75BKG9/UqONBwFmu4oXL936eQgUcEZzQtpVLQHpeQlggoo
         UNRKKaOx2nDzolOkmqY+A6viFPL22HmV+ek0W8PGZfNnB0vCTyqKZuho26bXQZvTZFGo
         eE3nm6OCcwJ6BBK44YhS/h9IN41jRzcGnxUcAY2qI+Um+i56+Oka0eet1Z127bBCXsfC
         wf7+NZNxslHzdnJdyd5j7da9JjFl0w9+dfj8Y+EMpK2hHrx0sTzZyiwRQvDQ1+iEQQLl
         6srA==
X-Forwarded-Encrypted: i=1; AKwUvBwCo0BjnvcvuGTYu8yQwqUEhdK5IHgyj/H4plupwyPF819bdxI8Fobs6tsIlbDotobO49Tehm7RlbT5@vger.kernel.org
X-Gm-Message-State: AFq9FYKuE7aNsfDBqSmrNdbMzTTn6gluWvIASqWlOv5zWPem/BmPxEtz
	8IzYuEKpTRWqL8MxR1ZaGFSo6gsowFmsIBNfot0ScyNsO3JS6gJ85yaB
X-Gm-Gg: AYBFou0DgFD6mR/n5YqfnR1LFeQxro/7t7yuh4ukokdUobN3Kq0Fybum5pKUD00UuTF
	LR/atbKHj5PRbqJOQKxWj0oBl4iWGsUD7xGifTemNjE2kzK8YUCeTJVWgrB3j4NtlsCchdIxIV4
	9X/FaB3SimH6XnT7UtQue0L/Rx+mtFdB66w4bELpLoPj8p5rMGg+zH2nhzuKcs6lA+dPX2ZjV2b
	3TrLuectj45FDPnFHmjtPSr/Ic+ZhsmIniDKy9EiIHjDsk4Uz0ESwSnkLzo9h4US+95JgR/SVtM
	V5Nt9+HgZi5/34Ex/E42IGkPmq6pdTcR0vWLOChQFJL+j0ywaSndUYMpJ6kWi5CNHEwtBPR/2m7
	nKGZTpbj41rqxp4zW1SHCNFyBrM9nMy9/BH7eOzF5D2SpUd9kGGlT+c2u+hw9c9QlbtrmSosL6L
	85yZF4M7lMp4n/kV5L3J7i9r2g74birZCLkgv5lZfsWnqpykPG28XEHPEhKiPUAQg3BHxOj7vhv
	b085nqTOnf9VjCzMBilM/y0hWEB96pr5jcSanoW+hmXp9MsNvN783LhFYz/vkIsMWofNU8KaMlV
	JmSqWEivEGdFDTGYr76J6VKiqrAdUQ==
X-Received: by 2002:a05:693c:60cf:b0:353:8205:8558 with SMTP id 5a478bee46e88-3674b82ad86mr4897440eec.5.1792602807507;
        Wed, 21 Oct 2026 10:13:27 -0700 (PDT)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3674198f1d8sm12947635eec.24.2026.10.21.10.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:13:26 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: Ursula Braun <ubraun@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] net/smc: reject CDC messages after connection teardown
Date: Wed, 21 Oct 2026 10:12:57 -0700
Message-ID: <20261021171256.166870-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_cdc_rx_handler() drops the link group's connection lock after looking
up a connection. Concurrent close(2) can then set conn->freed and release a
registration-failed receive buffer before the receive handler obtains the
socket lock. The handler subsequently dereferences the released descriptor.

KASAN reports:

  BUG: KASAN: slab-use-after-free in smc_cdc_msg_recv (net/smc/smc_cdc.c:376 net/smc/smc_cdc.c:431)
  Read of size 4 at addr ffff8881064a4720 by task kworker/u48:2/233
  Workqueue: rxe_wq do_work
  Call Trace:
   <IRQ>
   smc_cdc_msg_recv (net/smc/smc_cdc.c:376 net/smc/smc_cdc.c:431)
   smc_cdc_rx_handler (net/smc/smc_cdc.c:503)
   smc_wr_rx_tasklet_fn (net/smc/smc_wr.c:445 net/smc/smc_wr.c:459 net/smc/smc_wr.c:498)
   tasklet_action_common (kernel/softirq.c:961)
   handle_softirqs (kernel/softirq.c:645)
   do_softirq (kernel/softirq.c:546 (discriminator 19) kernel/softirq.c:533 (discriminator 19))
   </IRQ>

  Freed by task 209:
   __kasan_slab_free (mm/kasan/common.c:285)
   kfree (./include/linux/kasan.h:235 mm/slub.c:2748
          mm/slub.c:6508 mm/slub.c:6801)
   smc_conn_free (net/smc/smc_core.c:1244 net/smc/smc_core.c:1283)
   __smc_release (net/smc/af_smc.c:322)
   smc_release (net/smc/af_smc.c:361)
   __sock_release (net/socket.c:735)
   sock_close (net/socket.c:1526 (discriminator 1))
   __fput (fs/file_table.c:512)
   fput_close_sync (fs/file_table.c:617)
   __do_sys_close (fs/open.c:1560)

  The buggy address is located 32 bytes inside of
   freed 128-byte region [ffff8881064a4700, ffff8881064a4780)
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Both smc_conn_free() and CDC message processing run under the socket lock.
Check conn->freed after acquiring that lock. Discard messages which passed
the lookup before teardown. This keeps the existing lock order and prevents
access to receive buffers released by smc_conn_free().

Fixes: a6920d1d130c ("net/smc: handle unregistered buffers")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/smc/smc_cdc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df321..499a2473b79b 100644
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
2.56.0

