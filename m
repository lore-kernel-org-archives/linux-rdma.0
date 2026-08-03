Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com [209.85.167.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5308436BF2
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766808; cv=pass; b=hJDOpQQ+mbmb9eRYbXt2MN1ctWoNfko4b9MuORlZGcLfvTZ4OBH5iUYeOGFOEgUghVxO6zBHE71QrHtkJDtNXz/pfQN+GT313fTkr9aCH7k4xAqfMOSztIQFnByeEqQ2tuRrfsttRSxAGbglVbxync/D4adAUhfN1xYWokC6cKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766808; c=relaxed/simple;
	bh=ZD1T8UEYALfyFAGYEWR6KzMJOkVcyCLV5pqDwdZSeL8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=rpzfaOtOt4z3bZ6fyGMP60VZE2LvBnz55pkx276IwkOK/Qx8aZixRa/k+lACcT18bVdX+L27d4pi8H1Nslv3aHQDbLd4vbKc0tVuV3KQQucjLSsONo580rJL9POjAb61xT19KlIxrMKGxjm8x+otj0E1PQdhoZpdnDYKg9n7gCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lXNrx+ul; arc=pass smtp.client-ip=209.85.167.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXNrx+ul"
Received: by mail-lf1-f65.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so4074860e87.1
        for <linux-rdma@vger.kernel.org>; Mon, 03 Aug 2026 07:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785766805; cv=none;
        d=google.com; s=arc-20260327;
        b=GdAOjXNgMg2HcGSTqkHmOt0MCtedD42qRndONX2Bc4ea49RuVp5sd+k9YUVQ8tOsi+
         EI1KW8hwxWwh6feZ1gyPGiygtfLFRWjf8jLW4QbbXZ1hyFbnrkfTBfvB6xfhU8YTBYSF
         dn67cpzvl6XaKtxHse2tLJkdpNM451klS3VZBFwV9O+ptlNgiPfLg1z6A4btAy0E3aXR
         xgQScXFtJsGy7jcV7AngUdCNVXxRnnextzG9CPWmf9xEMyG4PJVvBrLRn5S3iBNuBqge
         NicFbpmTQr9/een8AGJr6+/gz+EYgSd72Y1FY73BVXQaQW889W/aA7fqTbZiKYr8ecSh
         fveQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ZD1T8UEYALfyFAGYEWR6KzMJOkVcyCLV5pqDwdZSeL8=;
        fh=kKD4ZcK7EiBbpPvy8fBui+gbh4y+MCKzWSOkLnEd924=;
        b=L4em9JGigtyz0iH8u34ssoIDPlG3IU+1+tNuOnuUQoSuw/iAgvVK8op2kPEIux0G5k
         z3ssUYx9FroHuG8weauVwdV/8vWpqEGEgqX91JrmMtei7GefrDJJfTf0tvZ+KYYLBd9z
         MJMDbD+6bh3agaoWdCKC5zC2L4MXrZ4/Hh/dlSTod0gGidjR/9haFHlMnjMxhEDS3d/W
         n5IpUIcbMeRD1wAkO8Nth3dvIxRh6brLluKH9krsjxV7xPY3mG7kaajJPeu64qH0Pkpg
         dRFMP2tlv6be/tKzrovGBHB0RZTb7PVlYd+FTaNelO/lD/Y4swBOiGA/jV/ig6FKqLDI
         V2BQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785766805; x=1786371605; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZD1T8UEYALfyFAGYEWR6KzMJOkVcyCLV5pqDwdZSeL8=;
        b=lXNrx+ulbpN44jB9HhVILP5a96WZz6yQclFQiMHquIp2eYO1o1xsG2FBlFOqQsp2s+
         7/gg90qKE4moMEt5TL1z92xQ3D2kQqjL/vQ5bFA6AUzHWhYApH3EbC8bvDlBrZToOmpc
         5+ziEBSnkQpSogfoiududgvniqJoQBcHCPHoyFlZvU2Z8QrFxY5Ix0swYUydhABGxDYS
         t6dpCnlrfSKEPrdPHGoKIC70qlaKp56MMppGkezvb3OpRhnQmRlzBbYGkj3AckKLS0bD
         qudEMYxXFPVBug7svCYgdjvX5MURtyX0j6n8p8rn3DlFzmgC5X/E4qJkcyvj1sGXgb/p
         BTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785766805; x=1786371605;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZD1T8UEYALfyFAGYEWR6KzMJOkVcyCLV5pqDwdZSeL8=;
        b=kiHQGYslsxJJNKJ7AVDgR6EL9M25O8doOOjgnbhx9U+I7MFL5/JSAoRC+xWGUE/uAS
         qqDUH19bC+ZiL6oKpWMTkZlaY3VFn4/Xv/GwwN0Oa0x15F+X9NCtN+DvvoqJhqV6xziy
         9iGUSXWYsAuxRSwOXrAcA1uyNV8kwOcsrPAC4ZsLOPbo+MWWGxBLGEZDgPKAvJ0fF1CI
         aimKl2QTHzF5BJAejtybvYXWX67g+mxLq0CHGUSj7M70WYVIeN3qpju5jgK93Yz+a4P8
         mHVxFfGbEHaV0G7wddZVhrIGfo0Fc4gqNjonaGYYOh6H8BZgVMGsVDQbS7E/R42Cgz1h
         XPxQ==
X-Gm-Message-State: AOJu0Yyyq+d5w1JoVw05Dg5JdD/cP9SfusmocK2xsPttBY1yWUeuDy3P
	+kK6cOoHbrNGqctyg03jYhb6TxM9svqNf5zCxsQybwMKvRkjgl0L90XA0sgQWn9xTfObR2jeUuP
	Sz2xXJZHxyoue4vWSJYHZ2Mapc6WGGX5AaARVL16RMw==
X-Gm-Gg: AR+sD12yK3VlX2jesdVH3coJ9D2rLqZKL2yQJXfRmMUWbwf46AbyP0IOEAURo1HW3+t
	HJSUn/i0JwmArwvB7rNnQAzYnYPGCbO+5y5cX6UbCl/5SQqUTPFP+39o0sTpQLB//LVDtrLayu1
	d/KVZm/E/BngWvVFe/FD1FDSr3pkurUrXEGsYq6nhFgHaBRfolrObgUoyeXwiZXyT2GQAMeRj3s
	3ZiJOEsBvCCEJaHZZ9xUnSaQzpq6Q1vpK2A8XL5iSP9cf0nSyauVldxR0BAa5X/cSz518D+M824
	GWcNEC4VL7IDy+DRH6m5v4+9udqp8IMkevCXiSdovbIPvpihXl11i7XvK6/z/viiXiHcV4C99ad
	IphsMg+JX2WTRW01AmoppQqCneg==
X-Received: by 2002:a05:6512:12d6:b0:5b0:6343:a298 with SMTP id
 2adb3069b0e04-5b2e230122fmr2372919e87.7.1785766803917; Mon, 03 Aug 2026
 07:20:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: alu a <alu021031@gmail.com>
Date: Mon, 3 Aug 2026 22:19:52 +0800
X-Gm-Features: AUfX_mzzrgojNJkW4KaDsrDcfgO1HwYaU1tn4wUWaEnhs4okSTJtg_2XCWXikmM
Message-ID: <CAH+L_5bnerRW_shYJLaqokepgCxPzXLQJVr7+jnL3eY0e5ENaw@mail.gmail.com>
Subject: [RFC5040 question] RDMA/siw: R is set without an RDMA header for a
 Send-with-Invalidate error
To: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

RFC 5040 Section 4.8 says that a Terminated RDMA Header must be
present when the R bit is set. Section 7.1 case 2 says that the
Terminated RDMA Header is zero for errors on incoming Send messages.

On Linux master commit
075b74841bd0065a3bda3440873c747938e69b68, an invalidation failure
returning -EACCES is classified as an RDMAP Remote Protection Error
with in_tx=0:

https://github.com/torvalds/linux/blob/075b74841bd0065a3bda3440873c747938e69b68/drivers/infiniband/sw/siw/siw_qp_rx.c#L1248-L1258

siw_send_terminate() then sets M, D, and R unconditionally:

https://github.com/torvalds/linux/blob/075b74841bd0065a3bda3440873c747938e69b68/drivers/infiniband/sw/siw/siw_qp.c#L427-L435

For the non-RREQ path, however, it appends only sizeof(struct
iwarp_send):

https://github.com/torvalds/linux/blob/075b74841bd0065a3bda3440873c747938e69b68/drivers/infiniband/sw/siw/siw_qp.c#L470-L483

That object supplies the DDP Segment Length and terminated DDP header,
but no 224-bit RDMA Read Request header. The resulting Terminate
therefore appears to advertise R=1 without carrying the corresponding
RDMA header.

Figure 10 also says that a Remote Protection Error includes an RDMA
header while listing Send with Invalidate as a possible cause, which
seems difficult to reconcile with the Section 4.8 prose and Section
7.1 case 2. Should R be cleared for the non-RREQ branch, or is another
header representation intended here?

I have not reproduced this on a live connection; this is based on
static source and wire-layout analysis.

This finding came from an academic source-level RFC consistency review.

Best regards
