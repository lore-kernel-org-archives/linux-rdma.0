Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DA6353A6C;
	Thu, 23 Jul 2026 08:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794755; cv=none; b=e1gD0i/V4MkVyQd1/YbhfmZQ3cTjnwR5dCwepafiJN96A5K4kq3lDVgug8nPGVv2yOS/+dJYYvwCLONt1euU4uqJ2175Z9nzD6ZRctwOOawwIPRiJEQ+bFBIciAMEOjVVAG2NpIyDhZ13zOXiI3931M91nbpNmTGFCi43iSpIPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794755; c=relaxed/simple;
	bh=393IolKQoO15/q9PCM+54d5f+21Yjf8gsdNReaJKXeo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XbRcqVGqCmPAgLmKOYMlM1I7l2HydDiEUcFTSdqAy1og+HLwN4Nq8PrQE+B+faQGHdRBRRuUeV8QMG/M/u7ePBtQR3DJKKrUyXacKyYJhunW8tHqTDoLr3fkEQfXvsY7QONvZd1z5G+GRf8CPSw82NAG2H3ciXr3iPXyVSwsRwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WAGmoDjP; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WAGmoDjP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794732;
	bh=cfSzb1j3fDLRRpHqQ0EUwXS6MbMulPkc64LtYOOGOc4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WAGmoDjPG53k1w/ISd4TDxYfRrPaQT2deM+SwYiXgAFZywptoqow7IAc3fqSbBVeU
	 hxaOegVgvR+toy4Q+nurN/pRzoYISOKusyI1lUrLUtfl9uS2iWLALvqBAn52JTrPbf
	 BpXa1/F6JQsFds+edXhoY36lWev+CPezt5nDbR2w=
X-QQ-mid: zesmtpip2t1784794718ta429b909
X-QQ-Originating-IP: bWv97cvpQpUfRA+67ASoV4xpS1e+WkNnwAen4+2FDbo=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:36 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2455247409279869291
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	ynorov@nvidia.com,
	namcao@linutronix.de,
	mkchauras@gmail.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	kees@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH 4/4] RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
Date: Thu, 23 Jul 2026 16:18:13 +0800
Message-Id: <20260723081813.176792-5-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260723081813.176792-1-gouhao@uniontech.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MjQ00mYXMHtuYGGVDXTyl8GvLdtqMZkztecwYdYMU4VVxkjE5Dav9ZXH
	NAV8qhCYDT9fS5x1CI7An/JQUu9Uu639yid4tR9S6V4JBAsqhm52pYSUjRjO0ced5HnNUZ3
	IL/J8e3qeyHRrLytLn0pKDIgVwqYB0I1TAkHf4Ko+WIqsuG0sLxtfnArBf2XP7bdjtf5Unn
	NEa3to6Ub2WEqoNUWU0uLRmP2R5YxOxp8FKcChD8NizpqdxSN9knX36hw8mJqd7JmsLtiYC
	0Aq3fZ8rFZ6pjX8Z2/bWZhtO76b2rS7zmmlmubxbTH/0bYWlv6ovIOsrVTc7OOdoxNwwUBn
	KnTLQm3y13GuohhN+NHqiX0pzwE4LMG4/ghesk8sNoI3CXN9uZncqxKCiA3h3XSttz/cmeC
	ri9BJW4M5DZrod2kPPHsWe/uA+H+kMCOuScQWHQe6Bo5zi6fA6MLLXEz/W0lUYBHFwmcZZ7
	hUrH0ahh6kF8kbGhq+NLe2PlgHcl4BG6dqv6iugTQJrJwzX+TnzrarOci3z6mVv0TzLrumC
	568iTMYpNIC0tCqu0cZiw1vHMbohW0xfsnvVRZ8YYGcYagcwb5H19vu7yRpvll266nsAVXV
	UDgtrrII8erwgeOTbGOFzgWN3KuocAQZ3MJNA/WnC5KhBigcjSb2ADI17T+RQgK85X0vzZY
	C09QKKcHIjDLcAXBwnkl7yLWDFplTXKH3GfFSF55MnQqKl/6azcjQ8o1iaLKIuCM9EQAzPG
	tpDgHvdeS2fQoJlfvYjyIKlvAsbW7vUI3p1UjuhZbzcFGN1ZiRwKkFIBUFZfqlfjm0tXADk
	q1pdjZRuOWH9K90SDcXbp87sMYjJ0ucApE2cuNf5FBkRUc4gD/AQtQ+Ya7C4Cj6KPbJs5ZP
	SoZ4dY5Z4zw4xUhgm5RHohualf3k6QCzEhhz2NLcQaFkx1DcCB2YCsekfEE1ANfxIDEqJPR
	bWN1iLJ6htTj4QUqdmiEiteyFWdSHqKSfZmsire1KktI1US6E73eYIwzDLnidNrsP0ZdKlK
	kBUDMLWcatQ+a71vtK4YYuXUbHQuk9KlF16lbwwA==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

alloc_skb() with the __GFP_NOFAIL flag will never return NULL,
so the subsequent NULL checks and error handling are unreachable
dead code. Remove them.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/infiniband/hw/cxgb4/mem.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index cd1b01014198..08631de17c0a 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -74,11 +74,8 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
 		c4iw_init_wr_wait(wr_waitp);
 	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
 
-	if (!skb) {
+	if (!skb)
 		skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-		if (!skb)
-			return -ENOMEM;
-	}
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	req = __skb_put_zero(skb, wr_len);
@@ -134,11 +131,8 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
 					 roundup(copy_len, T4_ULPTX_MIN_IO),
 				 16);
 
-		if (!skb) {
+		if (!skb)
 			skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-			if (!skb)
-				return -ENOMEM;
-		}
 		set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 		req = __skb_put_zero(skb, wr_len);
-- 
2.20.1

