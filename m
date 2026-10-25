Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792900993;
	b=1tmix3z4pyJp9apU9VDDuqjW8X9kcJg/vXDitxsk5YrV7bb40La4aAm1C2PcCXYfsPQn
	 l4cU8ULKXhcBW7/MyMz1dIYWNkeRtxurshtBRl6XZa0pzWsvPglmEwOZUucHWzo1LhV/D
	 eK9fYBM6i66Hse7yLGztA6IWTMvSs1++M946YcJxfxmgf9KZo9LPF3SOpZnc2UUbcQGS7
	 oIghF/jS4GcdAGMDWqWKPj1TzaAKS1uzpGk3ykp65/JDI4/a/HbhprPDKCxp+nlAxGR9Q
	 tXA8dzJgeKLHdtp28XDxaj3obGNuvnPOLIaCEyclbkjypNUcxBCoihZu0XYVVushYVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792900993;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=bXXWN0U2LwSgs5yFSiYomIOkF6F+3ijFGiBpJE+lZgY=;
	b=zTl8nprv87lc3IBWaVMcj8xALnZSyo71Asy5ccko9E4sSfn2CZs1/uz+F6A37AvBe5m0
	 M+ggvoK1UyaZrHF1zFzbCffNsM8AhpgVR01cfR6hw1iNX0irjJB5rMuk657GX7qWWezWy
	 pC0Q//HQGxui0+IDh2vjH1TkJnskcFVhCrsoV4bJXshyBD5c6elekxxZthltSrsqyxIwV
	 L2WoAtvCBx31nMySxiMGWhf2H1EOar3SIAKNco9TQWji9Sq8IfxlTHR5YAVmxb68DlDHx
	 GYeHeyN9mabWckVIZ+3spmVpwaHAWmpnWbsLN1VyoT6UStbw25XLA58yH8WDqS2wXaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DNKNW9T7;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BE8606A321
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 04:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2BE8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DNKNW9T7
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e8ad5b2f61so3064455ad.2
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 21:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792900992; x=1793505792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bXXWN0U2LwSgs5yFSiYomIOkF6F+3ijFGiBpJE+lZgY=;
        b=DNKNW9T7kGfS78TEh9BVgxXbbjDsK7FmBqAhYSl/KQ+eTH7raGVvtdvg1NUc98VoRU
         K+t6Nc6VFF63JU0nm30Oaoo7PWDuZqaJa/VGdjf1oEl1vKQws6xUEHvpigr1aU8XJKW9
         ARzBEbRowo/1PB62yadC/gAYjKkjUksvUtAWL5KNMcmW0it4u1TdjgS9IKYCVSUT/B4B
         5LmSmhiSWh9nYee/Q8xH/mbjnKv05BsnHAXumcfsZ1MU10WIv7HErjsSADO0LjhEhqVG
         kuOy2JsugMVzT+/xQMFxDhtCn1QSY8Ludbs8xew8apip8FeKjXp7edLasQnaxkyYNus2
         mgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792900992; x=1793505792;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bXXWN0U2LwSgs5yFSiYomIOkF6F+3ijFGiBpJE+lZgY=;
        b=GUaAptATeytCBUoomj38xayOwjKnKJ/zY7UE5nfY/123lqVynXiy9CW5hWAM0aHx4E
         /WjKRG7hfVx7BUexHxOaIQbWvykEpzzKE7U/1FTfSxCwxpaef+Uxzu5RNXMGASOdYxbK
         L6glL8AtqS8H/XFNsp58oquu0rVp0xK+4k0JeTYixFNXSfyiHAPcuAP4WBKk0DRMyrby
         PT1N+a+7Jj/wCfNVWF6RSEfC0fWj3jnZ/G4Dk66YCYnYBypziAd9n8v5yzfEDdZKcU5y
         lGcxyNh1z4fl2S4l+vJwATw628pBssb5ITBtqFgfb5Z+8sssVNN+m+uYOuay4FVGpJGC
         l9yw==
X-Forwarded-Encrypted: i=1; AKwUvBx3yBE7cg5+euSte2HmMlJWQB3M1/X6xO6Ce8e/TPigjcIAxwgGsc8ewCg9gzluFncadF8vDNohonj/@vger.kernel.org
X-Gm-Message-State: AFq9FYITyUCknUNjAWXjrS8jrwxuTDHMLPldHdMCylTkZB8/5QUpvJgW
	4Sxi7yzX4zNMj6u/GrzOcd+1qHWR+ff7KSEmCpyz8hMBx8G7sLYiDwTuG/1ueXhdte8=
X-Gm-Gg: AYBFou31P29kYuhDUhIJjYEFj2JqaV6xTZalxqX1sqRx51DC8N6D0M3PbLphDJ9n1w7
	r6DDNC5YYgOXwGlxaMy9cf6jEpFWSJdbeUrnwkdmXDtpCM4jEfSnbrdCri9Vhc8Lws6bGEqOeJT
	ZW4A2x7a5D8mQ44NdVNv+0jhmria3vuJofim9FGxbdLqCtW56HPNUfnwKFZfGSwyP739hwEZKwj
	5cX/ugJ3O9Gb+/TcM3KbHU67omVVGUx0KMLhH7KBXBSzL7fV+Luf/ZOKkMnvWvhw4nMHpH9MA5i
	Pj9S5bn66icvyAWzNi4YZBRcWiiNQ1VMy3eqUiQ8+sC+EBTQA5ij/XNo8fFINRKYxJRRPoFMrvl
	6ge8Hpqw2zMVdWvRB8Bdwsk0CVjTaXsK5jcuH+6IcdxmSSQf7A5k+9/OxIMOA2H8o1FFcYslGTT
	RY82XDe/gUmKNRScbIqT2sxmuNy+/e7W4gIWLCrEXE72adFuMi+mc0sZ+IBHxj0J3tIQRsKDQZt
	GOKaQpbAWUfk6LgwXFW6G1jzoiMC7i5cf5+TA4BTEPS6FGg5n8hEMg91b6GNGr/3Gju3ysU/zov
	YM4b
X-Received: by 2002:a17:90b:3c0d:b0:3ac:a7ee:6785 with SMTP id 98e67ed59e1d1-3ade9b35f05mr4994498a91.1.1792900992309;
        Sat, 24 Oct 2026 21:03:12 -0700 (PDT)
Received: from melokc-laptop ([101.90.152.206])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeb82761esm2921587a91.0.2026.10.24.21.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 21:03:10 -0700 (PDT)
From: Anfernee Cao <anferneemelokc5@gmail.com>
To: D. Wythe <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] net/smc: fix possible recursive locking in
 __smc_lgr_terminate()
Date: Sun, 25 Oct 2026 11:53:35 +0800
Message-ID: <179290097759.51540.15412712294727302463@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit

syzbot reports a possible recursive locking in the SMC listen path:

  WARNING: possible recursive locking detected
    kworker/0:2 is trying to acquire lock: sk_lock-AF_SMC
      at __smc_lgr_terminate() (net/smc/smc_core.c:1580)
    but task is already holding lock: sk_lock-AF_SMC
      at smc_listen_work() (net/smc/af_smc.c:2463)

smc_listen_work() holds new_smc->sk while calling
smc_listen_decline() -> smc_conn_abort() -> smc_lgr_cleanup_early().
smc_conn_free() unregisters new_smc from lgr->conns_all before the
early cleanup, so __smc_lgr_terminate() walks the remaining
connections and locks another socket, not the one already held.

All sockets use the same sk_lock class, so lockdep cannot tell the
two instances apart and reports a possible recursive acquisition.
Annotate the per-connection lock as a nested acquisition, as
smc_listen_out() already does for the listener socket.

Reported-by: syzbot+7ea1f5efd5de7e24f1de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7ea1f5efd5de7e24f1de
Fixes: 2c7f14ed9c19 ("net/smc: fix LGR and link use-after-free issue")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Anfernee Cao <anferneemelokc5@gmail.com>
---
 net/smc/smc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9974149659c2..5911368ae520 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1577,7 +1577,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 		smc = container_of(conn, struct smc_sock, conn);
 		sock_hold(&smc->sk); /* sock_put below */
 		read_unlock_bh(&lgr->conns_lock);
-		lock_sock(&smc->sk);
+		lock_sock_nested(&smc->sk, SINGLE_DEPTH_NESTING);
 		smc_conn_kill(conn, soft);
 		release_sock(&smc->sk);
 		sock_put(&smc->sk); /* sock_hold above */
-- 
2.54.0.windows.1


