Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB60368D79
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790780379; cv=pass; b=mONUPr9C2eO4EBV8CgjCPKxeuFz2LyGcjwbNErzbtv1lALYnnofqlWE9nuzOjEOVFc88FRyq2F12haXUPy5cLeV03VkefSAm9s7StFcM1Zn+HVgKnn5zryk6fjmpKcfNz78iTC8XLa1co4d0SDOunB43pMIIKC13cAE7Ex0P4ZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790780379; c=relaxed/simple;
	bh=5giBaVl5BSchDPtW83YIhtL7rssEOn/F7Q9Xl1RK+iM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=BsYiuxQJIJAvXskD1riFhFwbaD/sQAmVHx3ZPcgIo4N1IasMB245IMwuMmF0EqVTZvcbuKp92GGMrWpUT+4LRrusGBdDjCHrJPcxa9/TZhPvyUxLJ+73nnctqIwaqpQ/7j65NpzOBSMwj1ATlWu9JUeONMWer7RC7suOq8+Hc8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RS0e3rQp; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RS0e3rQp"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5ba330a7e46so1636401e87.0
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 07:59:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790780367; cv=none;
        d=google.com; s=arc-20260327;
        b=H/E1Lp6ek8QoOeMfLSW72EblCmQNc7FHQpKeJvf18b5W0DDRlHFxSlBANfxSgxEiPh
         ysaolk5xOCsvyDdD2Omi7euypDoFiS1rhmZwj5evYhRi/xVKF6usGfbxMzIxd4oToIJ3
         qfeBwU17tIhWCXo2OBHkNP6B22mt919RGdpBixfkXd/EzACoLPoBZr11jlV58UaXlG2W
         3HiUkO24DUEaW1W2K6ZRORIQydIcEYhjj0ntre6hPd9LzIJZ4qOaBRqZxLFlWoguuqDO
         FGYnfHmSayXYlf95uKJWc7BDBMIHDrs/T1MefX7NVYSMjnWAnKRBJKI/ahD+d9YIeB9n
         9FGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=iiDt0g5/VIiAkRdXaI6xqNpm0iErNwKvhkLEROP3Mz0=;
        fh=jOQ2dI0DLE+gA+fZGEGejm8TuKLDaC8w0DggHq4U5ds=;
        b=oBlOWJhcmz6SMwRWCEjql9rUk15/B+O7h4JdrTEelR1F20cBAL3Ssj5E6YRlRNWDhi
         xsba13ROEAe7AUbhoKaNFM1bSYTfceCIgpq+AwUmZwjjHpidROhfY7i+Oj9YVV/kHEM2
         Wehd4+Z/NWhZ4COwfSnxGXXgMWmAyKMgCK3sLS4KyOf3s0lK9LANPH2wJyUWnn8qJLoa
         BTynxqbIYeU923x+r+yGP0xb05Bx5hBYBWZnlLSs8XrCVI8lwMuhGVT1trfKBttCvvHr
         HGaHpXtuEeuM0oA0zNvYBjikthh6/qzG7uXhVQcZVJ6Z8d0kl/UEyMwJ3laGgzrFJhE+
         /gUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790780367; x=1791385167; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iiDt0g5/VIiAkRdXaI6xqNpm0iErNwKvhkLEROP3Mz0=;
        b=RS0e3rQp70gUk6W5NLlCW6gqL1i8/5SIM/Jk+03hj50cfalkUpQ9/rZWjTMcL1JfRy
         S+Xf+IsXVKJcpwhxxeLAI0JNiATaomG5ZrpiZZ3km4aa55hMAfH0uYQF9LrmH5AVHrrN
         u7X6WBsTauXiTHVitTXZLsbtTOUViMx8e8qtYvmejXxij7n275v22dFhDgnPB8AxTy6T
         qpv1woUBUg8BFkmHL7TOnTKSUJHtU7OZyp7KoKt1enkI8t7qB9sP/VPffkzOGtgoaiYS
         phthYsp8ljoJEIhRioOIhcKJFkWpOQTM3E8JxUuTRiVfiTCSNfHCZW1vUiCfI5/EF7Sm
         +wNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790780367; x=1791385167;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iiDt0g5/VIiAkRdXaI6xqNpm0iErNwKvhkLEROP3Mz0=;
        b=oxvxrDwrW95+8blL4Jv0WAlHyz2CSIXyvVur7+Wwc4pQqiqKLpObt2dScMJTMaRqHe
         rnajM/AqbqBPU7KWk1NIAVmL2PH1OlQh198t+rNmCuR0UzF+RP9RrnWYT1qt1ix/agg+
         +tSiWpSI0tCDVEoC/7gbAp6yCaweRIRDN1/pz2iOazgF5OHNpJFFCRwTfnC6zQ817bJX
         fzi9w5MtAsHZQW+g7FgIe/MY9EmhCW3DNcS2yg8tHkLiaJPoh6+RI32tMRFHAtBT24Gb
         2cDvmcuJ5mRDvWOIvZ/JWQVuNufgryuNI2M6aQAgAAaQTlOqeH87nVgez350c6pZqBH0
         c1WQ==
X-Gm-Message-State: AFq9FYLTGlkHmLrNHWirwQXr1Pr7mKogEVjwt0xRsY0xvDJ3fijJPiw/
	060XOAgHkgc6vyB8J0+ohOscEdIUHuk3o+cFh0E5XzuB2fkpyw3wzKaR9s/Z9F1Gde/KgsRIObd
	2nfRmClmSj4mFw1c/dXLRvG0a5vOBa2iuDVJY
X-Gm-Gg: AYBFou3HWrXqClOb/4x+WULFE2y30chQ/HcaU9LBlNmTFWEGhBvjahpJ85RsXN4EkZE
	p6fLOkm40ZW71lzKbKlue2WrMaMoRYMArX5FwVZh8vOm6cOc21jwl7RzmYjCSBH5l6p0aByWEAl
	brzKMpxvqV6aHDZ1v+ozfUZW72RQl4ueRhKpNtP+qBVC5vuReOJ9FPBrlOC5PBHUxOfcMDzJwHl
	zJx5cLL5m0zjz3EHmCJ0DO9QySEJs571fI5L8hWdhdkM1b5UtsoxTIXYJXkiMdO/4t5R4ekCYtt
	WFgucwEtpJ0WlMy6AmOyN5Y4tam5cCmwGV/LQ+AbwdXVic73eRJz+Q+E
X-Received: by 2002:a05:6512:6287:b0:5b8:ed29:c716 with SMTP id
 2adb3069b0e04-5ba4061049fmr679924e87.54.1790780367100; Wed, 30 Sep 2026
 07:59:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: AYS <ays511.kr@gmail.com>
Date: Wed, 30 Sep 2026 23:59:14 +0900
X-Gm-Features: AclHuK-9UoCck5vpFbXdea-3jpHXaeE-9_wfy_e7KTiyA4ff_4E3n1VqbxGQ5a8
Message-ID: <CAPAqSgapoUjjkBDOLQutFXMoAcEMH4yT9Q0wRpKLMt4QVhOizQ@mail.gmail.com>
Subject: RDMA/rxe: use-after-free / double-free of rd_atomic resources via
 unserialized modify_qp
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

Summary
  Component : drivers/infiniband/sw/rxe (Soft-RoCE)
  File/func : drivers/infiniband/sw/rxe/rxe_qp.c rxe_qp_from_attr(),
              IB_QP_MAX_DEST_RD_ATOMIC block (free_rd_atomic_resources() /
              alloc_rd_atomic_resources())
  Affected  : present in 7.3-rc4 (93f51579e7df). No commit touched
              drivers/infiniband/sw/rxe/ between 93f51579e7df and current
              master 551c722f4080 (2026-09-29) or rdma for-next, so
both are affected.
  Config    : CONFIG_RDMA_RXE, CONFIG_INFINIBAND_USER_ACCESS
  Trigger   : local process able to open the rxe uverbs char device. One-time
              root setup; the trigger itself ran as uid 1000. MODIFY_QP is in
              the core default uverbs_cmd_mask. No USER_NS/hardware.
  Primitive : use-after-free WRITE and double kfree() of qp->resp.resources
              (kzalloc'd array), from two concurrent MODIFY_QP on one QP.
  Found via : manual review. A reproducer exists and can be provided
              privately on request.

Details

Neither rxe_modify_qp() nor the core _ib_modify_qp() takes a per-QP lock, and
the uobject is shared LOOKUP_READ, so two MODIFY_QP calls on the same QP enter
this block concurrently:

/* rxe_qp.c, IB_QP_MAX_DEST_RD_ATOMIC */
rxe_disable_task(&qp->recv_task);
free_rd_atomic_resources(qp);            /* kfree + res->type = 0 writes */
qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);  /* GFP_KERNEL */
...
rxe_enable_task(&qp->recv_task);

The comment states it only quiesces the responder task; the prior fixes
6f7014237405 and de329533792a closed modify_qp-vs-responder, but
modify_qp-vs-modify_qp is still unserialized. Thread A frees/reallocs while
thread B, already past its own free, writes res->type = 0 into the freed array
(UAF write) or frees it again (double free). The window is wide -- the
kzalloc(GFP_KERNEL) and rxe_disable/enable_task can sleep inside it.

rxe_qp_chk_attr() bounds only max_rd_atomic, not max_dest_rd_atomic (which is
u8, so the effective allocation ceiling is 56*128 bytes).

Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000: KASAN
slab-use-after-free write / invalid-free in the rxe_qp_from_attr path, on 33 of
33 boots. This matches the "slab-use-after-free Write in rxe_qp_from_attr" and
"invalid-free in rxe_qp_from_attr" crashes that a syzkaller run on this driver
also produced.

Suggested fix

Serialize modify_qp against itself on the QP -- e.g. take qp->state_lock (or a
dedicated mutex) around the rd_atomic free/realloc, matching how the responder
is already quiesced -- so two IB_QP_MAX_DEST_RD_ATOMIC updates cannot overlap.

I have not built/tested a patch; the Fixes: commit should be identified when
preparing one (the race predates 6f7014237405). A checkpatch-clean patch can
follow on request.

Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
