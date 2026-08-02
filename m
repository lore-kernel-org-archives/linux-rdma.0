Received: from mail-lr2-f7.google.com (mail-lr2-f7.google.com [74.125.230.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0642DE6E6
	for <linux-rdma@vger.kernel.org>; Sun,  2 Aug 2026 03:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785641999; cv=pass; b=ZjVcwrfjlXVUErAbGhqTHLFu/h3WQVtNrvPGipyJU8SmbtpZBSzf326+ZsRvwPWV1txS6PyyP1PpwYClBiIKLToXiJMoH/0dHyimcKU9MIJkeYcahIeBqXY4EZaTfjVQAW27QHvfSIJCgi4cj7iTtU//ui8aVigjUlmKD3NsuWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785641999; c=relaxed/simple;
	bh=uQQUV5nSKrLWB7YVXZO2JAf4vGFO9ERAI5v8K1hHHnI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Iho2gP8FsKezBWCxwrI2fUxokkFypXSyqmDwl0K1WpDweOKrpdgfZlATD5WhoKsRBVNGncVfFIfVmlskxrUF0DwWP+zqYI9rCBuvZuQovAb9Tz25kHE/U37n8U+hOkGzeC/Jkq1es2y3YVUVI2lXByVjSpMa3fJ2Vldwm5bzsP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GT7Wc6/3; arc=pass smtp.client-ip=74.125.230.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GT7Wc6/3"
Received: by mail-lr2-f7.google.com with SMTP id 38308e7fff4ca-39eea1beb96so11644581fa.1
        for <linux-rdma@vger.kernel.org>; Sat, 01 Aug 2026 20:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785641996; cv=none;
        d=google.com; s=arc-20260327;
        b=VYxCEheJ47FrpoiIxQ+bHiBKTYMh4MPrDvN2VdTLnkQ9mabwrAgWPST6ADCUG5jfrx
         UZ/PG3RJ6h8y8w22LxECcc4iFmPdoN2l5LG57/dZcv/XJ3Wc+78dsnHG+YVttOfoC0xC
         RzeU/sDiiAs9XjqNj4kf2LJGVV6rnBIHRYnNIyXfGSzan2vITbHYECi85cA9vC3bOfZG
         lHTnMwFr96x+JZP6IlSKUQhdlDpCkn9Gm+vm5FLov4jttPF/Z5tvIqMVhGotocWLWcDa
         5wtFFCkBeUwnXWotgeoHeTo0udemh1Q1g+AErEYg0fK0pX2YtmxXXJb0tDYIil0InWEV
         x2kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/QWu105x9/lUl4tJqZZVKt3HxPO/UsUXSpUDtHO8kQY=;
        fh=JkS1EVnaJtW8X+Ly3/OCdJ/Uu4RMcTq7uaKLOGeorg0=;
        b=WtA3U+xbhIfYb6uXuHXjwi2Ivzn4dA7JMvdR1hVqFTEaLkxgah8Hh1Zt/YYewlFjNv
         Us02zE+Kx1Eg2ctuvneFzck0kH9WEEoDWZ9xSUvq8PWjQhZ1N6fe3jElN+OF/6ElnBVF
         LNdfDnLQeRpU6CSSdNJwD6xlv67lSrQrsS5LuK/xZR9/c3e10U67p+BLDzVcWhqvtcVX
         SVn1dnocpyz+2K94aLWa45cBFjfsPiVF/K5aQAVgqSdGrPQP/1hEyorKbQqkIfINPlEn
         klURn6Xlw3yzjLcglDIwHNrkn/JKlw9Yofn9ijfP+V5b0pVlAlj1IXaZK57KYg539fNj
         NXAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785641996; x=1786246796; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/QWu105x9/lUl4tJqZZVKt3HxPO/UsUXSpUDtHO8kQY=;
        b=GT7Wc6/3Hdyht88KOmlSM+Sr/eP0ZrWBHwp+ZzHwBv1NLNltxddp1ygZ8yP3xfNpFB
         Qzk+76w19DPtI/8FCnCD/why1x29FfJLuIM9dGJf/25+B4bk4evY/inYt73rL9yhgNyD
         BJD0X/t++rYHOI8WlxqSGt0rKLN7DOoLTOs69hQsLLaCoXI3Kl3JcsaTMbF5f+TI/otG
         uKuEP34M+pAv3parzW7eGEINW5h7lYVeWDMcvN1k3XzVlzCUWMI1cPWz20yoHM+r0353
         MfZbLtYsVJSKvs1A6Uq0X0Ei31vFKllvmcjLCUoCsby6940Qxj3BjsVqqwH7j4ndxH4h
         iOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785641996; x=1786246796;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/QWu105x9/lUl4tJqZZVKt3HxPO/UsUXSpUDtHO8kQY=;
        b=IxsjXWgP2INK4CI1d20KxAncer0ABckniHyRR1k4TAyJaeTJEMzgAoyROmCdyTUdx7
         dYh7c33qyXbRJ5O/DfDn0ub9JSyoG1JO1u+8eDlLWnHGqPXRBvfE71OctFae23NA4Dp1
         VtAj4cV8TzRQvW0XyVYjQ2Yk5i/T5L9/ctIzanw0QG3FwE6y3qLwi7Bkpn/W0ijG2JeE
         PfYJkIG9mEISglhYKrK12KJvNYC/pGNrqaUc3Pi7n/rrDGYBCOM/3Vk2vUCj2NU17nsq
         6vCtIt6uGdYNvFm7pnT1IvfaCBzb8fyj6BTGkXUJMsHbm9EY192zAJJfpYyGrNJmgMJD
         Mddw==
X-Gm-Message-State: AOJu0Yy2VywvxRniCosryBsDOOs8dASo5nqquNaa3CGNwpae6caqHjT+
	2PGKzb+TQwDN4wpi4MbnbEB8Wh2pbT+Q0QxVU45e67AmYwIkWZFqroECmAYvQLOSMg1nZwx5er5
	N3rrzny7Lmrw4EPxN4NjFE+W07ELvCX2SEJ2v
X-Gm-Gg: AR+sD139ZO6m4SO/5nvqtmRHng7hFINvGQtmPjtzeF+iZ1Y1iaTnL9gdM3/VEYxAgI3
	jvowxPc65rGuiVdBHYUB1GJjcAdnwcqqKrWWKoiMJREBrfxXQXLJQmCO6OP2Skiu0GqVNU5kXpv
	159+36M+kBgj317lH3WGRQsUy89KbudPR3ncEHxZcNtuuumhuOF34Hh8n9+eYFVNTcfOnxXNfpe
	Th0LmBfcJ5F8+pEDDUg3AM83gZsWY6sgUHn4tm/DGIEO+emXmtic8ri6CrTvwm9Ek+QDG0YoOee
	vAdhYMc5g6tVBZLTWbL9uQuI1o+qb9o9m9cJzycYEHAsKBaSRM/9Wy1h/nGQncx16xRv0b/f2WS
	xxUkgjg8p8zsySiMOHzkZ+pUiZA==
X-Received: by 2002:a05:6512:3750:b0:5ae:c926:fc18 with SMTP id
 2adb3069b0e04-5b2e4f70a3amr564723e87.38.1785641995580; Sat, 01 Aug 2026
 20:39:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: alu a <alu021031@gmail.com>
Date: Sun, 2 Aug 2026 11:39:43 +0800
X-Gm-Features: AUfX_mwrRSstGdK3B0nX-mzAwTdLIJFOhUQEoa_kf0hfX4XNS4YMrhMv-UmkP80
Message-ID: <CAH+L_5YXj_bWqr+oOez16OBcDp8zRggJ8rM8zCo_hfSUrCeojg@mail.gmail.com>
Subject: [BUG?] RDMA/siw: Terminate control bitfields have wrong wire layout
To: bernard.metzler@linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

RFC 5040 Section 4.8, Figure 8 defines the 32-bit Terminate Control
field in network order as Layer (4 bits), EType (4 bits), Error Code
(8 bits), M/D/R (3 bits), and Reserved (13 bits).

On Linux master commit 2d2338c93da79b3bfe4b6099a931d9468d539952,
struct iwarp_terminate represents this field using native C bitfields:

https://github.com/torvalds/linux/blob/2d2338c93da79b3bfe4b6099a931d9468d539952/drivers/infiniband/sw/siw/iwarp.h#L176-L213

The setters assign those bitfields directly. siw_send_terminate() then
places the structure in iov[0] and passes it to kernel_sendmsg(), without
converting or repacking the final four bytes:

https://github.com/torvalds/linux/blob/2d2338c93da79b3bfe4b6099a931d9468d539952/drivers/infiniband/sw/siw/siw_qp.c#L402-L419

https://github.com/torvalds/linux/blob/2d2338c93da79b3bfe4b6099a931d9468d539952/drivers/infiniband/sw/siw/siw_qp.c#L557-L570

I copied the bitfield declaration into a minimal compiler-layout probe.
For a valid RDMAP Remote Protection / Cannot Invalidate Terminate with
Layer=0, EType=1, Error Code=9, and M=D=R=1, RFC 5040 requires these
four wire bytes:

  01 09 e0 00

The current declaration produced:

  x86-64 and AArch64 little-endian: 10 09 07 00
  AArch64 big-endian:               00 07 09 10

The little-endian results were obtained with Clang Linux targets and
verified by inspecting the object bytes with objdump. The big-endian
branch was checked with an AArch64 big-endian compiler target. Encoding
the same value as cpu_to_be32(0x0109e000) produced the expected bytes.

Based on this compiler-level check, the Terminate Control field appears
to use host bitfield layout on the wire. The TERM_MASK_* and TERM_FLAG_*
constants immediately below the structure already describe the RFC bit
positions, but the current accessors do not use them.

I have not reproduced this with a live SIW connection. Is there a
conversion or compiler-layout assumption I have missed, or should the
control field be represented as a single __be32 value and accessed with
the existing masks?

This finding came from an academic source-level RFC consistency review.

Best regards
