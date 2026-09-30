Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7BE371049
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 15:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781498; cv=pass; b=uvPWi0mMPCHkm8IXllTqrJIj4Qg3l7ArfXYfgEFtKV0S82Ho/mcng29HmTMNYIkcPjPkMoUoc3eBdLnbrB+qJVc5aB5r8mskr/XCQCrV5ZkOgTDnSwWPqGwByDdgkZa3uxdUyH2fmiM4+TXKB+d2lsWko4T3orBJyHwnCSVrvyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781498; c=relaxed/simple;
	bh=l3lJzv4trKS4l4b7nQaWIFAhJUX3fLolBMo01fSfUgo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dOvnkxNOkRosNOxc26JgE9/4cRjqNNmquTyW2RPDDN7F5XSoaR8ROLei6UEwycQPpO8MSeqsBd+p5HFiMDZce2ZggvhlhAUe7DyEXk+AnEaulCKRWV6dOg0gxuEGsyVrsm/Jihde+WK15UivwiezO9cfxBv7IE29NZXOdcVyigU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MYGVTbwr; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYGVTbwr"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5ba379d8804so1504413e87.3
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 08:18:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790781485; cv=none;
        d=google.com; s=arc-20260327;
        b=qtfGJImuWr3zDwlYRN7i/+LkTb/RmVLv84QBHCmIjz/M6sVHyBjmMA01CA53f1zlA5
         Xfhcqcx3SIoEAEYlUYXRvEQDjhrUcYoV/asT5HfPErosYrWuKm1819NM+gze0GKrphBG
         UfOZkDjvjfpp3URI57k5BNFON4IJnG4SBcE7Orw8txdqQ685MaCO8m6t+39WHY0IFhHM
         m3mW1YQV6g6y7dmerdzKWh2iZ9JmnXsFko4FXaj/+Jof3wA1wD48MY3YhUzYC7T6A8Vx
         TQ+GJAahVN3SJ4RUKZIpbI2Wzqp9ymXBBNzxXsJz9ivrdwqe+By1SSIxyTh2pi/Yw1EQ
         OMDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ZWuH3TxguFaVNqZlEAhjXdlUOQvlst4lWRTTOroWWRs=;
        fh=jOQ2dI0DLE+gA+fZGEGejm8TuKLDaC8w0DggHq4U5ds=;
        b=NwxrGp36w8wDxle1NRfc5kbIPnK8LVFPmGP1rSdz7cCfpWv6S/YhR6A1DiVoxGV/QZ
         TGAiOOlU2awp8/jVDbF+J001V9rLh43Wf3uAEPBKRUwzJAbSI9HzwmnVcHAKUIItfmuK
         9qyWAiZarJkECv+QN7ynTB5JyYg3ZlqeDMRI4mIaZ5gYIf8MiwzmGEIG2oiR3nLOaN+Q
         d/kOeczVAYrgunCRcOKV6ZoJ0mQzUlHunNAhb4m1CtNpa763K98XYzXpX0OZxdOmNnsH
         jfsIOsqxIXL2/KyF3lvLzZGA7RVgJdUwDqGfdhIfykpUZbb8Bt5eirwSMZvewbdBEmxN
         qWow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790781485; x=1791386285; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZWuH3TxguFaVNqZlEAhjXdlUOQvlst4lWRTTOroWWRs=;
        b=MYGVTbwrw/dKNxbsJZ98AMpJ5o9gm0BB/JAFmVG1hrdNFaWcROw2N9BcF1uRfqT+rE
         8DjDkYzF54xEUi1hCh5Kc/HO9ux3alt3f6scDUvUWp2y+pmFoi9U0PxUZtz0NRzVTfWI
         fAGyZZX9ty/8tST3PV56C7izRPbYV6BbRgmu1nfJ6QT1Oqb46kp7ic/X+N0Tp5rNGdK2
         FQiimwnm7q43gbwtITyBclxbCulSaVJYrsSKlDudBoIp15iQ+8oui25NkqEJ8rHrcQC5
         MtXSuO+K6gTGXhaiiH55MPzBXJAkgjH4qXYjN4FOmi9lpmZIwwaOCuIVV+78HTr4kRiL
         tm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781485; x=1791386285;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZWuH3TxguFaVNqZlEAhjXdlUOQvlst4lWRTTOroWWRs=;
        b=GNml3vSTq6gSA5NSJREUVn5Lhs6RJyckHvat48kNIEDwXnzpKbq9NhZvCRi+HprPA0
         vSO9VVjWavoMUtbkhogPngU//ZtYhppU4tHfVy27RSxY+JzyYjpIKtCt38lVur9m8PaJ
         cYw9JMx+V6UiBKn0b47PnBFHgwoJMIAbmeTItiTf5jX/PNX3mylX1kQNtNnkrUF8FEV+
         mkQZarY8GlC6Fef4U2JXbtV6cVFWwIhob6CrxQ0HqVf+p7axYKEA12nTQzwKLooBWN0y
         HSFav1bcKFQsBtc5eqYWH9U5aqQjZw+Pviz8rvljMgvYEVCZ9z8vXiR2bKEgfNyJmkDa
         ij3A==
X-Gm-Message-State: AFq9FYL8MZFTCkFkETmjGnSsvWtcxInD1bgBG39AI+7M5QT+C8vefx0m
	tQaX6pt2/8zuABA8WQ14MKuITSqg+O3aH3L6OG+e8O2U7Lj4qc6bPqWxXweRl47PEoUOsMVseMh
	JgNwcyZgfDoGeBBToTkBlDgKqp39hczc=
X-Gm-Gg: AYBFou2W2TTZNFoEjDULBe0og4U4NatkwXYzfWFkeFMIxk/n5jRpULeJmJdHTNXZ/15
	xPFKl8nVPwLGv7UQ2w1zWmXlxgw719CrUGktlicCI+IUDMpLHxatm2J9ec378p/nHwxGBt+xRL7
	6Wm0uER/AD7MDbJpTzUuo+hzexPf9WMm8PW69E2uVzAOTuBsZ2RGEBO7EPoGC6sPuhVw2936Q0x
	iBx3VE5jwS34bGKsNUzyEL83LVfb/M6pXzSSCkT61CEUAdy1ajxtdgXCPe/pfZ4tR/sxVu3mAj/
	m2jBiBl8Ffm0eNf1hmBOrwll1lD8vmz/WfembMw/Re/bieQKdTSzXLOT
X-Received: by 2002:a05:6512:3a87:b0:5b8:fa70:7418 with SMTP id
 2adb3069b0e04-5ba402cf771mr968776e87.1.1790781484577; Wed, 30 Sep 2026
 08:18:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: AYS <ays511.kr@gmail.com>
Date: Thu, 1 Oct 2026 00:17:52 +0900
X-Gm-Features: AclHuK85HKPOG6R-PI_0NTtNo8WXoiyWLI5p898iiILPgkds4nfQd4Zjg7uxgvs
Message-ID: <CAPAqSgZJ3cawEVs6O9+rJ1QD1RLrTo_rkZNnHsWdyApGSPThWQ@mail.gmail.com>
Subject: [PATCH] RDMA/rxe: validate inline sge_offset in finish_packet()
 before indexing inline_data[]
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

For a user QP, rxe_post_send() takes the qp->is_user branch and never runs
init_send_wqe(), so dma.length/resid/num_sge/cur_sge/sge_offset all come
straight from the mmap'd SQ ring. In the inline send path finish_packet()
uses sge_offset directly as an index:

u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
memcpy(payload_addr(pkt), tmp, payload);

inline_data is a flex array whose capacity is qp->sq.max_inline, but
sge_offset is a u32 from user space, so the source pointer is displaced
arbitrarily past the WQE and the memcpy reads out of bounds. Commit
126c757e4cd4 added num_sge/cur_sge checks on the send path but not sge_offset,
the third attacker-controlled index in the same struct.

Bound sge_offset (and the payload that follows it) by qp->sq.max_inline before
the copy.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on 7.3-rc4 as uid 1000: "BUG: unable to handle page fault ...
memcpy+0xc/0x30" from rxe_requester, 4/4. Present unchanged in mainline
551c722f4080 (2026-09-29) and rdma for-next. Compile-tested (KASAN+RDMA_RXE),
not runtime-tested. Found through manual review; per security-bugs.rst this is
public and a reproducer can be shared on request.

 drivers/infiniband/sw/rxe/rxe_req.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c
b/drivers/infiniband/sw/rxe/rxe_req.c
index 24f5c044363f..06e24d818075 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -510,7 +510,14 @@ static int finish_packet(struct rxe_qp *qp,
struct rxe_av *av,

  if (pkt->mask & RXE_WRITE_OR_SEND_MASK) {
  if (wqe->wr.send_flags & IB_SEND_INLINE) {
- u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
+ u8 *tmp;
+
+ if (unlikely(wqe->dma.sge_offset > (u32)qp->sq.max_inline ||
+     payload > (u32)qp->sq.max_inline -
+       wqe->dma.sge_offset))
+ return -EINVAL;
+
+ tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];

  memcpy(payload_addr(pkt), tmp, payload);

--
2.43.0
