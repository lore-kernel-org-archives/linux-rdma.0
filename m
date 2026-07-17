Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFAA28640B;
	Fri, 17 Jul 2026 02:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784255162; cv=none; b=D1mZSoSNerfw6KlvbIN1cgoGnxUY9UcsmC+qEdrJW3Xgcudz88+oIg88hmTJ8jayA7fqyS4a/S+qRdwUbGj3crL8EG6iFGSRpGSLXuDnFQy4YeHQHNT9d5Q24Jt624zTiWLvk5J2c4HRRbYe55ThKSVzYQOI3Y4AlDQj9LExDGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784255162; c=relaxed/simple;
	bh=7BH44toD02/hpqrQK29UP85kPSUxVy8sa5IiveoK47Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dSedQrQWGT/a8Ss4Ua2N8n99EgR2BvPJFXqAbhDk2a4GEzjNWK4jdAymVibvADeEd1cNUR9pEYYxJQrabfmbc8/Dzlc7yLTRbXJK6AOlWYh7Q3fcb5EvtUKXk78JSm7CG9GcoIF8e0bvubfdUo++GgmshkYlP+1ktRCL1Yejs5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pl13OoFD; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pl13OoFD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ow
	/DjgFL5xgyty9oVKvPCB18FikVfpXISPMnhNy94M8=; b=pl13OoFDHZctrP/rYh
	MEY3l52gNMhyiQqFPfUNjC2tenP7B3rtdL41hQJ9WpkDaMK8YQh2rPSFx+tR1UKH
	AlZYG9Cn5W1GzxWS9526bBqtR5dCUP9mcgqW/maMGSpmiB7/vxcnEzOvFhn2Jm+L
	WMlOnNSRe+pqylkqvMDxy0Nao=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAH9nKgkllq1rGDJg--.64750S2;
	Fri, 17 Jul 2026 10:25:36 +0800 (CST)
From: Weimin Xiong <xiongwm2026@163.com>
To: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Subject: [PATCH net-next v2] net/rds: use krealloc_array() for iovector growth
Date: Fri, 17 Jul 2026 10:25:37 +0800
Message-ID: <20260717022537.331863-1-xiongwm2026@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAH9nKgkllq1rGDJg--.64750S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF17AFW8WF13Cw4xGr1xXwb_yoWfWFc_GF
	WIqas7W343tF45Aw1xCr43tr9xtF4rua1fu343KrWSq3y8JFs8ZrWkJrn5AFZxWw4xur1Y
	yr1DZrn2y39xGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnbtxDUUUUU==
X-CM-SenderInfo: x0lr0wdzpsijqw6rljoofrz/xtbC7wC9TWpZkqC+owAA3D

Use krealloc_array() for growing the RDS iovector array. This makes the
array allocation overflow-safe and derives the element size from the
array pointer.

Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
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

