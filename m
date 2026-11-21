Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795298103;
	b=ihWJAMl1wTw4aa0Xm0FSdu6B3K5Ykzl4U1w5mOv2wKcjSBsJ7wV3bi2guXmasM3tclJJ
	 6Q22Yip1SgmKBqadl5JRlNObSplUdWzuSwNqBHozRaleLzF7dLS+BP40m/Ycpa0Xh4Mbv
	 63/DjAgyS1zIFMnqmBoStS9OOGbmHjU4+IL1ZKjSRDYjSXIGj0nl7qNrmKzHEl9g2jUDI
	 QzVWyZkPBGi/qCvo319KSVZjlM2cB+CZqy96O4pNjVW9IVwfurvUyTcyjVHSUJAqz11J7
	 4kSfpiYCf0D1YfrNLqHTHaPDJqA1z1uFmU52VOIxo0B6jS8y7zD4y8G68xayPpKMI6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795298103;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=kGmVY32+NuAnAOyP2Ctly8NmP20icvToykE7n9QXz6o=;
	b=hZEX3fvViEsdhxTbJSyLYGHhtCNGlEJxZRRji4aDm1265XIVbNiRZDHfzkdlbbahQhXS
	 kiRyBE7Vl9nmGskCTrrXewAskXDWnDagvDqV6M8bTubaCvRe+aHiNzLA3HA/KgvnI8h+w
	 j2YkbU4qdbC51dL6XVKGjo95jivZPxfAdYT0lBFxbWNxJldejozoTBOxlfNkyTwcb9nAH
	 K7iOekYOFSvm1cAMYDkI315ABSckjUoK6i41EJvUqphCZGXBs5YwogVVqr9/lzjV4ZMHE
	 6h9sL+sA/N2BObm968D/+xFRFLcBDxricaZ6Yojl29h+tpq9jA85UQlXuke6M6n8mGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ikuyo.dev;
	spf=pass smtp.mailfrom=ikuyo.dev;
	dkim=pass header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=nRBHZWKB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895F3606A32A;
	Sat, 21 Nov 2026 21:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 895F3606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=nRBHZWKB
ARC-Seal: i=1; a=rsa-sha256; t=1795298088; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QaZ7rLkI5vmOwQeLKl2spOxwWwBJ0xY+Bw3NGfPN1aPelR2XJEIKV8hkeQKE4Pkl3PFjjJCwNQ4SRZ1XWkGOQPLFtJfcRzPVuEX5NtFG1z7B/GK5Xw2qSeiSFrssyKGn4aHultw5GcUzssINW8zFRjVeKpwyRVQmsoWEvkoFs44=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795298088; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=kGmVY32+NuAnAOyP2Ctly8NmP20icvToykE7n9QXz6o=; 
	b=isqL+VgOxQKksE1nDIndVfIiY7jwro06dAp1D7kS3bj9gDTX+Dn3scLAdCDg+o0piIosHyiisdmRPtpgAwHQecToSFmd4naAmqrYX5jV9dSFk2ZQpgcm5lDv+r/o6dhkLRi/jhlQ+etQuS+eQzpc+9u7gvr2UaErJksRqXvyyiQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ikuyo.dev;
	spf=pass  smtp.mailfrom=eritque-arcus@ikuyo.dev;
	dmarc=pass header.from=<eritque-arcus@ikuyo.dev>
DKIM-Signature: a=rsa-sha256; b=nRBHZWKBgcuZFcHnhCiAXZ2OUOMgfBvW72meeMVm6xGUWOYS4BS49buL67uxf8JkWmEUwZrb1CBfZXJm05Uo4Nel8nHXPYWjx5nydTl5pAyf3HxDSLJDRZDe2l6SLcfDmJReRCSzTJNPWBMPZaT38n54vHG+WWF0An7uNsbfGjviiMjAGGIcCeJ48iSWfH1piuo5ZgYvI9NNBtP4tkp1Y+VjpuBZUcHafBi4jI6I0ptuV9NjbHvt0gFfgpihR72vSPX4yUpCWmsHEdWzmVLz4v/ELs47IW5jFK3QClaPaflydYIS0FyuBMj+fFypBZo8XgZYZaDZm8/M2uOwDaQA7g==; c=relaxed/relaxed; s=s1; d=ikuyo.dev; v=1; bh=kGmVY32+NuAnAOyP2Ctly8NmP20icvToykE7n9QXz6o=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1795298086613432.94013479921193;
	Sat, 21 Nov 2026 13:54:46 -0800 (PST)
From: Cygnus Qiu <eritque-arcus@ikuyo.dev>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cygnus Qiu <eritque-arcus@ikuyo.dev>,
	stable@vger.kernel.org,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH v2] RDMA/rxe: reject ODP accesses that wrap the iova space
Date: Sat, 21 Nov 2026 16:54:26 -0500
Message-ID: <20261121215426.50988-1-eritque-arcus@ikuyo.dev>
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
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Cygnus Qiu <eritque-arcus@ikuyo.dev>
---
Changes in v2:
- Use check_add_overflow() for the wrap check, as Zhu Yanjun suggested.
  The tests above were re-run on v2 with the same results.
- The author name changed since v1; the address is the same.
- v1: https://lore.kernel.org/r/20261120060000.302440-1-eritque-arcus@ikuyo.dev

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

 drivers/infiniband/sw/rxe/rxe_odp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 9d27244f89bc..f28b5008aae4 100644
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
@@ -167,10 +167,14 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 	bool write = !(flags & RXE_PAGEFAULT_RDONLY);
 	bool need_fault;
 	int err;
+	u64 end;
 
 	if (unlikely(length < 1))
 		return -EINVAL;
 
+	if (check_add_overflow(iova, (u64)length, &end))
+		return -EFAULT;
+
 	mutex_lock(&umem_odp->umem_mutex);
 
 	need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
-- 
2.56.1

