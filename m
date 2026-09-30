Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D78A511E96
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778699; cv=pass; b=HfPnxOfyd4jO2RFLLmULYTbs7BjRpYlsxPg3xf/QQw7FF4PsgWfMPcJHzb/vdhInii6YnJUeG02s9iWcvQnkXunPzn8i2p9vNjdGtcXgKzBY8ngwuSOIPaOWPfA47HuuAuU/GpyZMhX0VK5ixCw7RHhDLLLuuGzM8T7AZ/Xqdqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778699; c=relaxed/simple;
	bh=fP3a1b7ry28/YEDUURVuTU1hy1MHNjgbZ8hcZPw/a5s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=czeflRoaq7jvJiKX7SWCdH7Pwac4XmCW6wsZAD70VUtO1OQOJqmPJe+6bCw6B27ILFxI7P+52Ib/wqwuE0soXP+XtAqyt4oatdvSJ7yMxuUoEbb6qqxcqXRxK2nRbpoAdAR7NMhBlmWhA7nFZp8tEdAE5ge3qHwV/lj3GSK/1yI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gy9HWWD1; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gy9HWWD1"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5ba3ce4795aso1164410e87.3
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 07:31:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790778680; cv=none;
        d=google.com; s=arc-20260327;
        b=BHJhO8L6pdQdihTqi7Wmm10FGLrwLGykdu8IOxKR0G1ARExOXojkO2Bx0Rt0Z7rBmI
         Zogl3pzJAj1sHfKO5fDMAwwb0WN54lw3X/KmqgwMj8EyaMtXi+mrssaH8DAb9fvxbbfv
         rAy0uU4ARSYRLIUw2nkdmFkGA4kzv6VJVcfrqKb01x+quIvBO2NEf2p+mP3Gibd3VOcn
         mTMr0F2maTqDhnbgCW+cE0A99dXZ4tFYqSOHoLQwh+Eqv5BMr+xVvCcNadtzEd/bUXh+
         9lqPwz/S6StEgoxjn/7FkHshDhx3xIA9GmtO4iE7sbVVRVHtUCC2i7lcD6n/0EWo5XIQ
         8HZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=qhsmnUGKqO+ajt7yu4pkJe883hej8X82SaCmNbsfnqM=;
        fh=jOQ2dI0DLE+gA+fZGEGejm8TuKLDaC8w0DggHq4U5ds=;
        b=Z9vXOPbvRtL6jqWpq/F9RtsQX0I9xbx47wFGG2r4S0WJpWKGNm+bZ1Ubu8pKgbrdFP
         g63CzX9FPUaDrc8bbN32ZPQ5D1eL/LbmDOBzB8nxZurIzrksUII6d9lIi9fjAGc0ZMur
         eMJyDTvzXi97O0laiYFYrX+8oTV3SFXu7NKofP+B1Hpde9IrrQ6M8AH6LTNz7cEPdQVd
         Ffd3wf23hdb+c/QzmA7oMjNH5N4Z/rhTLYaqlRA8A6wzJqezspPWMdlOMKqj2UtGpVMK
         OTeShB6IFBsdduL41yyn4+ATapEe75FNMdrZQDb5on16TeNSLu8srZ14wJK2PpV2mZdz
         T7Fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790778680; x=1791383480; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qhsmnUGKqO+ajt7yu4pkJe883hej8X82SaCmNbsfnqM=;
        b=gy9HWWD1iy+ryXwG0mqhSRv54cPV58vYBYas0vZex0PXsb8uR5c/Po3b/o6IVukJ4/
         7hthr40zGQOWMmhj4KrgWpHnKYzVnGBNqw8R8UJeUj2u9qc/WJhcYT7BzHznZAaklREZ
         OrgeiK3rxDsPhDebMLNFz5EUf/Ue0cCUQNKkAMa6QNTzucQj9IaWUg6RT2ajrWvL2fSd
         Y9cYq3sPCHNuZ0E1vTohNaljIb4IlXW33FWuz2k2eFLlhQFr+wYgm81+ewA/5KnJaNv7
         ljOzCDB02Al67wKSXLRe9geTDMBttfNKexI6QqpbZIyMaJMMtaASTyi4uRQYP9KkmDXj
         ZiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790778680; x=1791383480;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qhsmnUGKqO+ajt7yu4pkJe883hej8X82SaCmNbsfnqM=;
        b=O3dnYOOymnqQzsc4e5N/axhE+fnNGxIoElIuYk8wP+yy2fGpx1YXIC0ou7JhSDQHwb
         WOGsePwEPtHXc2ZThC/NUWGBhQHC+eBNMZhewK7au/7+3/xC/WtD6lP4SWnX2U930Nbs
         OErBYGb6727Uy4a8w6uiudiLFZCc5q0fyFQPevYSlIzJg2xFhwS38rhwwtBmdLCC6Q77
         eKHvhTVZZerHhtIu5/NeFmv+N2pY78az7mUrnR9FVw1DOKWpQr4rtvT8NsCWwXf1Hnco
         4sGXk75QHyjgDbLdY8e+e/DL7xDJXHGvKyFXirnbxDqmk904oL4TvQoCisRZGnYLpLAT
         TKCA==
X-Gm-Message-State: AFq9FYLG9/C9TtkSGXB3N7qRGbNZ8+WkCcZ+q7vleMYz9jYAivwRCpqc
	I6nHHonPU9csILdGNeUlUs61wN4LhsCRxKqH2urQUk0nymIv/u8hAxTiPqKTkY6DqZ7t5IQ4gVA
	5x0TlOLAUPE1PYig9jZRC9i1UbPsRTMa7lBdr
X-Gm-Gg: AYBFou3w74Bxrxcz3UrzXUPJeBGMQQoFcgXh+8PtezdgupVBgRREPuvotCqDlBjVtZ7
	X2nhhLjEuDwWjquvZHMPtGXMp9UpXFJkRV36e+r3vmusXS7zXBtiEvCP36ItHK1yUqTiGJLj7Hb
	Cb9K/GY392BMucLLK+CyDvTgCmWpwpVPeOKJM5GKLeuutl1po2QzE3bGBKhMXeamfdMpW99HxpI
	uRI1Y5roi064YWIbUaVEpkJvuh3t7VVuBwo9NSJ2Q5ZNJP06ncDhoR8BDtPh0D/8mH/bIOIcG4T
	IkogCcGIiW3r8Pqfp0MUudTjPf8kvJkcITOLELpHAbxUjNDxiPGBk1wZ
X-Received: by 2002:ac2:456f:0:b0:5ba:3ec6:bba1 with SMTP id
 2adb3069b0e04-5ba405ebcefmr469918e87.54.1790778680221; Wed, 30 Sep 2026
 07:31:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: AYS <ays511.kr@gmail.com>
Date: Wed, 30 Sep 2026 23:31:08 +0900
X-Gm-Features: AclHuK_3ajSHDpJN92nRnBLUwYGfUeq1QCQtBLkWR6yQCxRP1TJ5ku3tgkceTtg
Message-ID: <CAPAqSgY_3HQwokvRpErRfZvT32CJODXSsd0=TE985exOkZ2WHA@mail.gmail.com>
Subject: [PATCH] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with a
caller-supplied opcode and no bounds check. For a user QP the WQE comes from
an mmap'd SQ ring, so wqe->wr.opcode is an attacker-controlled __u32 read back
by the requester (req_next_wqe() -> rxe_requester()); rxe_post_send() takes
the qp->is_user branch and never runs validate_send_wr(), whose only opcode
check is itself !wr_opcode_mask() (it indexes before it checks).
rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR, so an out-of-range
opcode reads out of bounds and the result is used as a mask and dereferenced;
observed as a KASAN global-out-of-bounds "Read of size 4" and a wild-pointer
oops.

Return a zero mask for an out-of-range opcode, matching how validate_send_wr()
already treats a zero mask (an invalid WR), so no path indexes the array out
of bounds.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000. Present unchanged
in mainline 551c722f4080 (2026-09-29) and rdma for-next. Compile-tested
(KASAN+RDMA_RXE), not runtime-tested. Found through manual review; per
security-bugs.rst this is public and a reproducer can be shared on request.
IB_WR_REG_MR is the highest index the array initializes; an
ARRAY_SIZE(rxe_wr_opcode_info) bound would be equivalent but the array is
extern to this header.

 drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h
b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf80fd..dcc0788db90a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -184,6 +184,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct
sk_buff *skb);

 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+ if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+ return 0;
+
  return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }

--
2.43.0
