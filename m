Received: from mail-lr2-f10.google.com (mail-lr2-f10.google.com [74.125.230.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703C6274658
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785768516; cv=pass; b=uPAr5O9yexQ4XzhC2PxmgHS3uHXiSf8dArH6CD2KTATJ+hkeRMn3Yj8pauT1t8cjHTCgCRx8srO9NTrzzBicbjZjtYwjyfPpCLdnLJHP9WNKBsJlwVbZg+4Q9Zxs9bKVyUvNsL1LW2j209qqXy594T52xzrc40n0R4mHpSDBu+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785768516; c=relaxed/simple;
	bh=Q607KHzsH5/5xr7p9/Upt+OUrHNR998KOVTQ9PTBEwI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=hoiCVO/IGXo+ZB3oHOLUrH+SdV4iljEPRS+033djbMmQsbsfuFF3P/FpwL8Oi7YSiIhmmbcOgBCZPYXP454IxkaBzO6rxDMgKnfHduIqJNRwyE7eSlnm1AVUnPPH96SWqFHPM5qA0wENf6hNPhc3bd7KtaAkiTvN0lFoA4jm+TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZ7Ky/S1; arc=pass smtp.client-ip=74.125.230.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZ7Ky/S1"
Received: by mail-lr2-f10.google.com with SMTP id 38308e7fff4ca-39c7b6d8e43so18607951fa.0
        for <linux-rdma@vger.kernel.org>; Mon, 03 Aug 2026 07:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785768512; cv=none;
        d=google.com; s=arc-20260327;
        b=aNznd1JSQxcY61C/8cHO+mGCiXny8JwEwNYsfypfOewgCeFfQdfRhzPGR+6r+N+rQe
         vT33rEz8/fQcB7KygUwGKBVo1eE5XefWSoT4XWTkoO5zUaB7MO+xHqkSl7ZPXc0J73S3
         /V325YkqAFkJmHj6yXRrpLSoboDU4hIQ6MV8PQPM4XBxtCxeeYPrS+uqMK64deBnknlu
         Mx+L1HXw8BrrIwyH834WaiKNZlUGf83EoMJXlttgZWrbKAREP9kRn0HULtvFFgxiYV3P
         p0DYLOuVgLxA+FoIZPUdRVPMHh0aRwweD3ykkzVlc78uquA5QT99fa/wyraRyygTunNj
         waRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Q607KHzsH5/5xr7p9/Upt+OUrHNR998KOVTQ9PTBEwI=;
        fh=kKD4ZcK7EiBbpPvy8fBui+gbh4y+MCKzWSOkLnEd924=;
        b=rpkD1Ah9hGdUWO+1maWmwgWCsTQc0619qz0wYqw8gr2NP00+fUD7nrbMwH7mW6HMXr
         AUKHtRKBm2z6REmybSx5YuTx59iSUrwCQid+8WKv6IY5NDKNCjrnL5s4ucCXlLIJ7DiJ
         b/P99siFCzDQRyt8NU+ueyws0jJZbv2LbXi9doxC2S9QQtd/lXkGntzOQfDEvbzlI3XL
         mc6r27aZFyxgLtY68rwgXk7KH7jpXkLf7OZymGT8X5iRpeBgM1MKkNkuNy+vyNOaBbxT
         NrYw32SMW9qiNCwpJJ1AbA8qYhnSkNVqMHvV1r3pTc2zdFNMRnz1IgdT1LMFWaDW2taX
         eqjA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785768512; x=1786373312; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Q607KHzsH5/5xr7p9/Upt+OUrHNR998KOVTQ9PTBEwI=;
        b=VZ7Ky/S1LFGP553rSdOA29+7+8UMMfO4Ru106jkLUOern0x/K2EsFRXP3jVd9PWwIS
         qRVDwpivucSAm4WN/FqtIzIJWhixp2rHHQ9SpTZudUmxDETK/c6W4/KCfGOkZ87WCGSo
         DAaJ14Qv6MhjoyDjunuVnyqiY6pt4hCKUzWGHyD0Fo1rFZWuoM0BhL85S3KRPCi8bIry
         HAYPRXIJp4wi6DKZcvzNRJJcPHPl0yjsnzbQS3M/wEZTKckjlSLnc1Ty0vsEGyiwzXt3
         cgOut6dcajlcx27igG16tUYLD/USJZPm6mzQqPd1JP/caCRiRDPcX6lIW0sKcraJ14N3
         IAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785768512; x=1786373312;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q607KHzsH5/5xr7p9/Upt+OUrHNR998KOVTQ9PTBEwI=;
        b=oz5e+obS11PGzp3knl8tG4bnv0hPy/SpY0pqY1joubDsfhOAFUkLQGL59riwLLfPfP
         sfXwRylQ08EuuzELHbmr8T6Vat7sBvM7ntPd/xrs3p1mS04CM7klNrbPWn2aWmb749Za
         Iqb28KB91Vg9ubV8gd2m3sz3hUvVy/CGS/WuyKGL8mZJ9IDjLmaVfA2Ur0Hyd3iPM/Nz
         gNlzvW1SbSlUMTHlcoAoQVz9vz8243KLmcEDzWNA7EgTC5KHPzARvkvMbSziYTtWVSS6
         nlv02KWcisHwo2BDr1/AD20PhWwlIEkoAA3jSm8zASZMRFtfDbzWZZRQH5hLemzUEbhy
         L33A==
X-Gm-Message-State: AOJu0YxAufdMcUoLb81F7TeQ6tkIZq0q+9hC4aFKhoS8AY/q0dF0Cn3y
	MIvirRi0GyCUKsuGpMih9wV7Kbut77s/eHPPE3H2T6n066x2y4PDiw3r41db9QbRccEWfreiVTQ
	wwbt/PnGZzJNbTMS+s5E73j18dKvvm99emhOM/182lA==
X-Gm-Gg: AR+sD13znK4wiFAwoOiKjIz9FU2D0p2QgGyhTgsMqa8dbCvZ4J0vg9O0astpiT9Bl3L
	m0U7mfgMkmKWs19Koe3jSOLxq2/kMmCRZp4dvwPmrg9WwM51+aWIEyQT8XdtE+3oAZx7Stc5kXl
	t34nD8ERZTQvkwd8zmwZxb7qv44gzfWT1D8vzRqv18DLbIG1KOWYkPt835Jp4/QhB4l7jkM2gyz
	HXCqdRvtQsdNzL+lZmyG9Q+C5ep5va+3v1tmIsX/aLU6pYHnWCN5SzK4MpbYRzK8uBwQH/D3Leb
	uhBC4ykn/lyhHbzhg6oj6bcPV6G2021/y1NZFckycKcMT/iO5wSmQAlI1FOJ3M6c6b/snWdN4sy
	rf37dsifise17UrxDVrh9kctz6g==
X-Received: by 2002:ac2:4e10:0:b0:5b0:1959:d87d with SMTP id
 2adb3069b0e04-5b2e4f363e1mr2225751e87.25.1785768512332; Mon, 03 Aug 2026
 07:48:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: alu a <alu021031@gmail.com>
Date: Mon, 3 Aug 2026 22:48:20 +0800
X-Gm-Features: AUfX_mzbFas_F1UCL0JcHHHxAX6cAJJz9KTWLNBLTaUHgOV7OjIH3LeFXGR0jnk
Message-ID: <CAH+L_5ZsxEAM3y8PmVQi1rMQhdRu3PKX9JWGD5N1hC2rkP9wDg@mail.gmail.com>
Subject: [RFC5040 question] RDMA/siw: received Terminate is reported only as a
 CM close
To: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

RFC 5040 Section 5.4 says that the RDMAP layer MUST deliver a
received Terminate Message to the ULP. Section 2.1 defines Delivery
as informing the ULP or consumer that a particular Message is
available for use.

https://www.rfc-editor.org/rfc/rfc5040.html#section-5.4

On Linux master commit
075b74841bd0065a3bda3440873c747938e69b68, siw_proc_terminate()
logs the Terminate layer, error type, and error code, optionally
parses the reported header for debugging, and returns -ECONNRESET:

https://github.com/torvalds/linux/blob/075b74841bd0065a3bda3440873c747938e69b68/drivers/infiniband/sw/siw/siw_qp_rx.c#L887-L957

The receive loop treats that return specially: it suppresses the
normal RDMAP completion and schedules the LLP close:

https://github.com/torvalds/linux/blob/075b74841bd0065a3bda3440873c747938e69b68/drivers/infiniband/sw/siw/siw_qp_rx.c#L1409-L1469

The close worker reports only IW_CM_EVENT_CLOSE with status zero:

https://github.com/torvalds/linux/blob/075b74841bd0065a3bda3440873c747938e69b68/drivers/infiniband/sw/siw/siw_cm.c#L1119-L1129

The CLOSE upcall does not include Terminate-specific information:

https://github.com/torvalds/linux/blob/075b74841bd0065a3bda3440873c747938e69b68/drivers/infiniband/sw/siw/siw_cm.c#L351-L409

Based on static source analysis, the consumer appears to receive only
a generic connection-close indication and flushed work requests. I
could not find a path that identifies the received Terminate to the
consumer or makes its information available for later query.

I have not reproduced this at runtime. Is IW_CM_EVENT_CLOSE considered
sufficient delivery of the Terminate Message under RFC 5040 Section
5.4, or is a Terminate-specific indication expected? Is there another
path exposing the received Terminate that I missed?

I realize that RFC 5040 does not prescribe a particular Linux API, so
I am asking about the intended mapping rather than proposing a
specific fix.

This finding came from an academic source-level RFC consistency review.

Best regards
