Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.160.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794256665;
	b=N+hZ7mnRcnRIdSF8vID9PA0Edrp0G6Pi7GcjAJAPijgm7p3n3T3eAS+n3TNtX4Sg65hT
	 Fn1FPJHZf+lXA205d+TWoDEMB1pWCbxNJeJCbmTGetTUyUz5+8tNyiS9tgDbtMjxNzWjm
	 JsiHOWWckksJYqOYLAXAUA5izy5yYSOtCaGAWRW1WXUN8JomA/EDQJ7Zwx40JxmbEb4z9
	 mRuTSuuofIPDukr77RE/E0jCUXc5qstcdwBtQHt5Ba9Ity9/yNyNChtf5tHE9qAmP8DJD
	 PnGlAHPSeQp9G4dVe57lMpTUXk7UF1Pn4/dlD8YMRZeT1p440VCighwt+2fCj1R1Kjw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794256665;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=3VnwQPCrlu9xRWyyUGXbolYTbPxkn6lPaAfhcAqhvX0=;
	b=Nvfbm19O68l4j4OPyvKcYOEXzb9DnNGFiCJYpUg0JpWwjH/b03wI/yT/GbV925BkLN0F
	 0GvnywWTCG3KSUsHt+2/wonGwKP+VQy8O7+zRY34kqpz0DG3VqwK8Hugv9jcLsObyBeLb
	 xHQMRFHW0AGH0g5Gv5m6H9j+picIoThWF98V2AeGnKQ/XE7CAR7Yi0B1qe71quIHn0ojW
	 276PjdoZq//rygSPL6d5mUAhGXEvHiY1B6tDpdrETc89kiLcz6trxjbma2H0BKmTJkZsc
	 sTJ9fQKVwRTPA4EEYoh+U5e9tecqqJsqmV7Wc4tl8duR7jkc1aeK65EUVqdGCbcRAYg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=awx4H3jV;
	arc=fail smtp.remote-ip=209.85.160.50
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862AD60A5BE0
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 862AD60A5BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=awx4H3jV
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-490d838b425so729031fac.3
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 12:37:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794256664; cv=none;
        d=google.com; s=arc-20260327;
        b=AkBnuhyTEQ01PxaUYc2mHiX/TtJ8nM1hLUz2ZSnFEpdUaOpp+vXrL482nB4n5ycEQC
         uMmcBglmi2BOTc9DEh3xrQa0TpYWedqq28+2Uabr01NEiB2USaF/72ujqOjwtTnWVPll
         QCdsRD38t7ZwHIfP/1bgUxG97Pdxbzy94zsz7/G+7/gn7sYi9Vs8F6+ucq59ZO6p375g
         ruRtCt8957KnpwfRtkdG/DyKx+bzJ8hPcnMk5PHdG/hxrxZbVaGb9iI66SyPRf3wKVWo
         3yZyDBNCGZ2Eh5rbiWiu1QlbvyBPxMuCk7DKKHRTiwNeEfKWP2bfRVwXNbxisw7j9yXS
         MqCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3VnwQPCrlu9xRWyyUGXbolYTbPxkn6lPaAfhcAqhvX0=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=Ab2qwxQSiSbTCbY9gwtg4J7NznTasqR4uy716uswgMUSEUyhR5Z6VX2TsLmNhOJq9o
         jQ22gKYK4652zNNJoBHDxsIKGJZGlHweiWkqOlGOMtcj2a7she+HY3Is+7K+0/bT+MRb
         GxmGCQpw4MPLg/tDa/pNGzBui/0L7Qwp+mPJdlettZBw6IaL+nr206TNUbNwCAePiRhF
         exPNPmJzT7CJT6mvkmIBXcax368vYJOnizi1LGhvLNnAxOV4ppEhgXAhfikjLWsDW1lf
         tmjzhgPDRIapgVMKdV2MN5x2+X1WDiM58gPWZDE43UZ8In8CoHQD2E220hdbRD34M3qq
         hkDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794256664; x=1794861464; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3VnwQPCrlu9xRWyyUGXbolYTbPxkn6lPaAfhcAqhvX0=;
        b=awx4H3jVNthUeoR884ECdNay9eNObDOtdzeMOnbOUknJ7rRJg1O65Ram1LU3r/Xg2i
         0v9tVxCzrXt1Iju8YkxMqrPH2L1qvOjS+8kXFGyGsckvEW8uKfoxSZZdNaq/5WGeCwQL
         hTR2bOE1F3PG2pzryNIGDcmoujq+Qm6HY3JUWdCHzMgOfPoibjfhqkSjovMRA4FQwsRS
         kiDjDpVuZdhzQlkN2EbJWN7YAuOSJDdHyIZ/U2EnvEhONGl+re448bQuoYmZK/LUEuB2
         k5IB+R2UG9hwWdo8gSqo1bcsGozmdnD7aVjkTP/ij0G3aoKFxQ/yeUjl5I9NI2mJ6Dn+
         q/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794256664; x=1794861464;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3VnwQPCrlu9xRWyyUGXbolYTbPxkn6lPaAfhcAqhvX0=;
        b=NgtBSQcnPjrBV7mvGUmeedYwdulNlC+4Y+3GRb6lLpZJNa4to+ujA7OA4AngkddENB
         O3MHGJp9a3UrFZm6M1YQG4i5JSVqgm8gTjlRbZUPTQB7MsGBqKoyIx3wSiDr3oXSeprX
         EEcVlWil5Ef5Y3AxRNUyfy/DLowEhrrop3ub6MYtQdv41JAJXDNqXjPvJgvzcmPlYBB3
         UrPnZnZC4U1LHTX34EdroSHqEBUh3E4llXuSJr1RN+KJ6EXcd17o/bkqfdPUU0FlyLSc
         WZ+bICeby6OIQEN15UBwXgo9y75rvnE2Wo3Ofp+ClT4AWxfqDdTATKDgMOg65WlhIC4U
         ay7g==
X-Gm-Message-State: APuU4Z9bBqbBKGBeXzEOhq5MwCB55ZiM8VgLj5HQS+hEx/T843QULuVR
	OxI0yByhhSXjZWf28f0RLgXbGQoC//WUkrl6Engdn1EiPh/u2bSOf8+Schwz9NyhiKUPmcEYViP
	hU9gs7RpSXZsIfzOOO4v9wsNv03xvgz0UzXHiqEvZ6I92nNaT1nEFiiKb
X-Gm-Gg: AYBFou30JEIPQtdT3NmDCbHF44krMw8y/8TxhFfindcxp5DOLM5ACzHipakWftKamGo
	duxIMe4ntm0u868sWzn0o1d6RN2pvWJ1xAQVvFLd7rV32JUvHzPRhGcULSQySHS0EAdL6haCs3t
	DLZeWwn1k6uJ7/uuZ//j4FRv5NugBqfspqdBuS4IW4I8SHcvjRqw2r6JEt+LHebZhCDo3gJ6vcp
	Xyu2v1sdG1o74cq6Dk0DbYuNFEgTVVe8kT9EFq3ChjUdNW861ZzcnqhDZH8TTCceoq+La+4jtpY
	KtsaTD+1aF4KVhtaMuDpmxE7azLMzQaKeYS7M+YRgysONc1Hps7WNmuG7Qsp7BEeMbtPIDbZRHS
	fFvwFdJ8Wq4FtWh94tIVBzfLVZSTJlfpf25VXELhxI4SqYvxGINMA0iUPyjD2P0MJMn5ozlaIOZ
	yaWFUwxw==
X-Received: by 2002:a05:6870:1719:b0:4a7:4263:4079 with SMTP id
 586e51a60fabf-4ae222f3d0fmr232893fac.5.1794256663889; Mon, 09 Nov 2026
 12:37:43 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109202525.2937295-1-jmoroni@google.com> <sashiko-outbox-205588@kernel.org>
In-Reply-To: <sashiko-outbox-205588@kernel.org>
From: Jacob Moroni <jmoroni@google.com>
Date: Mon, 9 Nov 2026 15:37:32 -0500
X-Gm-Features: AclHuK9nrr9G80lOhj9J3N4JbMhZzHwhS0ajNPYstkexEZ9RC53Sc7Y35e5cFaw
Message-ID: <CAHYDg1RcDU6mBYyuE9CE3pHu--XZoauv=2v6ZwBNb1tNYxOWwA@mail.gmail.com>
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Fix potential UAF during SRQ
 limit AE handling
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yep, unrelated and will fix in a later patch.

- Jake
