Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2CF3FC5DF;
	Thu, 21 May 2026 19:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779392666; cv=none; b=EDnPtD9xSkMfSbRFkybegcHZ+RVOkU17b8RPimvJKgQc9FfkZ0O9iLZTCRd8Lh10ALr4Hs+fNsG/l9P1HaCtj0IycIjE15LkOGjV47djfUaPHexQXxjwSDomwMIfQIj/b924wU3wYuyIYM8dMR+dT+FZuF9rK6OmpgB/TCp2JgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779392666; c=relaxed/simple;
	bh=Ff6ruEHMB0ltq4s5dCGilxpMh+640LeuxWIjWDVhTno=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGSMiiYfaRtbgjEVTwH++XnC9UDQcRMZ7F2p5INEmjjj3txmp6ePwdVE2TcZEjLPnF1VD2fakl9apbrcdSFXbYLnflBhAvvBKUsFxc51XJNYsUOttOhhWVfTBU95zcBE/IiiPjLDt3HIzesMeFNaZdNHHuVOjPux21RcmZzJbkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=WfFsLrSR; arc=none smtp.client-ip=79.135.106.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="WfFsLrSR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1779392655; x=1779651855;
	bh=4KJ4KEd5RjIRumt2eLCykx1PGs+SAIa+4iOhMiqiMXU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=WfFsLrSRU/+ZBESxVmf5MtdeuWo58gDx9RpU2GGRwZ8ggAk2YPTPUvZlb4vJdovzr
	 3R3VgaAWhFdJcd4TuUIxb6HWEcYxXaObW/5lFiLYJUNzgFaXT1L74AvHStjqp+c3BJ
	 +g+VpiKSxZqnfVTvC91461HKE3++wJ1K6Q0iqt7BnB2F6bIYxVXsb2e+S3SbrLjl+P
	 yPZw5GgsfPPL11E/fbn1Oev9hbda0HHDRBcGgj8pqC/dPREG50CgD06XUOvR7sLxB3
	 yAfSw2BSxPQWVma3LD+WTygIxxFigNjJqS5OJQ54jRoOM6hXpfZNC0DffL7jLEfthe
	 bkeKG9a8GPAtw==
Date: Thu, 21 May 2026 19:44:12 +0000
To: linux-rdma@vger.kernel.org
From: Tymbark7372 <tymbark7372@proton.me>
Cc: zyjzyj2000@gmail.com, jgg@nvidia.com, leonro@nvidia.com, stable@vger.kernel.org, Tymbark7372 <tymbark7372@proton.me>
Subject: [PATCH 2/4] RDMA/rxe: Fix u64 iova+length overflow in rxe_check_pagefault
Message-ID: <20260521194402.811-3-tymbark7372@proton.me>
In-Reply-To: <20260521194402.811-1-tymbark7372@proton.me>
References: <20260521194402.811-1-tymbark7372@proton.me>
Feedback-ID: 184352754:user:proton
X-Pm-Message-ID: ab932696d59e57935871f5870f669ede0bc8be2f
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

rxe_check_pagefault() loops with the condition
"addr < iova + length" where iova is u64 and length is int.  The
addition is promoted to u64 and wraps modulo 2^64 when iova is near
U64_MAX.  With iova =3D 0xFFFFFFFFFFFFFC00 and length =3D 0x400 the sum
is 0; the loop body never executes; the function returns
need_fault =3D false; and the prefetch-fault check is bypassed.

Control then enters __rxe_odp_mr_copy(), which calls
rxe_odp_iova_to_index() on the wrap iova to obtain a huge index, and
dereferences umem_odp->map.pfn_list[huge_idx], an attacker-controlled
out-of-bounds slot.  hmm_pfn_to_page() resolves the read value to an
attacker-chosen struct page, after which memcpy lands at
kmap_local_page(that_page) + offset, yielding arbitrary kernel write.

Reject any iova/length pair that overflows by computing iova_end with
check_add_overflow() once before the loop and using it as the loop
bound.  A negative length is also rejected to avoid u64 promotion
masking the case.

Reproduced on v7.1.0-rc3 + KASAN with a single RDMA_WRITE against an
ODP-flagged MR; the kernel oopses in rxe_odp_mr_copy+0x205 with
RSI=3D0xfffffffffffffc00 (the wrap iova) and R13 holding the resolved
wrapped index.  A working LPE chain that uses this OOB primitive to
overwrite cred_jar slab pages was demonstrated end-to-end on the same
verification kernel.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with O=
DP")
Cc: stable@vger.kernel.org # v6.15+
Reported-by: Tymbark7372 <tymbark7372@proton.me>
Signed-off-by: Tymbark7372 <tymbark7372@proton.me>
Assisted-by: Claude:claude-opus-4-7
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rx=
e/rxe_odp.c
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -127,13 +127,19 @@ static inline bool rxe_check_pagefault(struct ib_umem=
_odp *umem_odp, u64 iova,
 =09=09=09=09       int length)
 {
 =09bool need_fault =3D false;
-=09u64 addr;
+=09u64 addr, iova_end;
 =09int idx;

+=09if (length < 0 ||
+=09    check_add_overflow(iova, (u64)length, &iova_end)) {
+=09=09/* let the pagefault path reject a bogus iova/length */
+=09=09return true;
+=09}
+
 =09addr =3D iova & (~(BIT(umem_odp->page_shift) - 1));

 =09/* Skim through all pages that are to be accessed. */
-=09while (addr < iova + length) {
+=09while (addr < iova_end) {
 =09=09idx =3D (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;

 =09=09if (!(umem_odp->map.pfn_list[idx] & HMM_PFN_VALID)) {
--
2.43.0

