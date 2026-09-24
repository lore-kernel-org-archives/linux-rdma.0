Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E277C439354
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 07:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235570; cv=none; b=BwKQome4F1SfOqsMd+0XmVZK/T97svdEjOLZ3np1Iy0FfUG6aM/+7cdtNHSR28WNvb9ANWskb8wL0C187TzfT8mHHxj5pPjo9052G9J5hdyjpYdzV2zDc0rtxxG6m3RpQYYP97S0RemxgwxNH01cVIZtglzHvHHD3tluffATu50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235570; c=relaxed/simple;
	bh=Az6kYyVN+DZHqxQocv8YxF7C+RNrrMmmAUuqs8ZFPOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nr/hjOh3+xHp6KilAT45jrsa9JxZ+zqwIeZ56mjML+6JZMLXlhXfJV9CcEkLGqA0pwhUP/K1c0xZzjBYqf+S7ZoFVT2NZ2KQKBl3StVrruawt06CeLuy3XNFsmRkQnaqlUavPcTwIBkT4Nw1CngfzQW20aIX0OnMYu8wom6mjaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUNHYwSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUNHYwSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E81E1F00899;
	Thu, 24 Sep 2026 07:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235566;
	bh=PycnsaoJFDYCrZ1NRyViAgardG9E4+feaO3a3o7nmnk=;
	h=From:To:Cc:Subject:Date;
	b=EUNHYwSc3yVBKLW3h2/gL7v3hxu6LRf0ekK+iz1pSbPmIC7d2Ct2FyWHyuMOu74+X
	 y48G4XNVmpUR3K9i8OFGHVEJ8cUOCgPX4A3MawVGwbfH0EqpdXtz4Dv5mg4e6PRAMY
	 MgQq8sEgcp33AndGXad+VSCGYgDnElNaJujR8HueP4s1dgzyaTUMosL8s1nF6+z+WB
	 E1eQ3+NTUTEBTeyalyaH0QXgsaaG/RJRkuM1jMiL3RK4AvmmkWM76cH5B8UZMBRAv6
	 c28WU7nHB+r/FKfzPCEYZSFIZQNSuPjcl3z2EkjIIxFuCMvQ3P61iOaVcCEK6dE1MU
	 wJcerQ0vobC+Q==
From: Geliang Tang <geliang@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Geliang Tang <tanggeliang@kylinos.cn>,
	linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/siw: drop duplicate check_app_limited in siw_tcp_sendpages
Date: Thu, 24 Sep 2026 15:39:19 +0800
Message-ID: <32ef40cc81486adb8f2d43585224ab44d7e77f73.1790234916.git.tanggeliang@kylinos.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Geliang Tang <tanggeliang@kylinos.cn>

After do_tcp_sendpages() was converted to use MSG_SPLICE_PAGES and
later inlined as direct tcp_sendmsg_locked() calls, callers that
previously needed an explicit tcp_rate_check_app_limited(sk) to cover
do_tcp_sendpages() no longer need it. tcp_sendmsg_locked() performs the
check on every path that queues data, making the outer call redundant.

The site changed here, siw_tcp_sendpages() in siw_qp_tx.c, holds the socket
lock and invokes tcp_sendmsg_locked() on every iteration. The early-return
paths in tcp_sendmsg_locked() that skip tcp_rate_check_app_limited() - the
MSG_ZEROCOPY allocation failure and MSG_FASTOPEN branches - return without
queueing any MSG_SPLICE_PAGES data, so there is no functional consequence
from omitting the outer check.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
---
Hi,

I'm Geliang from the MPTCP community. While developing "MPTCP sockmap" and
"MPTCP KTLS", I found this duplicate check_app_limited issue. I recently
submitted patches to remove it in BPF [1] and TLS [2], both of which have
been accepted. I noticed the same duplicate check_app_limited also exists
in siw_tcp_sendpages, so I'm sending this patch to remove it as well.

Thanks,
-Geliang

[1]
https://patchwork.kernel.org/project/netdevbpf/patch/1f7dc605b16fc0590f7cbf5a27d57271926c01ce.1790074764.git.tanggeliang@kylinos.cn/
[2]
https://patchwork.kernel.org/project/netdevbpf/patch/5bc803abb4e27054eaffc8b26db7812e6347b0dd.1789634247.git.tanggeliang@kylinos.cn/
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index f7dd32c6e5ba..56bd009879c2 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -336,7 +336,6 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
 		if (size + offset <= PAGE_SIZE)
 			msg.msg_flags &= ~MSG_MORE;
 
-		tcp_rate_check_app_limited(sk);
 		if (!sendpage_ok(page[i]))
 			msg.msg_flags &= ~MSG_SPLICE_PAGES;
 		bvec_set_page(&bvec, page[i], bytes, offset);
-- 
2.53.0

