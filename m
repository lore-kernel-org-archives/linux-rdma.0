Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com [74.125.230.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E042D4ED196
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 16:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787014; cv=pass; b=MJqYry57UFs1HdycZsO1QC/V5p1nvhfvgpClQ+GeljwxUTqauax9y9rdbmpyQ5kBjQXu+YgnqfP5ktirRf7voTmcQnLlFxYA8+AchEc43PHQX5tdXz/skU1vTdoKAKVB6/kl6SI3leNMkquwizPDcZd1yhoYAbKFEfEkvIke9IA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787014; c=relaxed/simple;
	bh=V0JyZtej3gPkeB4DiSnP1ukn319plI+NLzAJJp00MOk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=No2Ce1Q2elq/Q7g8lgITB6JcDJE+qG+bbIknbC3Tx5KJ8oleuinc53puXoLKvON1/sRJYFyteGTd2qLD+rrkRKwdcdPDKr54FNI5yKFjODMaRYC1edlvGsDSdlUU6iFCtmeN5Qo2DXof2lvUqNFQhGZBFYpqAR184NlJUDU3tf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nuHLJ3+l; arc=pass smtp.client-ip=74.125.230.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nuHLJ3+l"
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a779b23f05so6795671fa.1
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 09:50:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790787011; cv=none;
        d=google.com; s=arc-20260327;
        b=A1mdcv+eeKyk7/1zDBgk756gIii0lJvm4x0fKR7ql2CorWuXJAZIdcC8Jb74wnG0J7
         7NG7YF3AX2BXFd6ORCTL2zEmobAv38DTxSQHniOzTlEVB+qNcfLgO0B5IeWZudbrc79D
         Z/Jl7+0bPgTyuHzInCnrCqJB0J0/e9qf6xk+i2xhkBTDGpRm9ccnkHH1J/czFrmNJ/zM
         mWvglr230aNdZ2yz+jGaltWR9RiQhZb1Ywj7PSVvfSzXhN1LXDuCxYGMuAUxkmEktACt
         nGJxodZ1bfA+/trAmm9AFqzZH+OKX/JxJ5hdTD8oO1UBryvzQ+fHjM4r42JSM/cLLC5C
         upGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=0TE/EcEsZk4GPVnGo5rtnt9tNvICv6JXuCxkvZBx4OI=;
        fh=jOQ2dI0DLE+gA+fZGEGejm8TuKLDaC8w0DggHq4U5ds=;
        b=lCUSR+ZAjF+ZXQM39Z84Imf3mk+otM0vpTe75u2DPo92/6w9kbmm3/FpcXP9ezk4Ea
         IXY7QCLtrfv5xoDEzz2NeLuAYnpeg7OCtsoWBZGxlrGVyu+uKG4/+3rhbVBSfpLPVVRw
         gTVwqLfE/0aHdfZhak69I8lXehFdYiDL1O+ZdKdK17LMy022dPX8qLbfEB9+cCP45Q+i
         HRrqHyOlMYirf53iBiHSmm8EcdfD7TjigJkgiLU0J8irSMykwHuLPfgC07834EnjqJhG
         hJL8qATjDkjYpJGJ8iUZivqM6Ka6fLyKc2l2BPrgJngz6sqaShlCioFaOA6PHC0P4QJ9
         SVMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790787011; x=1791391811; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0TE/EcEsZk4GPVnGo5rtnt9tNvICv6JXuCxkvZBx4OI=;
        b=nuHLJ3+lV4c89sqxKqHNH8fBTkgfjWh49MYRIp3kVeBCkgt5a2OPL6Nqejg41d+j07
         /7tj0HSyZTqa7SOkJEtSoXHnGdf/HNYXB/LU6M4i79xiGXUR0L0SBIfGQsNW5U2XNLxD
         ged2z+ImGwyppI78JUQxyh6SxFfzdGPb0/Q9YbDiOzxXB7qs7Pl9wTGKD0mX5EfjDZey
         q4ntq2p35IMwK6ZLDjeVUyXhcKQ+1hD8fVeu+wGksYUhkVa9Y/6xvKxraLrRXG4yQEKu
         BYjh19TC+fXpDH3K6+Y8Bfnutxub1uxLUm8m5WHIf+ITHQJLWLiee87GPOL4/ByZETNM
         UuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790787011; x=1791391811;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0TE/EcEsZk4GPVnGo5rtnt9tNvICv6JXuCxkvZBx4OI=;
        b=Bksdd0C5LXYdYxUbQU8+Hd7CVLxgqWgSb05FcgJjqDR5kl5wW5YGmcFceOWzYXg9DW
         jYH0Blyr7O3HYn5J4ssrSTjvNyGvGmfpMc2fp0/PnK4iMwOmMQlidCwhnQ7Rf9rVXAXH
         yhiHnixtc1duE4P+YNIS5fhqfYXt2+TgAO0ViPURd5oICHljiT7uRv5SnPQrfGR7AESA
         LWt5YtL3VaslRRc25aa9plpk5bLsQtM9R8MNkXLzgLA5j5fd+vM13F+H7uMKbVGl1xSA
         I0HVxYmi5zvzjB88HdBt5FFZv1wZZD+zpaqnlljUie/qk/6cH9hmSQSSru2wShbVhGmD
         EiIg==
X-Gm-Message-State: AFq9FYIo2i5Gssp+zZdeDUtxexTHJJn/c5EpHZ/8qEWwSZ0YxIqIVtsN
	46xcNE64x/czl4vea6z7w1bk4Td/YJ2/K9OH+Ge0PBREzZAFwmxRCJIspd/syVhHCmEHhq+O4U1
	GFJGrG7a6g2SRj4RubHJjhLoIwXQI1/OsU78d
X-Gm-Gg: AYBFou3x10pKsnzY4Uqi0VqydHVjiNXpwAzOYAdiqNwoRO/xnpJpNs1xDGHi67fjRc0
	5IlkR41HTwY1tNj9b6RxZ3qBk4OUtwmOXNMNCtf0lZ35vLIKCwmlcE9xaKju8Pq0LbArvgSiHo0
	IQRLrzyFrkhqreZnBYFfJezxfd+ApkuylyLWnwGxkc2/o9O7cCyMfLucNk15d04ApvB5B4jGspR
	dLr2UpaXqZrozj95zwqueEFasi51cGZGQvQDMiVT2GtE3MIgK7+Zeb2zW48V24Qf9peL/5fF9cq
	t26/mv2sk7k4QB17sO6ztFBg33c4anZ/z/cCsKXb0/PT4zVBQ0r7OEDE
X-Received: by 2002:a05:651c:a101:10b0:3a6:6f81:1017 with SMTP id
 38308e7fff4ca-3a7791cd4f6mr5423031fa.17.1790787010523; Wed, 30 Sep 2026
 09:50:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: AYS <ays511.kr@gmail.com>
Date: Thu, 1 Oct 2026 01:49:52 +0900
X-Gm-Features: AclHuK_VXh0irqC1mA759iG15h7GY_YAAZcT30DXjii943ZTqUBNoCTN-Qyx_qA
Message-ID: <CAPAqSgZhfWXwrYh=OT8xta+mY00Fc-xhkc5HdP=qVvxUABnWnA@mail.gmail.com>
Subject: RDMA/rxe: use-after-free of rxe_qp when destroy_qp proceeds with a
 bound type-2 MW still holding a QP reference
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

Summary
  Component : drivers/infiniband/sw/rxe (Soft-RoCE)
  File/func : rxe_mw.c rxe_do_bind_mw() (takes the ref) and rxe_mw_cleanup()
              (uses it); rxe_qp.c rxe_qp_chk_destroy() (missing guard);
              rxe_pool.c __rxe_cleanup() (timeout path)
  Affected  : present in 7.3-rc4 (93f51579e7df). No commit touched
              drivers/infiniband/sw/rxe/ between 93f51579e7df and current
              master 551c722f4080 (2026-09-29) or rdma for-next, so
both are affected.
              (Distinct from ae36a5b6, which fixed a PD UAF on the rereg_mr
              path; this is a QP UAF on the destroy_qp path.)
  Config    : CONFIG_RDMA_RXE, CONFIG_INFINIBAND_USER_ACCESS
  Trigger   : local process able to open the rxe uverbs char device. One-time
              root setup; the trigger itself ran as uid 1000. IB_WR_BIND_MW is
              a local op, so no network/peer is needed.
  Primitive : use-after-free WRITE on a freed struct rxe_qp (kmalloc-2k): a 4B
              refcount_dec_and_test at offset 368, plus complete()/list work
              when it reaches zero.
  Found via : manual review. A reproducer exists and can be provided
              privately on request.

Details

A type-2 MW bind takes a reference on the QP:

/* rxe_mw.c rxe_do_bind_mw() */
if (mw->ibmw.type == IB_MW_TYPE_2) {
rxe_get(qp);
mw->qp = qp;
}

That reference is dropped only on IB_WR_LOCAL_INV (rxe_do_invalidate_mw()) or
when the MW itself is destroyed (rxe_mw_cleanup()). But destroy_qp does not
account for it: rxe_qp_chk_destroy() only refuses when qp->mcg_num != 0; it
does not check for bound type-2 MWs. So a QP with a live MW reference can be
torn down. __rxe_cleanup() then hits its -ETIMEDOUT path (the refcount has not
reached zero) and proceeds to free the QP anyway. Later, when the MW is
invalidated or deallocated, rxe_mw_cleanup() does rxe_put(mw->qp) on the freed
rxe_qp -- a refcount_dec_and_test write into freed memory, followed by
complete()/list manipulation if it hits zero.

Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000: KASAN
slab-use-after-free write via rxe_mw_cleanup -> __rxe_put on the freed
struct rxe_qp. Deterministic (not a race): bind a type-2 MW to an RTS QP,
destroy the QP, then deallocate the MW.

Suggested fix

Make rxe_qp_chk_destroy() refuse (or defer) destruction while the QP still has
bound type-2 MWs, analogous to the existing qp->mcg_num guard -- e.g. track a
bound-MW count on the QP and fail destroy_qp with -EBUSY, or drop the MW's QP
reference before the QP is freed.

I have not built/tested a patch; the Fixes: commit should be identified when
preparing one (introduced with type-2 MW support). A checkpatch-clean patch
can follow on request.

Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
