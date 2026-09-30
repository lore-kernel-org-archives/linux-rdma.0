Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B553C8728
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 15:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781348; cv=pass; b=lFdhCBw14nwjMKMb3TczTOJ5zqZdg7ea2VlhuNxe6DB7l1++dlrbbNS5qAtoOzgWEqjuciv+RpOGeEBlmW7PDO/kJ0NbOnHH51hV0UQlcLgOolI5OOqCIl1WfEGVsBqxftNm6HVF6ILCJ9VXa40EltQh371QKV4iWpvoIwQjnCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781348; c=relaxed/simple;
	bh=ZM7M172GUV3qPiEpYGd1WvONBH/r9/VqfybhIoiXQVY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FA5W470AGu+IT9yA+ofG4bPsqlbdaxuw9DipGTjCN1YZdT51midfR+6t4r3XH45pCFTbKuZpIZ4Ft8Wb2K6PPEkrEhNOa7JMkn3HchLGyjcO8Lf5u+nfTDlPaZ6N86/ByFvjiGaAujEZuAzIicdw3EVuJcilBA/fS/dJQr7zKvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXEOj9nL; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXEOj9nL"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8cbb7b9cfso4408008e87.0
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 08:15:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790781331; cv=none;
        d=google.com; s=arc-20260327;
        b=KHDEaxu4nNSNDTp9p0zDlRVGmkdFZxPO8TaZCkfcN14q/BmyothPNFy3UAeqehHHPw
         pZpUNlDObAj34oXpE1jhD6p36Na7YpwJoWX7K2Ykp6B0Sm1dibo/+AuF1FFomPxkbZJY
         mjdmVNSd3Vw30y4/SGK6pHlwf5Y6dJkB8qfBwSK/M1nRy4Mbzc4obUwJeKIi0jxTg7VL
         /I+UELrCCoqi0PX3nYNhdEQeOr/IvngkKjvge3wwBXzizeaFkvvteuvM8W1H1HxrnbXg
         a0t6OaW665Dmf90Vu6P6owByxDbtbawqsbfl9ADtO5fPsL81FCd9LfqJqLc+RpY3T0/K
         H1hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=6Jad+q14PIE2tAAsLOeNX5L1DBdDYi4r4XE4ZjJIGlc=;
        fh=jOQ2dI0DLE+gA+fZGEGejm8TuKLDaC8w0DggHq4U5ds=;
        b=UYFACl1JqDOdg2KQcNf2+m/Aj+yF4G6IBH41ZClbv+H6JN5chJ/EQggJdXzKGP5S6T
         9kAUG758XNL++9Q9UD04vBgwB0cpH3/rfjAvI1RZBQXAG9uWnnydlh1RldBCpTPS+qvg
         6nO4CJxdRe+FuIEV3wjV+896VhpQKtxYNryvnHxnB/DE7AzoKAzy/N4MlhUrVIpxVjZ9
         +lYAY7Yom8wJzxSbR2rGjTp4YAltbqBnW5+2crAid2WSHJwDgdy/il7g6qYELLUpFHy8
         MtnzuPYufeGB1wAq3uZtexOPQ+0HKW8plEklKa5Q7j3L9LeolcTx4gYRCiWvc0Qenl1w
         51Hg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790781331; x=1791386131; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Jad+q14PIE2tAAsLOeNX5L1DBdDYi4r4XE4ZjJIGlc=;
        b=EXEOj9nLTwFD/5q6R8cM9N5TV4G6O5rCBXrs0nxUomQhK1mJh17a6WdP/mdcY9dxgT
         uv3Bj6R409kySdl9Tjcsj2BJx2wcnHTyGJXM884PaGdZ20Od7CW1oJPnHaSRFzFsIfP+
         v5aGyQPqI217O0B1VLYauPzaqo4Ck860Mb+LINHfiXDFzrOHhW82xOqV/S0h5ARSOKjx
         jQbNWz31IgNg29j19WlZmDaCAHcDwcD9AVAZgCLXPV23Ruuo/NfyY22wOq971cH5J0u9
         gb0Ix5r6H0fMhUO7OfukqGPHIikCLvlOoZw2N2dUfsyr6NKcL7VPX0nbpzhPZ3DK3j/C
         FG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781331; x=1791386131;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6Jad+q14PIE2tAAsLOeNX5L1DBdDYi4r4XE4ZjJIGlc=;
        b=Q0gxR0SQLBWzqlC/+KthOOAYcbiUIVJgi7pKJ6sfqs415pAzyKatolke3/gCC0wBTF
         qqOrBstTK3NZ+C6jV6aDlvR1bsJg1NiGGbXx+TEH+04yjTRXUoK+sSEvcdX8LQphH5+T
         XdCvVTgKkwAa4hdgIBqQXDcyJfoMn/I3vqndiL/YveRLh31XqfL/aIwyPklJd2jTQ0lx
         eT3fmfN+S2kNzO27ap/QXjmLsweUqkgCpKxo2E+b+JiYn56lnTM9oqXPEiBjP2nU8WHh
         iOJsL9xGJdi7T8UbsFxqyp8TqTmNPlAfOXdrjg2qNk8+ClQL6NS3aWGE5tjR2fZjoVrK
         RYAg==
X-Gm-Message-State: AFq9FYIHMMwU4xrQBfOwtg8kCBLPVs9Su00imSrX/UBtO6Dzoui/seiF
	+rQ8lRwSBmcXpTM/AWYtoA5RM9h/FgEHWC0vQMy7FOnDsv34/UducKQ1KfLX3pPi1T003+XE/Z+
	wMbeJbsx7+A/tv9GP/qOX2L5IqGfbIVA=
X-Gm-Gg: AYBFou0E20tXJm4oQiRya9HGzXLBd2o0mETebkEFs3pgYBexiqktJGj+OUp0iAa6Fxx
	jawxyqlI9vbWLXeEpUqa2YN6iVVGnLynxsEBF1FXiqWsOOIhD+pbKJjP6WU18X0r45zPlbKpMpc
	eNejuPOSN3IBuaXoXJwpbx831VUG1dD/eLJsXMUiWDUWhzqwsKrZUVRJuITAqRMkp4pe2LkSDdX
	xDtMSSHwe8J/dCPv98zyU13etUNkwFGI2wF+iAj96jFGGDiC5IjoBtqwpM95kH/6IbcVRNHisQT
	l3dU6bTeKz2ttb41UQjsdKBnq1veqH75Z9LXUYBD8MASC6Qn/ksa0+pd
X-Received: by 2002:ac2:4a6f:0:b0:5ba:37c1:645c with SMTP id
 2adb3069b0e04-5ba405e2b68mr510026e87.40.1790781330169; Wed, 30 Sep 2026
 08:15:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: AYS <ays511.kr@gmail.com>
Date: Thu, 1 Oct 2026 00:15:18 +0900
X-Gm-Features: AclHuK93HwgRTm7vbt5f2JlCpQQyHtULj7YnMF35ku2yac2U5ybL4GpmL5LnSzc
Message-ID: <CAPAqSgYP5tNonJb4VRLBt_34R8rcdc-gTB_jjmT221FqW18hmQ@mail.gmail.com>
Subject: [PATCH] RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

An ODP MR's page array map.pfn_list[] is sized from the umem's start, but
rxe_check_pagefault() indexes it with an iova taken relative to that start
while the access was range-checked against the MR's iova (ibmr.iova). reg_mr
only requires start and hca_va to share a page offset, so a user can register
with hca_va = start + N*PAGE, and the index skew (hca_va - start) >>
PAGE_SHIFT then lands out of bounds of pfn_list[], which is read with no bound
check. An unprivileged local user reaches this with a single RDMA operation on
a self-connected rxe QP: observed as a KASAN slab-out-of-bounds read and, when
the out-of-bounds qword looks like a writable HMM pfn, a write into an
attacker-influenced page.

Reject an index that leaves the umem and force the fault path, which fails the
out-of-range access via the umem range check in
ib_umem_odp_map_dma_and_lock(). The downstream pfn_list[] users
(__rxe_odp_mr_copy() and the atomic helpers) run only after a successful map,
so this check protects them as well.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000; the data-only write
primitive was used to reach uid 0 on a fully hardened build.
drivers/infiniband/sw/rxe/ is unchanged between 7.3-rc4 (93f51579e7df) and
mainline 551c722f4080 (2026-09-29) and rdma for-next, so both are affected.
Compile-tested (KASAN+RDMA_RXE), not runtime-tested. Found through AI-assisted
review; per Documentation/process/security-bugs.rst this is public and a
reproducer can be shared on request. A maintainer may prefer to also index
relative to ibmr.iova (as the non-ODP rxe_mr_iova_to_index() does) so
legitimately skewed MRs keep working; this patch takes the minimal, safe route.

 drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c
b/drivers/infiniband/sw/rxe/rxe_odp.c
index ab21b620e94c..07a30c60fc62 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -136,6 +136,11 @@ static inline bool rxe_check_pagefault(struct
ib_umem_odp *umem_odp, u64 iova,
  while (addr < iova + length) {
  idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;

+ if (idx >= ib_umem_odp_num_pages(umem_odp)) {
+ need_fault = true;
+ break;
+ }
+
  if ((umem_odp->map.pfn_list[idx] & access) != access) {
  need_fault = true;
  break;
--
2.43.0
