Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601880;
	b=SlxzKQ4ta0+aEVptOyMXeVmn00i+ijn0FGgAYTmmAZKAEsXoIDH6YPgCbrM8DLJChCwL
	 56lMi1As0LcAQ1RUCOPDP3YRI6pprdRoGf/m8GhLy5D756W9XGpAMQTdT3x7denJ5XBN+
	 zch16x0f3r06PhTZ/an6v0hofd0kjVKgUEdG6VHVV6YDStHVuj9LuYjgDmLUeyLLlf/5M
	 8ytL9v61F8mahN7LCqyUrHToHe178m/6VzuJu1yCl9MA1tviZo2ApmQJbjaS/lYOGX/56
	 VILuZFA3lyBlhLTEreBLaV84xDHZqQXE799Uf5dgkKjw13FQwJeCereVht3Gc368xvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JBahlw0BSTFIK+2BYvIp2lv3jJCouVM8oLSKaKh5Bf0=;
	b=oCkV38iF3sMehOngHu2VE2CNP1L4k4/JlTnlscMoF3L4q6tyOdVhJNmlBurSLzp6Usdq
	 5uZ9IqT+OHeAYQ467E73GWT5G7zwfaybNQkcyV3ABZv1eHgmpZNwjnt38WnX2pS8ckDC1
	 ZYIVDkfTrjN+NGJ9Ywic0kgKjoKpuUDncmn474mvIFVBs2cRogzykzVmZH5OovOvjRafC
	 OH4MCxmqUN3dH+Y3qVQYo8epickHzECvMNrM75bJerHNLrPDMehr8BlpP7Xq4YkoGSOu3
	 UUM8DtrdqegNAwbbOJnyPpYW8BgWRCn24hhhSIefw07UEKAJ5tg4/xHzz9eHUynv4Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQZY3bed;
	arc=none smtp.remote-ip=209.85.222.180
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D299606A327
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:44:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D299606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQZY3bed
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-943e8d35f74so259285385a.0
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793601878; x=1794206678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBahlw0BSTFIK+2BYvIp2lv3jJCouVM8oLSKaKh5Bf0=;
        b=jQZY3bedA75h5mL9U4lJCKKP1OWkkjax5oaslpe0icrr7xNWD+mT9VPSDNloxGrivs
         CoSj0zZDZHESTYv0dGlNcRkq+VcC0fmjMjUou9DGIVy0c+hahq1xN/uCr9esUs9FMpbD
         txHYgHneSfSn8BL9uFovhc4iAklrhyJsyeHxcQNQ0gLx2q2z5sn6cJ7o0aLE9eVBnQPf
         g2Aa2bzjwIJH5NSZqkM8K5a999TqigiSILmvNv2fPrrXy5tJkfcJWFVNmgi/67XpR3Rg
         2OhY6zU+gGfWHpkeycAPv2U12ZpJpFSt0VYJgb5b3MXLGRD9fC/20zgnE5fU8z91wXsC
         c0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601878; x=1794206678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBahlw0BSTFIK+2BYvIp2lv3jJCouVM8oLSKaKh5Bf0=;
        b=LNQ1lCed05qEQ6Zop6vOIP+2PMD6GDTeSOktSGXyuSgf4kcqAVP+aO5BRRmiJTYOQ7
         k177cRZLBNkxeCBbZcJxGIjmA5/Celpj6nMQF3Y/MciM8xu7Ikoee9OMs7ZGj5cH7g0x
         OCC6S5XgWYbVZUa1V3tzrdqn50OrtKbxRPOMxmDnBZfaWl4EQ/2expdHNGI+FqFtjgZ7
         dt5cTk1ZEcHR2c+ZXFLL9/Mt3klTPETxsEQk8Iw1HnJUXMTdgw9aFIsyS99EaDb7gYod
         rCAnDD22iuxW0S1yxAOHGVvH490apdc/IWn/uKqDALnyXLe91YN3KLXGRCxkF9cgxevk
         iOaQ==
X-Forwarded-Encrypted: i=1; AKwUvBxrFF5y1cCSMFU8G0CIFbwL/sIVQwL5gr0AthoF/hG7JAQZiT5gkffgUMlbOXyeDAbKm6HJzO04lHpa@vger.kernel.org
X-Gm-Message-State: AFq9FYJYSTxNd/76TJOBYAL3ABZqfAdHMf7YTuGwtyC77HIH/3lsRBaE
	IWHuCGvvcOFbWVdb1LN7S/1AJcMZX5ajjj3P5616ImH9WcMRrhqztGD5
X-Gm-Gg: AYBFou3nuxV9rzwNVmWnyYjM+osr0lm8V+tYcxGupV34ptfRWCzuZKyv2O5qrHHfZd/
	2MIUesVjXoxBveaq/zKkA0Yg+L1OSDXw5psEIW0E013Tqk/81yfmGfSRH3SkX2OvXw3GMO7WpLO
	lX7KmnunH2TQmtjQQw/LJy58f/FKJKdI5jt6NBmip/tTNb1b6RhKA32zWkJzWUCfvSC2fiyLSvo
	f4xxLRBrFA0fEv5Z+hglo2qJ8s1W8igZmDN/8TMhqipBOhQVW7VyiP/u0di6eITgAtLDiNE5QAa
	mmzBy3JwCYnelIqkmVQCCxF+x9e0cno4EY4iKGV2CBsijZi+VxbVUu/t1hlEXiVLuaxvRMoZodU
	fFe5SPhiE9vZkbmefw9zYikDbgFBxhjlkpMDbR82cznFHpejprbUJBmscJGY9Ds81lJkJ+nq6p+
	1gbEGk/7yfO38hijsVgjk6LfMwHES5JvObHJctKpbqKj0eVpD6VVwngeX2uF1cORIp2J/gR6v7E
	eoBDybEVhN66P3o2+q/XtlKo/xS1R/omW5QYzzAK/A+Idvph/lQB7UJV4NNzAQv+F7igsBSs4Dq
	19Ea5JJWLuQRAgzvuDPnEHrqVotxUybfec35UaRreZabx6p2djw9sxSt9T0Senk9NctIvmwnBbr
	qwbxhpTlfhBq0Jgg+Uc6iLnhpIxzuDyuqWpa9Cct6BsXKLSFeYi2izg==
X-Received: by 2002:a05:620a:2686:b0:93f:5f83:2cbb with SMTP id af79cd13be357-94421581847mr1475900885a.7.1793601878603;
        Sun, 01 Nov 2026 22:44:38 -0800 (PST)
Received: from ip-172-31-15-253.ec2.internal (ec2-32-195-47-40.compute-1.amazonaws.com. [32.195.47.40])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9442581b2a9sm765276585a.13.2026.11.01.22.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:44:38 -0800 (PST)
From: Deep Shah <deepshah146@gmail.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deep Shah <deepshah146@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Fix use-after-free in siw_mem_id2obj()
Date: Mon,  2 Nov 2026 06:44:37 +0000
Message-ID: <20261102064437.23976-1-deepshah146@gmail.com>
X-Mailer: git-send-email 2.43.0
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

siw_mem_id2obj() finds a siw_mem with xa_load() under rcu_read_lock()
and then takes a reference with kref_get_unless_zero(). This is only
safe if the object stays allocated until RCU readers are done with it.
siw_free_mem() frees it with kfree() as soon as the last reference is
dropped, so a lookup that races with the final put reads freed memory.

This happens when an MR is deregistered while an incoming RDMA WRITE
looks up its STag:

  BUG: KASAN: slab-use-after-free in siw_mem_id2obj+0xe5/0x310
  Read of size 4 at addr ff110001042aed88 by task repro-rcu2/90
  Call Trace:
   <IRQ>
   siw_mem_id2obj+0xe5/0x310
   siw_proc_write+0x282/0x430
   siw_tcp_rx_data+0x12e/0xbf0
   __tcp_read_sock+0x12c/0x440
   siw_qp_llp_data_ready+0x147/0x260
  Allocated by task 89:
   siw_mr_add_mem+0xb2/0x2a0
   siw_reg_user_mr+0x19f/0x380
   ib_uverbs_reg_mr+0x2a7/0x4c0
  Freed by task 89:
   kfree+0x301/0x530
   siw_dereg_mr+0x31/0x50
   ib_dereg_mr_user+0xb9/0x200

Free siw_mem with kfree_rcu(). A lookup that loses the race then sees
a zero refcount and fails. The umem or PBL is still released at the
last put, since a failed lookup never touches it.

Fixes: 2251334dcac9 ("rdma/siw: application buffer management")
Cc: stable@vger.kernel.org
Signed-off-by: Deep Shah <deepshah146@gmail.com>
---
 drivers/infiniband/sw/siw/siw.h     | 1 +
 drivers/infiniband/sw/siw/siw_mem.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index dbc998248b1e..4ec9c2ac75e7 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -157,6 +157,7 @@ struct siw_mem {
 		void *mem_obj;
 	};
 	struct ib_pd *pd;
+	struct rcu_head rcu;
 };
 
 struct siw_mr {
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index 2a08817d3cce..be70dc9c8f81 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -115,7 +115,7 @@ void siw_free_mem(struct kref *ref)
 		else
 			kfree(mem->pbl);
 	}
-	kfree(mem);
+	kfree_rcu(mem, rcu);
 }
 
 /*
