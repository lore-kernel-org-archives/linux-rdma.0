Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424758;
	b=x+MX8BHVJvMmBySGcwHpCLKGvamerYbFyejxmL/3iep+WL0oD0cW6hpPeJoQA7XopZh1
	 rMwN9Rc+TUVwCRUoesGw5FBrTe2RjrKmy9JWceKUWt2NoKJNEmCyyfUCCURjIzj16O1Jq
	 r/adcfou42wrm7IsPfS/x+CgguypBrKymizHpey8CWECip/rJ2yieumDDFneZc6ixj+wp
	 3sCKhnBJTTmnPAB5tZCwQqqPCLznZ0rwAGxLF+EQTYR2ewXUAr2vLJtFLZ4+wHGMzxZEN
	 M2V3h8OgEKCLrETalL+QHiWuOFeN2if/25Xv/u92zYP5L7sB3/7QgvcDwIfwxonk3vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424758;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DNMNS9bjIlPpM4mJV2mBmIlqngWBVSFIpNHBbmVzyeE=;
	b=fMS+rJU4DpjDGiBHAMvViRTBfZJaSnkR3f4zHXbwnT5yWZhfxUzD95q0i9H5oG5FLms8
	 faVBSKDCqtG4/NkFu0IzUIpBK92Wn3wUKY2xqd0mk429Y54Jgjyl0UB5OL3JcnrlDBeIb
	 GrCRTJODkx//Zsnddz6akBzX5W+m9Cl+sSSAGEiYrQUBhOZLWSRowAIXK2wZsIkCUc8B6
	 E8yCnfu3uF97nrrQ1i2SukFfif/LP1lv1lqko0k6lth8VAbNL72J6SHwgKhJ/jfG1LXgw
	 p8QTI9FtqF3+6ZUGwAASqx77dXYpab277miDGyWhlerNkGJ2SXJSsZJTHmTaNocSe5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="rGUz/LH1";
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD814606A33B
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 19:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD814606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rGUz/LH1
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91f11161831so3845766d6.1
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 11:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794424757; x=1795029557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DNMNS9bjIlPpM4mJV2mBmIlqngWBVSFIpNHBbmVzyeE=;
        b=rGUz/LH1Hg4ztzYnaz0kw8LJKtEtrnr0UUfOvAN67vVaber3yRKo/TYg7KU49P+wTd
         O0rMBJXbiZB8qiLv1xgXmLavkJ0q8MhHR3KHsqj16ZxznvXlu7pF2BZHeWRCLuJA4rfO
         MNjXk+rQE9F6kw3jSZJjar5Izm57pFLvQmD49TmYS1J6auglt1H5teqzLNqTZba2Mv0o
         QXmHhKwbh0TbRVy4fj+6lp+QiplAtz2MrhjaofBlhK/+uW24czwIWmgAfzV/t6GSYAB8
         B0DDCS/4WYC6H0mFrhJxRNyrgUnakvujrUUhk8Fv9Yg6TnR6x1WbRWJ73CgQU/boRfgi
         ve8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794424757; x=1795029557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DNMNS9bjIlPpM4mJV2mBmIlqngWBVSFIpNHBbmVzyeE=;
        b=pdgr8onHNFLMA5NrvimScLK3d18T9CADFR6Ivc7Tb8glnBYl22Bxxmf0TBejHPY3he
         aWOWG7nVcaYPvWcAbxw2DNaD0AjcM6EZ7BZHxG9TYq6TKvgfshZmET8SSOd43ChqGIPI
         aN4v5yFvAMdEiuWRfC6Pab1H+wGV4jNCXmHKNDoDv1vW3JtP1V6/RiqKKG88K7W2ycCf
         VUjuMLdSic0solQu0Y2KvMh1A00hP4qhc1JxFhHRMYl+fHamY84MC9eOjQEUhVdXUqzx
         P/vg/BFqF0TJfX6G3aZ6grUWTUwm4xwJyoZycu/rG0gP0fxe1YPg1aeT36X/4uQmpGlV
         5ISQ==
X-Gm-Message-State: APuU4Z8WoMhvaHKkP2NYpTezicIe5H8Co0VegsyXtl9k9fdHmVpsBM1E
	VLGfDFeGWd/3TVTnTEvgbs/YcjbaTV6xQhztpQ7nUBf21lif86X/CKyUYlWQogw2
X-Gm-Gg: AYBFou2vWkYFUlRgd3QR5rS1xaI6P9D6sVMGAeKCJcNfro+WhqoMbmXfH4LSRjSqTlh
	4GS7Jurl1qPl0wQ23xUlBO4lryJzOCQC6062DowaDDFzia5C9iUIRmuziSqOUEid9m1M4Lp9T2C
	3AGz+yk/gIWy3NEQ1S+fk0bAJmhp4UgmDAQYiK7pLv0/Kp18Ry+BWySGwl1mGlZnJNgDfB0X3ds
	hZnWR9ZSTJoqMkDa2U5hhnFy7UUQq7Yfoj8KqpWtjEg5R1wBo120oFkeDk/PivBZ765BSPUYlXt
	ufcOJesLQr4k6G+AymEyBjnGZUjQJnClho7WH3gZA5q4WvCVQPzEd4mCU1Z+ppnHnhcezoSKBI8
	KErqsCME1UhiHjy5QMcLHhJskOuy3QTZyChR3Uvj+qkVXPkCxlDOjOo03EDRaat6sOhnvkvybqp
	okjgOx0QQvL0F4NG3CfzCfY7IcxTvUjF9QiQbk87E9hfweRXWswIJjEXElOzJ3iqX9+8HkUwGxi
	JPHDXuIhSrxJPlAdspMSfrIu5fDnynlfnK5LSRV05IfEgJmmXWks233/rUpp265VR/xp0NQlySr
	/PNpuLS9yDslC075/66DEKSfA5T+wX4ozi/w+yvr6rXTcHbEOUpukRM/iKtgtICrTwpTVl42nqM
	=
X-Received: by 2002:a05:6214:1c82:b0:91c:6258:ec97 with SMTP id 6a1803df08f44-91f0402b4f3mr63373686d6.11.1794424756577;
        Wed, 11 Nov 2026 11:19:16 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef05493desm53753466d6.45.2026.11.11.11.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 11:19:15 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH] RDMA/cm: Read the remote_id_table root under cm.lock
Date: Wed, 11 Nov 2026 14:19:13 -0500
Message-ID: <20261111191913.98044-1-lcy8047@gmail.com>
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

cm_find_remote_id() reads the root of cm.remote_id_table before it
takes cm.lock. While it waits for the lock, cm_destroy_id() or
cm_reset_to_idle() on another CPU can remove that cm_timewait_info from
the tree and free it, and the lookup then starts from freed memory.
This lookup is done for a REJ with reason IB_CM_REJ_TIMEOUT.

Read the root after taking cm.lock.

Fixes: cfa68b0d0440 ("RDMA/cm: Make find_remote_id() return a cm_id_private")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Found with a static analysis tool we are developing.

Reproduced in QEMU (x86_64, KASAN) on rdma_rxe over virtio-net, with a
test module that connects to a listener on the same device through
rdma_cm and destroys each active cm_id while it is in IB_CM_REQ_SENT,
so a REJ with IB_CM_REJ_TIMEOUT is sent. Another kthread destroys the
passive cm_ids. The window was widened for the test with an msleep(20)
between reading the root and taking cm.lock. Without this patch, KASAN
reported 46 to 48 slab-use-after-free reads in cm_work_handler() per
20 second run in three runs, on a cm_timewait_info allocated by
cm_create_timewait_info() and freed by cm_destroy_id() through
cm_reset_to_idle(). With it, there was no KASAN report in three runs.

 drivers/infiniband/core/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1a2c2775b14d..5347b7519a8d 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -734,11 +734,12 @@ cm_insert_remote_id(struct cm_timewait_info *timewait_info)
 static struct cm_id_private *cm_find_remote_id(__be64 remote_ca_guid,
 					       __be32 remote_id)
 {
-	struct rb_node *node = cm.remote_id_table.rb_node;
+	struct rb_node *node;
 	struct cm_timewait_info *timewait_info;
 	struct cm_id_private *res = NULL;
 
 	spin_lock_irq(&cm.lock);
+	node = cm.remote_id_table.rb_node;
 	while (node) {
 		timewait_info = rb_entry(node, struct cm_timewait_info,
 					 remote_id_node);

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

