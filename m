Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBC4417BE5;
	Wed, 29 Jul 2026 07:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785310822; cv=none; b=XfOrJ464fgkYftIdZm00kAWCc3h+2eM+D7rdh834Vdf5jcfSL8e4IJhO5B1IQ4i7qbK6rGjdcDVOzeUNow+lEKn+kXqQ/UXTsL/uQWyXzTqZe5n+KKxQsRaWt/xc9gcZt2nGPpxN5QzqexXGMFmql8+m9mIOeBa1gkkYKhfu9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785310822; c=relaxed/simple;
	bh=W2m4GKjDliOl9gE6+FQUEb/sgz+8k/uHita0QcFxW4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dJTTecrRzbrJqzXrJvZBu16fA1nn5zXWaUO4ItfO2PvW7PxmE92mDxsRown/l1rfaYcTQA5YMN59SipIT1tlIHAy2fNupG2hvheglya6KKnPZzCIWCWLkbiiXdRbfYzUCMag77ULBoCmlYgUFTvLcjNkS3A4GZzjd49A7XUb/+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=DHcqLLj/; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="DHcqLLj/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1785310677;
	bh=m5HbXrm1Oh2Ns433SpnlQGf5TPbWTCLJrOCC8z6ABzI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=DHcqLLj/xH3JRI57vodpkFvZW3vfnjLYxiI15ktO7qmNv25v+LRgzIS3oLMxH34MN
	 lx/K/hEILij8O2GQdB+6rF+zJC2JPQEu2fITGRTySxe7Zu8UaGNk8jz9/cjTPwvkJw
	 8lc8UmxFhn0QEcL57iZCM14FViXfIoEFIM/zBSDs=
X-QQ-mid: esmtpsz17t1785310662t76a1c55a
X-QQ-Originating-IP: h3sxEbmYyzwIYoR49OoAtcvoPrMj3petFfzBvkiKwGk=
Received: from hepeiyang-vm.wu.lxd ( [218.94.142.195])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 29 Jul 2026 15:37:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16913294432885679144
EX-QQ-RecipientCnt: 9
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
To: yanjun.zhu@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	pandit.parav@gmail.com,
	dledford@redhat.com,
	Peiyang He <peiyang_he@smail.nju.edu.cn>
Subject: [PATCH] RDMA/rxe: Fix OOB in free_rd_atomic_resources()
Date: Wed, 29 Jul 2026 15:36:44 +0800
Message-ID: <33A3A239F88659D0+20260729073644.2834066-1-peiyang_he@smail.nju.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OE2BWzPe+8GtCYzc985JiWLBUK00Vjh98BSD5A3kknIDS4CG3ACUerGa
	VVzcJkxmodEQjF09BOdd90+DqyjUCKtAkuwamJOKVcGcRIDf6S8v8sw9BxdV6xCP6pYPhpH
	Ij4Qy+vyp8/4m9liZ9AlSn0H8ld9NH7cgd7WOJM1KPXwZcJA2zPW1no10Aie4+jtvXegtAA
	yXCB3uuXFCV0GyFvi54pZQUTkTlrwoL0sWLRGqmrFucwBvBn/bsSl8Ozmeu+XUv4WxgrlgD
	10yvGYMDQbGJcuIkI3HyVfRUEp100Lyrpn49Vs83r+L/e2F4ntnFcYA4rNyv+gMm5fSMCSO
	fwZFAm7jNH1vIpwYt5kCx3dfrr5mz+63hP+XUlKRKQX7vpM4qRhCmOba57t96IpnJaqGKcw
	mwSLO458FGNTFHPZo7oD/rSivXzYDTDYdG4AkK3bIqdALcqPYKZJtS9Dyu3QU4XI2sYAyBD
	Ah93/9GdKl2G9hr0fKZ9SXonLKUszLiSS+fgQThlcPJp6hiGKZZvr1vqpMiLb+SK9xEmES2
	VyJilePQ64MYaRX/Oq3vFq/ai68Ma71YqP93uysNjQChog5KzFkgknDzqWEQAEqUpRGd1Zs
	6NVlSoOaZY+UVAMhSWCkqJl4oIQfU0wo+hWClv4TcVaQxZWDWs7uLdtGr8kPCEZWvN0KUEE
	0gtFGbnbzejhQ/sFW/sctHBoRrHJpUwMe6thajgK5NfwqluvQiFVlmALNGIaIbS9DnizhYV
	kGf8VeOMbtQ2+UrWAkwODhfn7O4YcurRcSKkJ22U7Lumn3hWJ8iZrdJgNX/Cn/YBK4anIIh
	JtllCrOSuq1OnuaFf50CpPzn8cgndYHISpHEMjbHIKnb5x26P628N5aPlDV+Vj1kEi8/Ftx
	7T+OC3xHlORIKjEli+o3CpHnGHpySIJ81iGQMfxZij+weWroyiUeXfHQvWU6/AK42BA4BKo
	u/mOUOoZQfY+bv9AISOerHCZF/HsLrnY3Up+/GE693lXkMY6I/H9VQpF92+RofFewehnNRV
	UwzGzx8Vzm0BoRPPFOuTZqZ21y0bajmj6W2dxtUg==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

free_rd_atomic_resources() iterates using qp->attr.max_dest_rd_atomic.
Updating max_dest_rd_atomic before freeing the old array can make the
free path walk past the old allocation and trigger a slab out-of-bounds
write.

Fix the OOB by moving the assignment after free_rd_atomic_resources()
so the old array is freed using the old bound. This matches the original
ordering in commit 8700e3e7c485 ("Soft RoCE driver").

Fixes: b6bbee0d2438 ("IB/rxe: Properly honor max IRD value for rd/atomic.")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index f3dff1aea96a..1fffe3c6685d 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -707,10 +707,10 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		int max_dest_rd_atomic = attr->max_dest_rd_atomic ?
 			roundup_pow_of_two(attr->max_dest_rd_atomic) : 0;
 
-		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
-
 		free_rd_atomic_resources(qp);
 
+		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
+
 		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
 		if (err)
 			return err;
-- 
2.43.0

