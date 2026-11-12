Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478501;
	b=VwJuYSyU9leY09KQNPuyCTd1unQkB4tWt65Bv0SRYHKs7eq9U0WPe/hda/mLVRvdF5im
	 qi1x6l0xV+DQbPwnFir2wfPWFpw/TYXDcW4kCNYETA8Vr/DW8ttTaBfs0lbte6kfBt0Ai
	 dTn/kkTSkMTGz6SWoAu1i+850FEqHv6StYzXmNNJMoGdjW3o4RBjSLWST510JNPPtCuGm
	 9/sFZL8VcWkDksX6Vh8V99TLcdj9EPuie3A1r+fYfid/G8tvR/9Y4jDIPo9YLRASjj4yB
	 5JosOyXVvKIKJo+5LWN2bK56O2Fw5yY4ox/8zL9BxQa7PGMIkjkwd278sfdT2rZ/xQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478501;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Content-Transfer-Encoding:Message-Id:References:To:X-Mailer;
	bh=ihVUDcggHZh6D0xYhZJc42bMgYps+7jjufAK/stHqbo=;
	b=FIkkuq4OFp7Y6hRc4i9X2DStrFOJ6IwNsuPUtdBqhXwn8bXFr2TDtW+O08zgiYV5b+lP
	 piZlft5pGxg64U5Lc79mr4+CRYKggaW49GMq1K+9cd6kzycfVGQZI25bUjqJ/RfR3P9VQ
	 zZxRVGMGySSFFvcb+k11gpSoZ4m8KDjwk4R258aN5f+Hog8kJxV+MXe4j9QOwK8dVlpjo
	 zZkLCBveIaNjIcq8OvRFY4czsQxvBx5C3qQx3H0H5ZPxSLJSE0dGEbF9wXUbydfa3PI7P
	 acwuogCCaYS40OJKuG2Rn5P5cjHjmf+wX5ZrKvM1IkyAIl/Lkyb5wGlgdvRK2/mACkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TSgcoAzY;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0399606A8A8
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 10:15:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0399606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TSgcoAzY
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so7845235e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 02:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794478499; x=1795083299; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ihVUDcggHZh6D0xYhZJc42bMgYps+7jjufAK/stHqbo=;
        b=TSgcoAzYSBGKg8YleqBq0oSirYkeMKTSHAk1fuGI/Ma6xKCokSaxTddLnZLIf3yuXx
         MfbwAaoioEP2GFhBmnxpxlLvy2093taK53Rc/Ndf0mkW2go13gq19PpZ/mKNDzTXGxvf
         5f4W15IQdBuZC7xcEYGhjGFVUnI8W4pmq7CqHcuhDrfuDbYZCX9FxZsDzj3f7/1uF6kN
         0MVvnQ/Sisk0L+854rFAY8WF7iV+6F6LhC+BYrwynW95cItJOPimtlpJK5r1PrDxDzVd
         iPwJWJFozgVKMIHJhBHlmqYl8WATj1y72ZfvRJzgcZwzkZ15q4x8yqCBje+rNX39FKqB
         sj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794478499; x=1795083299;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ihVUDcggHZh6D0xYhZJc42bMgYps+7jjufAK/stHqbo=;
        b=R/3ppJM5DOURmG9YImOTAAnKp12964IhCe3reeqoyjl6/Hy7pAvBldBRGF/iVKqD49
         EaNfVr92CcqdVfql1REID7kSQLRAwa7f5OKqyFhkgYhLz1jhS2oiP2lVOS2PyYXfh9RI
         ZYxYQJurhRGMx25Ms8dLeqgHIcfVoeeJPxmaBrN7CNmdxXl4H5pD+lrKAg0tQ6gpalX0
         +yckQQB69rQOKm38BL11pZbhCzfPJLudmGDG6CkWDJ4cv6PaXpzwp1S3HjTqGNsHsXdL
         O+U8ttxb0oQrBNltApsyN3ROd3GlXn6uhHBVBZ9wEkMMA7UO3J4KTAmIprpHTBj7Vt7e
         864A==
X-Forwarded-Encrypted: i=1; AL+hErEDXCB/vGbb+EktxEuNzPLCtb5/wH7llApI1MyrUCeEPWmhJNRRuXvu7fSbyfqEyRQ39NWvDmyTkrrY@vger.kernel.org
X-Gm-Message-State: APuU4Z/cazIfxs8XUNTRMzezq3K35ZVw5lv7KnV2nmZcbB3/+rww4wMr
	ajaoQcSmPWhx6cf3C88L9IFcR6szCb43QcxZ4/NBltYe1abL8xZSGKZz
X-Gm-Gg: AYBFou3ZxLusOfH1tWirYAb3OiJOvVBYCaah++A5CtcwBpCFg5+NZkAAWjhJs/bkZOv
	WJYYYxr7gUhfILFT5zQusUOD05c/YD6qIBZb7z+do1+jbNbkWgmdKuCICYzmEzXnDYlQMemxiyj
	h0+in8H/pPIrtm9FZ2CyvWDJcMksi+BHoHfngr1U96QRg3vKSgYNCpdrTtAJ3CJPXUQRHsc6pzL
	ZMTEX5EMECVYDhkypq9ObYXvxY2fkUdDDYSzjGOFA2PZ933ztk5fjeWV/zxGX57/zOh3ly+CT8R
	ErwIoOxDqoX4QxTw5COHSxvFl28GZYgESRwM52I4ti06PsVl4sd5tGwq39H/p2T7xzsNYUAk4/Z
	+mSxH5CI+HkBfOhDSVTR9YcvKqXU/25JxGFXyvShmQFkT0JhX2J0Dz2jdGPeEkhc9EwQo1YINZc
	pMUEazy2JfEYgNt7CUQcxYNT+eRQ7L/TYRm0SxGsJtCYeV7MQhrf5KRBXmQYch2BybNuAS5aTvY
	Vf7vMJaJrtIiDBDhorhMwmke1/XUfnKOqYJaBRjISJXhVLHFua5GNj9dAdRi/3HGZ/NCjjNLOIp
	uFVu0BoyrIgPekC863RnLy9T+lecqWhRiUXuO6HWzBC+jLzk8Z9QWWpq6v9ngiY/SvRFv6tS
X-Received: by 2002:a05:600c:154a:b0:4a2:10f9:37db with SMTP id 5b1f17b1804b1-4bb4e27a9afmr42890975e9.7.1794478499301;
        Thu, 12 Nov 2026 02:14:59 -0800 (PST)
Received: from smtpclient.apple ([217.111.110.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e26700fsm66747305e9.10.2026.11.12.02.14.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2026 02:14:59 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH ipsec v2 1/7] xfrm: esp6: use the current sequence number
 for the IV
From: Usman Malik <usmalik90@gmail.com>
In-Reply-To: <20261108142652.1330952-2-Jeremy.Jean@oss.cyber.gouv.fr>
Date: Thu, 12 Nov 2026 11:14:48 +0100
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Sabrina Dubroca <sd@queasysnail.net>,
 "David S. Miller" <davem@davemloft.net>,
 Boris Pismenny <borisp@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>,
 netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <530C7AD4-2591-49A9-9707-D504EEB48542@gmail.com>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-2-Jeremy.Jean@oss.cyber.gouv.fr>
To: =?utf-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: Apple Mail (2.3901.200.71.1.16)

On Sun, 8 Nov 2026 14:26:46 +0000, Jeremy Jean wrote:
> When a GSO packet is split in software for IPv6 ESP,
> validate_xmit_xfrm() calls esp6_xmit() for each segment.

I tested v1 of this patch and posted the results in the v1 thread:
=
https://lore.kernel.org/netdev/20260930144523.435271-3-Jeremy.Jean@oss.cyb=
er.gouv.fr/T/

The code of this patch is the same in v2, so the results hold.

Tested-by: Usman Malik <usmanmalik@engineer.com>

