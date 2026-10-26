Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793016122;
	b=BK+Ey+7314Xop0PdKF8Vs13vTmXFVOLkj8fibK3m/3XgYw7dWeynB3HlXgnShM4Xti3j
	 BiJfBU69TxT8/OVQtveOBA3c4/VtdJHUJWhpjcN9DcauN62WfxoqtRkttfzyphpsLPJev
	 Dgcn9y3hPcClgsfiYcoGPesgLmwfZJ/l2PNgr2aamqAeeaRGdqXYzBrjVwDZbiu4i4KGG
	 CQio+TTiBb4Waf0b6OBaJcTYK6tLU0TERql502zZIQAoXtntfBt7q5DRMtS6M8rJ2Xjnm
	 KeLfvtTH/L4b/KpewzeeHvDBiL4gFQVjjyIkeZ3pnUlEl3gVOdDReoxHc2fFPW+AM2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016122;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=9JFC6LuG7YF0CeRN8iSSPvCak5V2ejw9gPNztgjVZ98=;
	b=Yk97L5vklZLz9mnmtNnt1mHITSBvOuFiZQCZq8fLAnRdLcA95NTwlHuoYc80QUYIvq4P
	 PEOUjZScwWuvi3ZJ1MNWozkw2kD2W+9KLJ6yo4Nh8sRL3kKlG7rG2NCuxwOshOenDAghS
	 hQIA0QB9ooFTwzjZqprr1TRzKqyPdx802wXiuuPRdPJz1E4UiJYGKSisQRyy7SB7XH4r5
	 1/JPET9mAFnB1ykNJhlkdqv/mvPuBWfe4Nobx4rM+J8z4OLEUtWB8s+/ktX8lq3jfAdsp
	 aTiv8O3KWTxsCDHakux9bOBTcR4T2XHE90/O8jzL70ZyDPeFLVrhZZSlojfJeCKjx9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="U/lPoxln";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.45
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3D60A3813
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 12:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EE3D60A3813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=U/lPoxln
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6de1ca1b05aso1903049eaf.0
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 05:02:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793016121; cv=none;
        d=google.com; s=arc-20260327;
        b=AhuTbtiI+sQgSA1r7BvHLi+rXZxXKXI7XGXd/LEAutDNrcmKJfmBx8UpoyknFZldAF
         xsUZboPWBPGK4Ta8bBndXmpnr8eTjCZYghly9Ft9WTijRzM3aC6v5x7G6EJpI/RZIjSI
         avPaq2v4EKY3W94Uu/Dn3bxD6qL4tYO3VewDu6/u7Z/1tsYW9GpBfQXEHidSmA4X6YOB
         d7nQ7NsjoC+pOunYtBdUWjIqHtZIfF0Wscmj2YRrM4h65RfyQpxDPyZ5HLN/WBC/G55M
         i0w5NBxDCOU/L93vpWwxIRdI6YVsEpSHT/FNjvR5/ZcpRHIP7Xm7+jL33ieL4PHzUAZq
         dQaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9JFC6LuG7YF0CeRN8iSSPvCak5V2ejw9gPNztgjVZ98=;
        fh=jkUtu9B2gAZ+nKhxSDZX9kF7F4HQuH/UcKG3ndIKtDQ=;
        b=ec2G17qkMUKft+HBMDk1TFJcWatPwbx1J2xc6I3grhzoFjLtLRJ0gUaEJvuoR72bfc
         wbar3Z4uAGz8UgID/lMETQjQK/k+c7lzYn8KX79z1jbGBru2ItDpk5duuNunNDxkPc8E
         tPnHR7x8kogq1esrDqBh5CiWSnHfWfrHOBW8hDp7NDqbj+BiZhIAaTeiKlW/0pytYrHf
         IvDZXzPUS55X1azbIVKJ/jb6uNCoadTn4OzB103Bw1XQqMnUwk1ZT4Tss2VQeamxSlg/
         +sUX68iPa16T0moWHfiRRV3mlKqkSHOTTSZefWHYeQfF7+9wvmO/xSvljTSXiWPXWP+Y
         Pf6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793016121; x=1793620921; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9JFC6LuG7YF0CeRN8iSSPvCak5V2ejw9gPNztgjVZ98=;
        b=U/lPoxlnW0VPxoMv3EdkegnGxClqANd6Fm76ZwXXUuZ6YQ2u8nfacSeuzHYctLf9oE
         PjYggLBUPYmWQDABrqJwFC54PKr6TpLTSW9sKR166PGKH9RCIOHWjLG4AUsxZTieArAo
         /HUzhaarVYPAbzl2vmX6euGfjz3PSBNDtd0ALf+pUARdydaA198zOkCTx3X81wzbSonK
         9bTNA7fWX3f6K7l8VGFHcZ4Z1Qu+XrzO3N6HdU+5QCxNU+Ff0mYhaA4Z3cvNaneGS782
         YlZqvY8+AqhnO7HW+qiocS7jxM1fzon//r6JXZcWXqn4/jJn8fNowXyqO3o6qMnEvrel
         mUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793016121; x=1793620921;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9JFC6LuG7YF0CeRN8iSSPvCak5V2ejw9gPNztgjVZ98=;
        b=Sq7joup9cFcm0Sa3gDNEfTJseLvmj19tNgcmNm821fjEL7AcIJC0M0l2yh/wQ+Kgug
         QAbW0WLhM+h+OB4ahu5i6SU7Aiy6pA5QDxFKeiMAMZtJaAwrCOI96mYGcFGCRHt5jYjB
         kvZseRE5W4qXk/SVHCdHYmqT2o3PpiX8wjZ0QnFRmWAeSNYS3+RE/CuqO+kTCJEYbLIN
         kjcGUZ+D4AtC/5oCpEz0U6MmgbKnJgz6WeDjczIaFObgdQDGD+oxLp8oT+LaNQo9+Ixc
         V5w9aBaG2R17fnPAGKvKGlt6Sw32nodvQ2qkWemKaFB4byGl63IYP5bk4jzeYa6oQAbN
         lVzw==
X-Forwarded-Encrypted: i=1; AKwUvBzGrIXsb6WN3BjNJ3VotTNrLQtptL6OCz5Gb/IHDjymyEbUD13GUYgPPi7mWjwoymeg2P0uWpm7AZGf@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1zT+XB8OjkBSchIAPkmx+0YvJPikHYIOXyDvgyhUQowGNaWtS
	yXiQumOvV6TUvJnavdWjCZZvjtEGKW+Dd7k8ikg7in3kh+RgvJn+uiTFMcbtc724TB3NUK09qCU
	lLtVE66/LUuovsNG4lZcHHzN2VUndvPIdEXMYzho9V7B2uUhuPuxwveBZ
X-Gm-Gg: AYBFou3Bm0wTPSLRByXOj7P3aUdoCtPc82DMsVeC+qrcokoQqbvQX4y8/rIjxCRk6+x
	gYEDvKlNzVE5JWYQMnwpMOMHnvqMs/Hn/nJYZZlF+i8GM0uRO6Bv62U7z0omeQgCCDAjUu4STTn
	OsvYj/WdSTlWFuLonRP//MZFfNqg4NIT2l2597WQHccsaFrGtnl4BKqSdxoFNXF3qNrC0ZCTp95
	nlD3oWkwRNcuicbSmn2DCx5artMISyjcAv7wqzmOBJXY6dFeERiyqq+f0J/UIvRp4mSBXTWyoX0
	Xyje7M6bSfyLSb09RmwadXe9wWkDuLenUJ6jtUyRneovdvU39+m4bHfYYB6DGJ5hwyCBhV5MAEn
	KEIovQDSDKBcnq/UQVVCmkm9CutJZK0rhLjnuXpJA9R6vZDo+uVbsSJpEn+vOvpEf4si3tIUZBY
	32S8nExLefuKvUvQYz2QY3xYenQ/v+N1KpFy92TyY=
X-Received: by 2002:a05:6820:55c5:20b0:709:a86c:7c58 with SMTP id
 006d021491bc7-70ba0e4cf8bmr2185587eaf.49.1793016120389; Mon, 26 Oct 2026
 05:02:00 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016202909.1289496-1-dhu@x6u.co> <20261016202909.1289496-4-dhu@x6u.co>
 <sashiko-outbox-174922@kernel.org> <CABdL-LTgFTwJPTD0vyScNsvCSAW_04TgOyO1swVBgHxDcmJsfg@mail.gmail.com>
In-Reply-To: <CABdL-LTgFTwJPTD0vyScNsvCSAW_04TgOyO1swVBgHxDcmJsfg@mail.gmail.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Mon, 26 Oct 2026 08:01:48 -0400
X-Gm-Features: AclHuK86qSs7gFXUSh_t11KPVJZZWI0qSyRrGNFPLSDbHhWXQ4pP7y3mUrzZgOo
Message-ID: <CAHYDg1QGH=GwAB-acW_oj3DJdSZBPidv9Xxn+n9=RT9Ss2PC1Q@mail.gmail.com>
Subject: Re: [PATCH rdma-next v3 3/6] RDMA/irdma: Support UMEM attribute for
 QP creation
To: David Hu <dhu@x6u.co>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi David,

Looks good in general, but since this IRDMA driver is used with iWARP
NICs today,
can you double check this Sashiko finding? Maybe this newer path can be rejected
for iWARP NIC types at first? Or if there's a way to make this new path work for
iWARP, even better. I am not sure if there's some generic way to map the generic
umem for CPU access that works even for dmabufs?

Also, could you provide a bit of detail on how this new design ensures forward
and backward compatibility across new rdma-core, old kernel, iWARP vs RoCEv2
modes, etc.?

Thanks,
Jake
