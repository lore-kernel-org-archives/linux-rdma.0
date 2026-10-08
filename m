Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA1F3D3D10
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 08:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449104; cv=none; b=IfsssaTAWV0vHRoQJLBCOxvNqZVKlAOv8H2EZkG3D5VyypKXeYgHvrxRawdmQQa8GdsjUdnjDdp+4SBju/m23+9mLDBR3Aqe+Y01T6eo8MSDe5CHzt7E5kLD1HvGYG2lMMdnA0hFzv4uVTdkP9SulwHCJj4Y/rRJS7oNoqGEp2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449104; c=relaxed/simple;
	bh=u3oXVAtMhpkIy8FTkaike0U6LNVunwKRWME9UqOPfNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aGn3mUmIrAR+aoldBYaLWSLIbT/oXsFmDMDo6c0ZFNlr/65g19jgplVPPkD/Oncbt1xsOLVvuY/RiEZH2efsUp29z3oTXM0Ym/rZo9/fn408BmNYZvNeGIcgXItbvWbOLVK1+g6KUnjXBJ4T/CZyEtupapDOE2P0ACcQmC6gXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LcxbX7V5; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcxbX7V5"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-34c522572bfso85858eec.3
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 01:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791449102; x=1792053902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lwWsdIXelLbIWkcXFPRTLY38upfrcbnNJ647ZN9lsPA=;
        b=LcxbX7V5XWLW9JQ3wdf03a4MZCWibSs4POCDBJSIcQLIYEOi50T2z5kkYwsWapz/xU
         8NeE0EI6R5yx+WyaRZLhuttH0IOTE6GvjDqfKhqUcOY0LXJlZbLduF/ydIamrPFGbZSw
         Q2fZCgmdc8UCsuzrNiI7xsYd5I7sOOgNcQ7CT6LoMUxKmLv2OGrGlIl03TdsSvcpgFh1
         dFlVd/2HGLe8mee0uc0CsIyfWBiu4kbYqMapKdoZIplWMlCexpRjKUPxGVQrc5tH8hAZ
         58S2HeACtgX3MLq9797wIPmOe8HAll0Wbij7xxzkIbriZBqGXbeFGJzYXORjPW/fWtro
         EQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791449102; x=1792053902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lwWsdIXelLbIWkcXFPRTLY38upfrcbnNJ647ZN9lsPA=;
        b=tgmLVp7I6lF3Y2QydH71rLwF4mHoAKKUIySBWYyqUBDGPLDP9JrwIjqVtcQCY+X21S
         olmweoAIj2GFHeJMwIffaMSBbsYqFGQcdyjXzHLHhKM45ijcqMVTRXJ4nvxaO+fnOw/w
         LBA0FEoYyUyM99GgHZf/rlVJP8rWNtPixjLZ2zMvZIDuAQpZMr+i4Xl7hW6WhfKsG9N/
         VYIRfwuutiMBhVOWw9RVYLFr+HFntDaixeE1X0RoKxTCdi3VVOi3zr6db4N/rKbTRJAx
         tPfFFc66/4Ac9229CME5pL02kVYE/doM+4fDT+YAA2mgZWsqZed65JkNs+OOey+mbrCe
         bgmA==
X-Forwarded-Encrypted: i=1; AKwUvBzpcSkAXjCMk2hYumDOkx18u5bBBqy0ges/v5T61LnkBtK2kpnizI/3jtkYtprXzKDV78oN4z2Lf1C/@vger.kernel.org
X-Gm-Message-State: AFq9FYKr3cFyaJjjQTsgXceA1Y4pLgagAw+GBn0KEnsPO6+Sx4ZZGLlX
	WiWJqn5kuJ35TOyL7BKKQJJHj+DskaN/98OfnAk3gWd+VD9Rm5tQeIv/
X-Gm-Gg: AYBFou104qnqS4NTC6W2JPXI+Nxqu+hjHBxP34C6Vd65CVb6vMQWbSmHutFcnYyqOZi
	pr2ZLGbNU0jtbg4lRPiH2EQbk3a5e9c1f3Dd4joOJQeivjeCDb/sYvqOJrSgMKK5bp2xPpyW6W7
	NZZFS6J1Did+GVZlzig0thuNldtzttm4XzselpECiqKB2Q06jmBrUl9Frqw4cm/febpui91shU9
	BbP6Tfkl6YuUh6T/wF96v9RxpEpfbVDdW+eH/IR3v7TGVUeBQIr4VMPh3NvhMmeSr0rBz52hel/
	YMExC0sVCtFqLhAGt/bxPicBnWqN9XH4UT72tqiys/ZWs1wrfEr0WlqrirCEv3jbIZtMDRHMtAY
	OuUYcv7C+hut2kRwiMz6di7M3u/M72PhP7ret/ZUVFEhqdKf7v+nYG2SZTn8HjLJpFl2FldoB2M
	C8cVD+1uP5GJyzE87+UlT9jbrMkojT4WvbE4OGfViUy8crimLXYUIQ6rFlFGCBJsYZnnBKETpSw
	FN5n0d5fFOHBsaCqwnAyfXab/UhyhnIRKAkZNqU8aSkrc8AO+VX4dTTWIf7zXiPFJRCEA==
X-Received: by 2002:a05:7300:80c6:b0:351:8cd9:7a53 with SMTP id 5a478bee46e88-3518cd97b86mr1994736eec.0.1791449101496;
        Thu, 08 Oct 2026 01:45:01 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351735e316fsm9920870eec.11.2026.10.08.01.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 01:45:01 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: "D . Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>
Subject: [PATCH net v3] net/smc: protect clcsock lifetime in smc_getname
Date: Thu,  8 Oct 2026 16:44:44 +0800
Message-ID: <20261008084444.787449-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_getname() dereferences smc->clcsock without holding
clcsock_release_lock. Link-group termination can release the CLC socket
through smc_close_active_abort() while the SMC socket is still open,
for example after shutdown(SHUT_WR).

A getsockname() caller can load smc->clcsock, then the termination worker
can clear the pointer and call sock_release() before the caller accesses
clcsock->ops or invokes getname(). This causes a use-after-free; if the
worker clears the pointer before the load, it causes a NULL dereference.
The syscall's file reference keeps the SMC socket alive but does not
prevent asynchronous release of its CLC socket.

KASAN reported the following with test-only timing instrumentation:

  BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
  Read of size 8 at addr ffff888109abb4e0 by task poc/103
  Call Trace:
   smc_getname+0x19e/0x1b0
   do_getsockname+0xe5/0x170
   __sys_getsockname+0x8c/0x100

  Allocated by task 95:
   sock_alloc_inode+0x1e/0x280
   sock_alloc+0x3d/0x240
   __sock_create+0x7e/0x430
   smc_create+0x121/0x240

  Freed by task 0:
   kmem_cache_free+0xcc/0x340
   rcu_core+0x50a/0x1850

  Last potentially related work creation:
   evict+0x446/0x6c0
   smc_clcsock_release+0xa8/0xd0
   smc_close_active_abort+0x26a/0x3a0
   __smc_lgr_terminate.part.0+0x137/0x2e0

Hold clcsock_release_lock across the pointer check and the getname()
callback to serialize with smc_clcsock_release(). Return -EBADF if the
CLC socket has already been released, preserving the existing peer
state check and the callback's return value otherwise.

Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6.1-Sol
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Changes in v3:
- Limit the fix to smc_getname(), as requested by Mahanta. The code
  change is identical to v1 and uses the existing release mutex.
- Drop the new clcsock_lock and the other v2 changes. Mahanta will
  address the other readers through the broader CLC lifetime changes
  discussed with Dust Li.
- Rebase onto current net/main; keep the stable Cc.

Review:
https://lore.kernel.org/r/4bb7f15e-2cd8-4598-9bab-1ea5f5d2bb59@linux.ibm.com/
v2:
https://lore.kernel.org/r/20261003183325.2289707-1-nicoyip.dev@gmail.com/
v1:
https://lore.kernel.org/r/20260926180404.2721010-1-nicoyip.dev@gmail.com/

Validation: W=1 builds of net/smc/ passed with IPv6 enabled and disabled.
The KASAN excerpt is the original report; no runtime test was run for v3.

 net/smc/af_smc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e9f93b3ab435b..8b3ee70f8433f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2784,6 +2784,7 @@ int smc_getname(struct socket *sock, struct sockaddr *addr,
 		int peer)
 {
 	struct smc_sock *smc;
+	int rc = -EBADF;
 
 	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
 	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
@@ -2791,7 +2792,11 @@ int smc_getname(struct socket *sock, struct sockaddr *addr,
 
 	smc = smc_sk(sock->sk);
 
-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)

base-commit: 6d25ffca055a77787c21a36b66c253f76239411b
-- 
2.43.0

