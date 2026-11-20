Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154421;
	b=QWwOIlZsILI/6xTVwplDA4RwYak17KICrOO8SWT9jMqWGaQKRxhB/1dNGGuuxnBY5d6O
	 5J129gPEKnAP4hdz/B+EQzU8AFKr1TxObqZXqPsSXzwJUeNKagIEAc5wNZm4PT64pMDRE
	 olfWDR2Ao83Bk0fgmvzCyVtHC+pgt9dY9S/mym4Fz4mAQ93BuF7h9v9RRSSWnCGEkGTRi
	 /ydSV++Gl00lVU/IBFhXS82RrnB+ZGcTGGZ9f8cIsSQyOZHj3/xIyliETbfXWkXv7gWL5
	 jE/XlNapMMCJBKhxvmAn2Wt8QzRywGL/IgtltrgsEOKP2zhFxaIM0Ql7f7YPhdxZKMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154421;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=h+UAaXG+19jhgjfgmg/aGhbwlQh7Ejop03zjMArroT8=;
	b=4Hh3PE9VRot3IIRqhnFIRvzcKxD28SgIq5Ot1j6vmMzwWxKDAsqrUi5uBZXHuTzPD9Da
	 aJK16j8uImbgMvODTBBDE9m80tClVBNZCocT3aYxvraCtG5OGlMllyV7BkVzf8gCkdqA4
	 1yyIBYoMc86cW9gYuQnhvEWR/u47qddRsDhb0ENQfX+ujoarJujQpPY5hxHy4ozIOM+6J
	 Idy9bsGenxuk3FWMnTALValNfRlXEXFlJs+Sja/hdxvduCMUbXP3f0mC3yHu2a2ewoxiX
	 sNo2lUUe0XQWW7VvQw1+gSw4WoglA3e4eDlUJq7RXxwvX16OcPGCgAlgIn4KSMMFKuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ikuyo.dev;
	spf=pass smtp.mailfrom=ikuyo.dev;
	dkim=pass header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=DobhMO7b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF450606A33A;
	Fri, 20 Nov 2026 06:00:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF450606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=DobhMO7b
ARC-Seal: i=1; a=rsa-sha256; t=1795154406; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cJAZb7vWusiyZ9NkM6MZ/92qQ5cEug44RqNfOpEk6R4ub2AZYyxpHKrjSUNreEaTpqKk+mxPUNTasusevD+cEZA5lrRrCaHeMQUEkZq1M7NMo4/k2gG+tQY46DnwjKateeZh30n91HPOAugsOmIRYoYybXKPrTZWTih5bDeqsuk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795154406; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=h+UAaXG+19jhgjfgmg/aGhbwlQh7Ejop03zjMArroT8=; 
	b=Emq501LA8pdkpv6HkrnF0voWth5I7xrl0/1EHeJ5Nm/0k+i9mR1IUQV4j82NdQ1SbETQFu/Llu282tgPlY3MhlLu7t5ksjOEHwGIJQszxq6Lp6e5w3D7nwry30SqKyUh6BH1DRA3AMVs9eP9tf6uag4kSTiTtgwFU8i/uwKpfkA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ikuyo.dev;
	spf=pass  smtp.mailfrom=eritque-arcus@ikuyo.dev;
	dmarc=pass header.from=<eritque-arcus@ikuyo.dev>
DKIM-Signature: a=rsa-sha256; b=DobhMO7bNguqmscKJHgIIJkxg5ffHPKV0Y1Sinaw+yIXvBW2Z8qL7FD2BgZva7AZgyz1g0llPrsaLFRGY0aDpUeNthdpS1SzU2yDMDXGsRZMLZjoMqhQMHErH94YuSyMvlNeY2G2oFffR3ZQgq6pmUVHCsc4n9Bx+fGk+um3/WlFhB3tBvgmBa5YBUelhaO5oSAzneyblTcjdH+OFlzF6Mh+cLNOcbcR4ifDpl3vZlBmuUx8n+PSAd2DDeVb6/7MdW/LaQObXAGrbyXSnSaYro9F58TlV3OJJCVNABGsqQejIcYjW/c9jfOc3z0fd2xJ3jOGy94at16gVSEA4s2i9g==; c=relaxed/relaxed; s=s1; d=ikuyo.dev; v=1; bh=h+UAaXG+19jhgjfgmg/aGhbwlQh7Ejop03zjMArroT8=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1795154403369694.1551841151088;
	Thu, 19 Nov 2026 22:00:03 -0800 (PST)
From: Yiran Qiu <eritque-arcus@ikuyo.dev>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiran Qiu <eritque-arcus@ikuyo.dev>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/rxe: reject ODP accesses that wrap the iova space
Date: Fri, 20 Nov 2026 01:00:00 -0500
Message-ID: <20261120060000.302440-1-eritque-arcus@ikuyo.dev>
X-Mailer: git-send-email 2.56.1
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

rxe_check_pagefault() decides whether an ODP access needs a page fault
by walking its pages, and bounds the page index against the umem inside
that walk. When iova + length wraps past 2^64 the loop does not run, so
neither that bound nor the HMM_PFN_VALID and HMM_PFN_WRITE checks apply,
and no fault is taken. __rxe_odp_mr_copy() and the atomic write and
flush helpers then index map.pfn_list[] with (iova - ib_umem_start()) >>
page_shift, which the registrant controls: ib_uverbs_reg_mr() only
requires the MR's iova to share the page offset of the user address. The
entry read past pfn_list[] goes to hmm_pfn_to_page(), and that page is
copied to or from the peer.

rxe_check_pagefault() also keeps the index in an int, so an index of
2^32 or more can be truncated to a value that passes the bound, while
the flush and atomic write helpers use the full unsigned long.

Reject a wrapping range in rxe_odp_map_range_and_lock(), before the
fault path, whose umem range check wraps the same way, and keep the
index in an unsigned long.

Found with afb-afl, an LLM-driven kernel audit/repro pipeline; the fix
and this changelog were also drafted with LLM assistance. Reproduced on
an unmodified KASAN build of mainline by an unprivileged user with a
self-connected rxe QP. An RDMA READ at the end of a two-page ODP MR
whose iova range ends at 2^64:

  BUG: KASAN: slab-out-of-bounds in rxe_odp_mr_copy+0x35f/0x410
  Read of size 8 at addr ffff8881037a2210 by task kworker/u16:0/13
  The buggy address is located 0 bytes to the right of
   allocated 16-byte region [ffff8881037a2200, ffff8881037a2210)
  Oops: general protection fault, maybe for address 0xffff888103d0c04a: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:memcpy+0xc/0x30

An ATOMIC WRITE to an MR whose iova is 2^44 above the umem start:

  BUG: unable to handle page fault for address: ffffed11202b3194
  RIP: 0010:rxe_odp_do_atomic_write+0x131/0x2f0

With this patch both are NAKed with no report, and an in-range READ and
ATOMIC WRITE return the same results as before. The wrap was not tried
on the flush path. The rdma-core v65.0 tests, ODP included, pass on rxe
with and without this patch.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Cc: stable@vger.kernel.org # 6.15.x: 7797bbb0e86f: RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
Signed-off-by: Yiran Qiu <eritque-arcus@ikuyo.dev>
---
Tested on mainline 4405c18c95d2 (v7.4-rc3+) in QEMU. Applies to
rdma.git for-rc and for-next.

This completes commit 7797bbb0e86f, whose bound sits in the loop that
a wrapping range skips; stable trees need that commit first.

Without KASAN, an RDMA READ or WRITE at the end of the range reads or
overwrites a physical page the registrant chooses. On a lab kernel with
CONFIG_RANDOMIZE_BASE=n this was taken from an unprivileged user to
uid 0; with KASLR the chain also needs an address leak. The rxe link
has to be created by an administrator; the trigger needs only the
uverbs device. A reproducer and the test logs are available on request.

 drivers/infiniband/sw/rxe/rxe_odp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 9d27244f89bc..2ab64f128e57 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -125,7 +125,7 @@ static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
 	bool need_fault = false;
 	u64 access = HMM_PFN_VALID;
 	u64 addr;
-	int idx;
+	unsigned long idx;
 
 	if (write)
 		access |= HMM_PFN_WRITE;
@@ -171,6 +171,9 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 	if (unlikely(length < 1))
 		return -EINVAL;
 
+	if (unlikely(iova + length < iova))
+		return -EFAULT;
+
 	mutex_lock(&umem_odp->umem_mutex);
 
 	need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
-- 
2.56.1

