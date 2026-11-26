Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795684984;
	b=0yjjb/5pLRsBK/jzK3Wi6mP2kDDo1MxGO5qI3zjwXq53vdJBY2SWBW+vGHnLLhueaB2i
	 +dSpMmLts5elQeJXVSLOaPZlSMc6ce2CBWTUEoPV3ldA5yxpKntVd0t+owaxE0gb+dXZZ
	 CrppJ3cnbSgjptShXhUR9BiUyuukdZTzddKiE1ayrphhcr/n2M86CsAT3lkD28bUflgKF
	 sWQymOiLNz8MZ7bEOsbk9BxjPLoHYpJJWg+SNhilm0z9U2R1K4AmGLIzxFRP5JgPSSHzC
	 5IRMyY9S8S6gHkyIgH6k8SYFir+9eTeva0M3cYcUPrnk9HoKqIfgXOhtRraJ5hK2gHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795684984;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=yWyZ1Z9Pbd4bxOXX/sgjyAr1HCnwtGuzuy6z8VWTlYM=;
	b=NHN7wFnEV1uB25zEW0rDBId8fOJdxw/tM5XkZpkg6FDwHvANwfXA6fqEa2YwSBYiFFAR
	 +3Xoz3N4gb6S1ldMI7lPuQKKZn5ejdO7V3rTNfhjH1XFmmPZdNgZ5UPr0asi1cRxpz6kD
	 D82aOLNx+PLrYCC2NnddVpE2vwEcSNEFBjLiYzgP+cc7YMGpWOYWo4h5n3FAOMQCwacUW
	 9ur2NMeI3PFX+CT7KdEtNvFsOYMaLf4TqHaoHPkTlzm2pAblOIxa/hBqkWwEUPOjdtV3s
	 Ga3NTEOrb4OV/RuG7RKgdLxti+Ay4bf3MwVYg77ietA2O2QBXdIAzuoYi9gqCFtRw/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=S+Hr1k1Y;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qFkJpBZX;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0CC606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 09:23:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C0CC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=S+Hr1k1Y;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qFkJpBZX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795684982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWyZ1Z9Pbd4bxOXX/sgjyAr1HCnwtGuzuy6z8VWTlYM=;
	b=S+Hr1k1YChTvMPunMRiV16r5lcOMovr9Q6P25OnLBdQTO/M+Fg9l9izQUvELyP1Baeye3K
	nn0IT5aWxsW6oMMZkxJwcx7bh6AMnOHZtHI+8bRkKqzF39ycsg+mhTfz1EhDtQEMj7nF65
	jCoJNPsh+H5Wkk1/LuTO3IN1yMcfEM4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-xc98ucEpNDiL9D1rJjxOiQ-1; Thu, 26 Nov 2026 09:23:00 +0000
X-MC-Unique: xc98ucEpNDiL9D1rJjxOiQ-1
X-Mimecast-MFC-AGG-ID: xc98ucEpNDiL9D1rJjxOiQ_1795684979
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4a370217dcfso6189574f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 01:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795684979; x=1796289779; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yWyZ1Z9Pbd4bxOXX/sgjyAr1HCnwtGuzuy6z8VWTlYM=;
        b=qFkJpBZXEyThetAAwO7vPpWaj37KdxAJ6F6O2SQRnneOLjsdVBVfTHGTqVeZ5TIOR1
         6PVYWBWciDPvM9B3YcnZTnqMhIRo6Itmo3XXW9ZfUxR+Rz7XFYzhnqEFH+g9dKZ9tfOA
         MxM8zY63sJHh3kO33LYnE0w330Gr33URguexvpXMNceJEnD1/qloqI0c4u9xDT0Ch6jn
         ojRIgkrZAikz6LTrIVKp12c+6JIrb9VEoy4Q+zszDRLA/X6L9cVPkmWLPbOAw45hDhFY
         tbpPC41w+BZ9AnfO0EpanM3IpTneyBf1rR6IBw1W/ljlfXMu7aHRkehXShtJh3JmaNND
         BnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795684979; x=1796289779;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yWyZ1Z9Pbd4bxOXX/sgjyAr1HCnwtGuzuy6z8VWTlYM=;
        b=xfd2F2AGT3tNt8MQGJA0wUTRoB0hgoOJiypR6r221uwHKJOkODKqSVCQTCkcLXCAoi
         Rsysk/zIWtNP88xOX1xkCzqBnUJ8wn2Y38XTS9Q+rQLbxAAT7U7iEXLmNOw31Vi4D/rp
         zNY+RypynV58/MN64Iy9C/xUAmKcFlPUOLvpktKPVM5Lues2YEN7MCnVUSjFQJAbe123
         5SJdI9M+rh9uTYJMsdOfdHHqTdGqK/qmO2IM91u8sA4buxbYojc4RXERKuuf09GBmZKL
         bi4H9tbWQNaxVCj0EubbtERzB98Ggk0TMXdWeRLFXz8Hp3f5yXlA+ZB0gXjtj1TxcA82
         8TAg==
X-Forwarded-Encrypted: i=1; AL+hErE9I+hem+3wjuZaBgH/VdfyL+tuzQpilMad9kPTHuMbAtE4jV325ndttKi8DRx775R2uXpTPz0WC6R3@vger.kernel.org
X-Gm-Message-State: APuU4Z/aiKxlH9mOGj0CY6ey81bv0AQaRZuKMWtGZ33wQ16HaBmAHKz9
	CSO7NWdn0rZbjjz53SMZTc9gyZC94mFMZ1aZpvZMZGtQ8YU29QZ3BTl/354s/S9SBd10w/9bUg5
	ZYLj/7Epmq+4S8qrRYiesqOVJLmvNCTWr1d/Y/SfUaDyZPqlkFgpaM8XSz4nt8Uw=
X-Gm-Gg: AZFdTZcPKfSEByaVNSicgRLadvHuvJJXW+Mh4Rm8OCQCddIxim02fDjVLgPnlJi+YMA
	FgU+AzHMEa3YZgmmWLjn8thNWhzzhJr44yj67vQ8cjj1zKJfUtqhMe3DS7acDygAYr/lOtmRI/j
	ypNO5bA+k19bfaRONTr08tX2Shnr+p7JdA27DyDO5drt5yaOodKJPMndhQ5l3yVmozRkjK/+sHm
	fE/cGZoTY7Z2/J2aaBEHYLo6KFx8l28Kp8a9dh4Q6zXlKyhS0tjAoW6vSvM2UmI8wcup7kUjouk
	pNUOUz1CON6aSXSH9Lr4jbXVqfTmIVMGz9SismG/pLV0dsh90/Kf4cGpzkRqHs2GdZKdmFQHHmj
	XAHqmQ7FSmJa3DKMTEaw/xKB/ddn5c+KbANcqXHCftXW0mvi3+iWHSzkA7f5/HtidRD0fLenM5g
	mXuODCz7AI5KpXfxnbSb/F2BWm4DepSexuTY5c2G4eWEDg
X-Received: by 2002:a05:600c:638f:b0:4aa:2339:a375 with SMTP id 5b1f17b1804b1-4bb8880607cmr384835085e9.13.1795684979175;
        Thu, 26 Nov 2026 01:22:59 -0800 (PST)
X-Received: by 2002:a05:600c:638f:b0:4aa:2339:a375 with SMTP id 5b1f17b1804b1-4bb8880607cmr384834555e9.13.1795684978735;
        Thu, 26 Nov 2026 01:22:58 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865b1sm593204925e9.5.2026.11.26.01.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 01:22:58 -0800 (PST)
Message-ID: <0bc39607-b30b-4dc4-abdd-49f5c72fc2e9@redhat.com>
Date: Thu, 26 Nov 2026 10:22:56 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/4] net/smc: fix the failover cursor switch and wrap
 rollover
To: Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Dust Li <dust.li@linux.alibaba.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>,
 "D. Wythe" <alibuda@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Guangguan Wang <guangguan.wang@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org,
 Wenjia Zhang <wenjia@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>,
 Hidayath Khan <hidayath@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>,
 Wen Gu <guwen@linux.alibaba.com>, Stefan Raspl <raspl@linux.ibm.com>,
 linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261123165127.2453df54@kernel.org>
 <3e66af3fba5b4744b099734fe5054e6e@linux.ibm.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <3e66af3fba5b4744b099734fe5054e6e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/26 07:21, Sidraya Jayagond wrote:
> I am reviewing this series now; please do not toss it. I will send the
> per-patch comments today.
> 
> Sorry for the delay. For some reason our mail server was rejecting messages
> from the kernel mailing lists; it is fixed now.

Re-stating the series.

Note that you can have a nice view of what is pending on netdev for you here:

https://netdev.bots.linux.dev/suie.html?delegate=netdev

filtering by smc _and_ MAINTAINERS entry

/P

