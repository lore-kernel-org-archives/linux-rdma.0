Received: from mail-lr2-f34.google.com (mail-lr2-f34.google.com [74.125.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F534F30CE
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 14:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778726; cv=pass; b=tuRi2dBH8LPEEjS+YzU61RYEHG5SISAjkpUrd5SxVfuUQuPjAk2KC8EY5oknClNnbv0dF3APUTolCF9bm++rXGdsReEZo/sA2OaL5j2FfarpYYfPbZA0W0eHsYujnw+Zm0z7LeJbyZEDUnxLqB6ax/tfWfLhg3TRco7+Q6ZBq6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778726; c=relaxed/simple;
	bh=OnbFzM+daFhASulCXI6UkTY2Wfdk/BwAyqNI35vLWj0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=fs7jRstVjp7OVrPkQQb/jr00Pgoyj9J4M9T8OwuphsCryDqwLi2cl5elW1Iu3SmFgLXTxNjXlYw9x+utMMKxkhC8r8w8YtgaZbzrUF2k1le1RjEKzVLPeuKSJfFQuAjnC9rdR6fMienY/GkJZcV1biyPC7lT1Lv+ABz2vRUqSeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwA1iN0K; arc=pass smtp.client-ip=74.125.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwA1iN0K"
Received: by mail-lr2-f34.google.com with SMTP id 38308e7fff4ca-3a652e2149aso47445331fa.2
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 07:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790778715; cv=none;
        d=google.com; s=arc-20260327;
        b=DF3jDmTjOPXwZMwfJHYXcYlWuFKrz8lhtDqRg3k60JkwN8UtIXZR36CuIIbjOk914S
         VtGIh2/+IlTjyPB0LpiqWC4nRqE1cUIZSdzY1OLEu7wAZ2kdtSPyMqndk6Erg4wqkOFP
         m+83saRqVqMMUoYD8ew3kqjkYi4jHlR0EuYZ6+A3GUa9zK8yioX8zCl9v7TzSPbeC0lA
         /7QWlU/f50ZOOHKp2W9USwM3kulTqyWxwnfjGOFOJZqIUArjSpbrFVJbtiMfyVcyJr1y
         WoUNs+Ds5Te80jf8WirCXfd5SWV5FoDeGQIVXc1AhD72D7S62rPXrPeLG5HZ9hLcNtsz
         f/7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=bWQE/++X8AF+4NiOfiYnEM+x+SbXxH+AHMFqDxXmnws=;
        fh=jOQ2dI0DLE+gA+fZGEGejm8TuKLDaC8w0DggHq4U5ds=;
        b=HfQTy1ZXmgQPuzCy5ggJe0PzASiA0QmUfry3F1gbGwgaDuv2HnvD0R2vUOcct4BNZ1
         uqOypIrv1bq/PHXesOToyRqpv4jsRN8hrJbODikHpjAeDB8Fwbb3ISGGNyasBVoaJNoI
         ZicxxFwAdMuQ5Pm3BzcucTwD/hWilGfODO+CF4qV3d4MRPSgEQ5QENkEJznF+lz5NbZM
         nZwBHU7N3c4qKzkG13/HFjRPH906a47FHRJliG95IztxGz7hWGogM0Vjps5Wh+sKwoSl
         oXJGYzXWXKlO4H+Xt67x0HUMGXilvJgg/PvbUtS98+Rzys56CzwqGgExaF34luppNOhT
         TatA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790778715; x=1791383515; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bWQE/++X8AF+4NiOfiYnEM+x+SbXxH+AHMFqDxXmnws=;
        b=lwA1iN0KnYajtlOfPZWqHmjtadCEAbbmRpQYglvqGMKu6eZDSUWjPBc3LWYCxeB2Aa
         /XXOBKBU6zJY2A9GPkCxT3V3qBk5cJre+0fnppoja25l1BZttxhhB71DGeGrOs22rOaK
         WysSCPo70z/hBVQpVWsLnlZmh+cH6kAV7mADykBMrb8KCtmudttg4P/DEQD0p0X8MMc3
         gdM7CAt9pXXpIaGApKjSqJHlcUyEiRs6U83eEG1Og1S67g36mWjCGH5cxSXE2WC6Ko9z
         camsRGD+/cXUED438eMDW0M1NS+YOPlLJly8VLe23maNHrmxfU0AAIA7/U+vzzk/2fGh
         X8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790778715; x=1791383515;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bWQE/++X8AF+4NiOfiYnEM+x+SbXxH+AHMFqDxXmnws=;
        b=FRGY9atCCXG0ryyg3JUQwvH5UiLVneEbIQ2dhhWS+SEyYmyQEMq57traWZAvmeJxaa
         HfcvDTmXIT0kVOiZAD7jvrfYEQqT72KBTEyQrS8WrhgLnR2oFZoyZj6m9PtN+lzNxIO5
         JZfC3erjMW/HAnAqvYUqGC0dOo0bnmVJ/a0+/14LC7fLBOryuKcP5nkQXmCOfwNKC+br
         Giz9DOj2k3pDbOQUJlLlXi1gZSfd8UhqmyRPXzdl9RMaPs/5kkFzqRxgRYcwnsD9J9RZ
         Ad0E34SL46GaseKu5O8gDtO/zpv5zgP8Znikw1AjiOq37CX0BCxnsGhXZDhfNCnKBCpe
         cNrA==
X-Gm-Message-State: AFq9FYL2+FM8VO5nTrvqVw9Fl3gIhY44t/RNR2w5koYYA7UkCOlb03g/
	50dW4U86LyRL/r1h/Evu+JcGPJi3Vj5qgO3PXs8ZhVKVB8EN/wxmJk/g0BBXTQ765O2JzOQm+QD
	zRRWJ0URhj4MzCDdPCQwcwglmdjRQT6E=
X-Gm-Gg: AYBFou0qynIR2w6kRP/w1l5NH5SEPltBp4OXlm5weUVbpgxGeEEMOsV+TgwLWwPzLup
	l2FvSeavU9GV681B4ZzghwYf9AYL6OxeyyzAZPGyhH2oENHRzlXOeutM3nqkWDNAOcsa2lXIX9T
	S1BEc/mvQawnkuUAoWjOoZpDZ7ZkCGjkvdVojqF9p/mJ4t2sKSQV6GM0+3aGVOUOzSmmESg76fV
	2a0UYTngR0iMuZSRJIWYZOI4dBljyV/8KOF7xWKu8f9hDaKs0dJzDuIvw89zIhBD4TnIKsBYX2Z
	6Tq+pCuqRnqPZd5ozIcCEjjVDRCmbHW+UyPCb3MAsR28ND4rWt4tMX88akwpQCweduo=
X-Received: by 2002:a05:651c:198e:b0:3a3:314d:1169 with SMTP id
 38308e7fff4ca-3a7790a6ca8mr6571201fa.1.1790778714630; Wed, 30 Sep 2026
 07:31:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: AYS <ays511.kr@gmail.com>
Date: Wed, 30 Sep 2026 23:31:42 +0900
X-Gm-Features: AclHuK9BGPJIcW2jKSC2yp5AJGGdZXfpxLyhBw78_HoyMnwU0TKbDzBB1cDLw9E
Message-ID: <CAPAqSgbUp3Fg_TW-=9VrbEyy8-crJF4tQ80AcehHdJoqDAZkLQ@mail.gmail.com>
Subject: [PATCH] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

IB_WR_REG_MR is documented as kernel-only ("can not be issued by userspace"),
but nothing enforces it. rxe_wr_opcode_info[IB_WR_REG_MR] sets
WR_LOCAL_OP_MASK for IB_QPT_RC, a QP type userspace can create, so a user QP
that writes opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts the
ring-supplied fields:

struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
...
if (unlikely(mr->state != RXE_MR_STATE_FREE))    /* deref */
...
mr->access = access;                             /* write */

For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer, so this is
an arbitrary-kernel-address dereference (arbitrary read confirmed, oops). No
existing check distinguishes a user QP on this path.

Reject IB_WR_REG_MR for user QPs before dereferencing the supplied pointer.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on 7.3-rc4 as uid 1000 (arbitrary-address read dereference / oops).
Present unchanged in mainline 551c722f4080 (2026-09-29) and rdma for-next;
note that commit 2dac7006b9fb ("RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes
after MR creation") recently touched this function for the ACCESS_ON_DEMAND
flag but left the pointer dereference in place. Compile-tested (KASAN+RDMA_RXE),
not runtime-tested. Found through manual review; per security-bugs.rst this is
public and a reproducer can be shared on request. The Fixes: tag should be
refined to the commit that added rxe_reg_fast_mr() when preparing for merge.

 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c
b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea477289..3a914c243829 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -777,6 +777,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct
rxe_send_wqe *wqe)
  u32 key = wqe->wr.wr.reg.key;
  u32 access = wqe->wr.wr.reg.access;

+ /* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+ if (qp->is_user)
+ return -EOPNOTSUPP;
+
  /* user can only register MR in free state */
  if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
  rxe_dbg_mr(mr, "mr->lkey = 0x%x not free\n", mr->lkey);
--
2.43.0
