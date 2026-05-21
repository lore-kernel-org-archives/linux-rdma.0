Received: from mail-106118.protonmail.ch (mail-106118.protonmail.ch [79.135.106.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C8B3537C8
	for <linux-rdma@vger.kernel.org>; Thu, 21 May 2026 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779392662; cv=none; b=f43usvzJMrENkzsiGT/qF3OXOLC/MJVhbeo8RKc+xDRXcGpiBThhOovHFYYH+YnepwMZHBkexEy8GUwL8hd53+nWu+bRc1t5rQGiCDXVx3dd/BP17wYYt0je9UR14juG9185r8wv9wYC+0yUzjQn3bKzeKoYalTGb2ZY4WgnfmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779392662; c=relaxed/simple;
	bh=/jVx6DgJWdmFRCpDe1p1tUHTZzQJF37r/8KThwnzvbQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UAky/klcYCN1S/K2+1kxaPQ3zDq+RupAlXnPnnGRjTkfkmB32WtqcMiAAswWZyNMYQtoPEaecZsI3EjXX2MbCyj7anSdMCESSN3R8W3ghhIEEH7VM1oQnsUH+HxRIEL9D0TsZgUeBheKNrdakJe0fVG147I93JLk0pKXdZ6fTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Gk/0lcBy; arc=none smtp.client-ip=79.135.106.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Gk/0lcBy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1779392653; x=1779651853;
	bh=n4hrv0Ymlp2Uanz+ze7k7ucGfOqgi1atWwF61pMB24U=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Gk/0lcBy03tsgsY/Q2MNuMd9COM755k8+CcrNqopmsBvyXbMUiqIpSe5xUjUc8x47
	 HRtRJq7wBZ72p5Gk7OAJwhDt8+/fIIO/4/eQN53LbSguEAHZ6/9/jUt3o5f/ESadCE
	 bZDKv9msbR6JfhkrEL9dzpOVxOy1D29c4I6b4tvXD2SYgKdGyiwcdA/1ChpgzqV9sq
	 JkCG5QIWx/JX5w+9ZuFCctoskxXnoSD5zTSBDnJ8ORsv7hbaLM5abgYIwbxm5V2dK6
	 oeEo3x+6BdUiH0dxGYKuSfOtvKEaHyUWG2L3MeWjQhTdkzfVAucEzzjrXofL/d8eO0
	 +bX79UhNRI8hQ==
Date: Thu, 21 May 2026 19:44:08 +0000
To: linux-rdma@vger.kernel.org
From: Tymbark7372 <tymbark7372@proton.me>
Cc: zyjzyj2000@gmail.com, jgg@nvidia.com, leonro@nvidia.com, stable@vger.kernel.org, Tymbark7372 <tymbark7372@proton.me>
Subject: [PATCH 1/4] RDMA/rxe: Fix u64 iova+length overflow in mr_check_range
Message-ID: <20260521194402.811-2-tymbark7372@proton.me>
In-Reply-To: <20260521194402.811-1-tymbark7372@proton.me>
References: <20260521194402.811-1-tymbark7372@proton.me>
Feedback-ID: 184352754:user:proton
X-Pm-Message-ID: 557a0e50bb990c1a0c06b03a9bd96850fae6fa84
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

In mr_check_range(), the IB_MR_TYPE_USER and IB_MR_TYPE_MEM_REG case
computes both iova + length and mr->ibmr.iova + mr->ibmr.length without
overflow check.  Both iova (u64) and length (size_t) are 64-bit on
64-bit platforms.  An attacker setting iova =3D 0xFFFFFFFFFFFFFC00 and
length =3D 0x400 wraps the sum to 0, so the bound check
"iova + length > mr->ibmr.iova + mr->ibmr.length" passes.

After the bypass, rxe_mr_iova_to_index() computes a huge index value;
WARN_ON(idx >=3D mr->nbuf) fires but does not abort, and
rxe_mr_copy_xarray() then dereferences page_info[huge_idx], an
attacker-controlled out-of-bounds slot.  In the RXE_TO_MR_OBJ
direction this becomes an OOB write of attacker payload bytes through
info->page + info->offset.

Use check_add_overflow() on both ends to reject any iova/length pair
that wraps.  Also explicitly scope the local declarations introduced
by the helper variables.

Reachable from any unprivileged local process with
/dev/infiniband/uverbs0 open (world-rw on distros that ship the
rdma-core udev rules) and from an unauthenticated remote peer over
UDP/4791 (RoCEv2) when the target rkey/QPN are known.  Reproduced on
v7.1.0-rc3 + KASAN with a single ibv_post_send(IBV_WR_RDMA_WRITE) and
the wrap iova above; the kernel oopses in rxe_mr_copy+0x20d after
WARN at rxe_mr_iova_to_index+0x135.

Site A in rxe_resp.c (check_rkey()) reaches mr_check_range() with
attacker iova as well, so this patch also closes that path; Site B
(duplicate_request, also in rxe_resp.c) has an independent inline
check that wraps and is fixed in patch 3 of this series.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org # v4.8+
Reported-by: Tymbark7372 <tymbark7372@proton.me>
Signed-off-by: Tymbark7372 <tymbark7372@proton.me>
Assisted-by: Claude:claude-opus-4-7
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe=
/rxe_mr.c
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -30,13 +30,19 @@ int mr_check_range(struct rxe_mr *mr, u64 iova, size_t =
length)
 =09=09return 0;

 =09case IB_MR_TYPE_USER:
-=09case IB_MR_TYPE_MEM_REG:
-=09=09if (iova < mr->ibmr.iova ||
-=09=09    iova + length > mr->ibmr.iova + mr->ibmr.length) {
+=09case IB_MR_TYPE_MEM_REG: {
+=09=09u64 iova_end, mr_end;
+
+=09=09if (check_add_overflow(iova, length, &iova_end) ||
+=09=09    check_add_overflow(mr->ibmr.iova, mr->ibmr.length,
+=09=09=09=09       &mr_end) ||
+=09=09    iova < mr->ibmr.iova ||
+=09=09    iova_end > mr_end) {
 =09=09=09rxe_dbg_mr(mr, "iova/length out of range\n");
 =09=09=09return -EINVAL;
 =09=09}
 =09=09return 0;
+=09}

 =09default:
 =09=09rxe_dbg_mr(mr, "mr type not supported\n");
--
2.43.0

