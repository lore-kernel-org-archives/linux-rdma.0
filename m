Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54D128816;
	Thu, 16 Jul 2026 02:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784170298; cv=none; b=kP3e4IiNszUQdix04lH2ilNuwryrSUijqrpu7YNmvBuHTkUrCIvhNvQbfQMwrrvMIlYomc3YHpgx5qYdjLzvlQssBBI6SlmfgLxxF7QkTsDxZDWX0r6TpTnE88xxhFT/KrthlMiCBmwbtNpNhxeeB7SRpWXMurJMG8zZFxIgp0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784170298; c=relaxed/simple;
	bh=2eLnbA8QS6B9SboNULEg21BKR8Ox4U8MjzTCrpg6if8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=okNhR1UPqSc9rtM1ZFS8zgdwDxUDby/Ldnm2GZ8ISczqX+ACj2T8BYf3h4sapHnqqeb2y8Zv7T+kOMeHtuOC+szTvSlLk2s0l8L23fxzeoMhtJgG9SDfqGW/bE4GLPmyDhMIRw8MDLCX9I7xhkPHsPTh/a8Gjve1fFqIHTVdV9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ifuuU59P; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ifuuU59P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=C9
	KAP1ZHDaMSA3yO4tXkblJDarbQhE8bUW0bZ7S9OUU=; b=ifuuU59PTbJkrzKtQ5
	BhRydSltLun//hfQlg3Q5vfsrOnyi6Nax9YrXHaq12N/dnHuukclsZ412I/gMO6f
	3tUAX+HYWZLSww8XiKlZ83oEt/3xaf1OOfiTAITeEwl0DKbhHf+kBOyFDIv3VVRC
	3D7GZy7IcLbX2N7ypAMQghhPA=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDHmSURR1hqjNr6HQ--.48130S2;
	Thu, 16 Jul 2026 10:50:57 +0800 (CST)
From: Weimin Xiong <xiongwm2026@163.com>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Weimin Xiong <xiongwm2026@163.com>
Subject: [PATCH] rds: use krealloc_array() for iovector growth
Date: Thu, 16 Jul 2026 10:51:01 +0800
Message-ID: <20260716025101.118159-1-xiongwm2026@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDHmSURR1hqjNr6HQ--.48130S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF17AFW8WrykuF4xKF15Arb_yoW3GFX_GF
	ZIqas7Ww13Ja1rJr4xAry3tr98tF4ru3Wkuryaqr4Sq3y8JFWkZrWkJrn8ZFZxWw4xurn0
	yr1DZr1xt398GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRMKsj7UUUUU==
X-CM-SenderInfo: x0lr0wdzpsijqw6rljoofrz/xtbC8BKGFmpYRxJyXgAA35

Use krealloc_array() for growing the RDS iovector array. This makes the
array allocation overflow-safe and derives the element size from the
array pointer.

Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
---
diff --git a/net/rds/send.c b/net/rds/send.c
index 68be1bf0e..6a567c97a 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -971,11 +971,8 @@ static int rds_rm_size(struct msghdr *msg, int num_sgs,
 				return -EINVAL;
 			if (vct->indx >= vct->len) {
 				vct->len += vct->incr;
-				tmp_iov =
-					krealloc(vct->vec,
-						 vct->len *
-						 sizeof(struct rds_iov_vector),
-						 GFP_KERNEL);
+				tmp_iov = krealloc_array(vct->vec, vct->len,
+							 sizeof(*vct->vec), GFP_KERNEL);
 				if (!tmp_iov) {
 					vct->len -= vct->incr;
 					return -ENOMEM;

