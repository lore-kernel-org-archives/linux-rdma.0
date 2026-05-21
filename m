Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DEC33ADBA
	for <linux-rdma@vger.kernel.org>; Thu, 21 May 2026 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779392671; cv=none; b=b1d5BDjsg9rTD6C20PNvfHCmx10K8pAPL4qNKmYFAkWnVl+FekJ3PG2zv4ds1DTXhfPhRHEzRedWXvLU8nau28eWVy9Zw7gd2z900DjSVUcEzr32DesGuAWlsW4lw8MnzhFFHex+9fsnjZ3hatlTu59WRSdJeKQhOa9RtcJpctA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779392671; c=relaxed/simple;
	bh=bz3ie3tUW5ADUzrio3mf5l1+FhMVysQLUjpPFUKQpR4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dLsp7uG/E38OhuyBNU5sYndsO6AcWPVxnROEKYzPbvqk4lkzeAlE/o/vkWDfEjoROSk3L0Z1Vc2edv/wjUHbtLSYy2pfrZn8O3zmuO+YLZUD43nodibwWr5DkM/oooGY+BA8x7r5JHJci6oweev9o652YWmdp6JOh3vdS5wyT8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Hs0Vwz6a; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Hs0Vwz6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1779392662; x=1779651862;
	bh=qQmrYv/9HECiCjJmzvuoYE6+vChbYZ+McS7rb3j1BWs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Hs0Vwz6a8N64C50rt29cd8RcocCoq1SBtsdmDXcx7HHOuyNFZKVVXb0m83n9+PdEO
	 XtxVUoEi6n3tSWJY0D1ib3dSsw6cNZe2myzdBCTSY+M2mmEm/7YP0iU8HNUHJKL8Wq
	 mPyOzFfEwt6BhijbghxzJoUdYbtrX2M3o9FgTR4u20uVc4l6oEAGqVee/KEc632/7H
	 snDESoTYzvxPj+4JNdQ4kumpF6jjQGInVr6XuFPnwCJxmZA+7DbwFtUg8wGJmVaZA+
	 W24OavWUKsFxnoYMxF4gjwqxTe48IXMSzsktoKvhGAbOzM75+nKD+WQmueamk4CSbG
	 vM9DkIMra78Mg==
Date: Thu, 21 May 2026 19:44:19 +0000
To: linux-rdma@vger.kernel.org
From: Tymbark7372 <tymbark7372@proton.me>
Cc: zyjzyj2000@gmail.com, jgg@nvidia.com, leonro@nvidia.com, stable@vger.kernel.org, Tymbark7372 <tymbark7372@proton.me>
Subject: [PATCH 4/4] RDMA/rxe: Fix u64 addr+length overflow in rxe_check_bind_mw
Message-ID: <20260521194402.811-5-tymbark7372@proton.me>
In-Reply-To: <20260521194402.811-1-tymbark7372@proton.me>
References: <20260521194402.811-1-tymbark7372@proton.me>
Feedback-ID: 184352754:user:proton
X-Pm-Message-ID: a5e40ec1f35fc811286c100d5b2d61b1c69339be
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

rxe_check_bind_mw() validates that a Type 2 memory window's range
[addr, addr + length) is contained within its parent MR's range
[mr->ibmr.iova, mr->ibmr.iova + mr->ibmr.length).  Both end-addition
sums wrap modulo 2^64.  An attacker can bind a memory window whose
nominal range exceeds the parent MR by wrapping the comparison sum
to a value below the parent's iova.

This is the same wrap class as patch 1 of this series; it was found
by sibling-site grep against the other rxe iova checks and is not on
the OOB-write path of the three primary bugs.  I have not
demonstrated a downstream OOB primitive that uses this specific
escape, so it is filed here as a defensive sibling fix rather than as
a separate exploitable bug.  Folding it into the same series keeps
the wrap-class fixes together.

Use check_add_overflow() on both ends.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org # v4.8+
Reported-by: Tymbark7372 <tymbark7372@proton.me>
Signed-off-by: Tymbark7372 <tymbark7372@proton.me>
Assisted-by: Claude:claude-opus-4-7
---
 drivers/infiniband/sw/rxe/rxe_mw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe=
/rxe_mw.c
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -120,9 +120,14 @@
 =09=09=09return -EINVAL;
 =09=09}
 =09} else {
-=09=09if (unlikely((wqe->wr.wr.mw.addr < mr->ibmr.iova) ||
-=09=09=09     ((wqe->wr.wr.mw.addr + wqe->wr.wr.mw.length) >
-=09=09=09      (mr->ibmr.iova + mr->ibmr.length)))) {
+=09=09u64 mw_end, mr_end;
+
+=09=09if (unlikely(check_add_overflow(wqe->wr.wr.mw.addr,
+=09=09=09=09=09=09wqe->wr.wr.mw.length, &mw_end) ||
+=09=09=09     check_add_overflow(mr->ibmr.iova,
+=09=09=09=09=09=09mr->ibmr.length, &mr_end) ||
+=09=09=09     wqe->wr.wr.mw.addr < mr->ibmr.iova ||
+=09=09=09     mw_end > mr_end)) {
 =09=09=09rxe_dbg_mw(mw,
 =09=09=09=09"attempt to bind a VA MW outside of the MR\n");
 =09=09=09return -EINVAL;
--
2.43.0

