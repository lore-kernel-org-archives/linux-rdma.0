Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E630528640B;
	Fri, 17 Jul 2026 02:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784254991; cv=none; b=n5bzrZS8ReDEUKgvjDLHtK8Xxef8gIkfIFEfJ8+00L6FL4uub9NewffcmEL4SuqkHO+C13ZJ8nm6u0Kmj5eWg1U0h9hdLUp5s5oPjpE12DjAzUI8WHodcBVlsrfSQ3S5EmBJWtpMACrHkJyKtYlN7CVb4s9aYdKsj4qRyKyUTWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784254991; c=relaxed/simple;
	bh=gzBB4RI0McIMNfkp6nyHpRhld9DwqhLSjBfqY3GUKeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TWHyczUtGXxUMbkQ04bfgZZPOPmORtRD0IoEUSabp7N1qlPi1DlSCVMbYwb4y932Prpe3cyqV/n1ygSwmuN94rBhafdRMfv2QOQxyNXAXqQdyF6ir8JHhOU4iTd43c7fGIU6ZAyPk1Y4kwMz6BHjOYBDqk0sBcMShWXPNNVe4XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZIHhImDa; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZIHhImDa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2t
	Lk+W75QTRAmJLveJNlKhA2n+LlU7iq3Aw06vBYpq8=; b=ZIHhImDa3PbJj/RzpM
	e/mhLIdCtYJWMN2bH1Z5TNomsAjVdK2VuvZXaeyuhuRngzlexoQh2JP0tXSHrWwY
	WTSBHKy/aHbb6Dt0WQKzJrvgtKeoXXGQKQ+QrhhcbRLmO8DrsUVApfTbbWoNHl7T
	1b1MA06Lds/Vgs2ToEO1LgYC8=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCnyPcFkllq3S0RHA--.2823S2;
	Fri, 17 Jul 2026 10:23:02 +0800 (CST)
From: Weimin Xiong <xiongwm2026@163.com>
To: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2] net/rds: use krealloc_array() for iovector growth
Date: Fri, 17 Jul 2026 10:23:02 +0800
Message-ID: <20260717022302.329333-1-xiongwm2026@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCnyPcFkllq3S0RHA--.2823S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF17AFW8WrykuF43Jr43ZFb_yoWfWFc_GF
	WIqas7W343tF43Ar1Ikr4aqr9xtF4rua1xury3KrWSq3y8Jrs8ZrWkJrn5AFsxWw4xCr1Y
	yr1DZrn2y39xGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8_hLUUUUUU==
X-CM-SenderInfo: x0lr0wdzpsijqw6rljoofrz/xtbC8AaWJmpZkga07QAA34

Use krealloc_array() for growing the RDS iovector array. This makes the
array allocation overflow-safe and derives the element size from the
array pointer.

Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 68be1bf0e..a567c97a 100644
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
--
2.39.3

