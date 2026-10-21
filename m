Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584829;
	b=gZrEEMyOiM0ogvdv0XJCHJDoSaCbh78A8VO6xMe6rSm6bsswmNrWpeFoEVkfM33wOui0
	 2SyCvnB3U417K7atRBqC40UZQ0qavjI6YztbZRaALMJ59Sqa+GseoDSH65TUFvGk61gNd
	 iEttAhyvKXqnt0jMaUdYPHSl81wa9Y5/LU+XxPXMmMk+UrjUlBhb2UceejVJsj4RRLDib
	 Hd+nuT2gDOTah/pd6VoG9TDal2t8oQZV7/l4MjmjtCagj4Pvw4fmaAJVBN3bLubg2Txm9
	 gTEDLkuZFRr+a4kx/zf8MicZ1nvzmMWZMZiSf1N1fCvF3ADRDb8rsFQbgz5gYa37FUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584829;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=GabWm1gqTRhtdugyu8wuzjBRL3LxrLTh+7DBvXTyk2c=;
	b=p2vRDnCX6HQq+jImtcNOadVMzZsu/3a6Qx9sIOxX2wLkwCkJd2LRJjt8SiXUNKNbwNU9
	 5rhEP3AHZC1doalp9vgCIbay7viTVriD8kgR4pcyNuD9qN/S1lbIN9r9uyKKlm+DYazsa
	 HCv8Ig5MlgCIetMpWN+jrwUhhFnTTuVq10pkAE7kRmCIz1wuS9Ar/dF+rskD7mhMvNw+S
	 wZB42Eu+kbc2mW1BswXZaECywXQF+ZD8Wlk6pfTQpqSCieqpe3X6BMSlntfsm2AnJbzwt
	 bhUGMXKSn88QtKhGzX66Qu9HM71c3ANqU8zs5T7802x7ovLf0N6bIt6XaQUXRv9Fs/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=H9WD2+ng;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B23606A319;
	Wed, 21 Oct 2026 12:13:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48B23606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=H9WD2+ng
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792584825; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=GabWm1gqTRhtdugyu8wuzjBRL3LxrLTh+7DBvXTyk2c=;
	b=H9WD2+ngrbzja88Gjfftxe5XHe8ujxPt4le84xvLg9QyCojGbUYQPqdPPasbJCoV25qo+47XxhBDrWeLiZm5xMsc++G4POASI2h3QPggusxxOB3AJNwz1Ab2CNxxyEde92Lqd5QQ+AdMowSUe8/00t7e8ifdhP7QGMyggF9pZZI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDGKYDV_1792584823;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XDGKYDV_1792584823 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 20:13:44 +0800
Date: Wed, 21 Oct 2026 20:13:43 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Nicolai Buchwitz <nb@tipi-net.de>, Jakub Kicinski <kuba@kernel.org>,
	alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com
Cc: Chengfeng Ye <nicoyip.dev@gmail.com>, davem@davemloft.net,
	edumazet@kernel.org, pabeni@redhat.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, horms@kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v3 0/3] net/smc: fix link group scheduling,
 registration and work lifetime
Message-ID: <atisd5Nbof9AS5yq@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
 <20261020125849.67c40566@kernel.org>
 <atgBD0t0xHnMlwjX@linux.alibaba.com>
 <1F2D6162-5113-41DE-B649-0E67F037E8CD@tipi-net.de>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1F2D6162-5113-41DE-B649-0E67F037E8CD@tipi-net.de>

On 2026-10-21 07:44:28, Nicolai Buchwitz wrote:
>
>
>On October 21, 2026 2:02:23 AM GMT+02:00, Dust Li <dust.li@linux.alibaba.com> wrote:
>
>> [...]
>
>>Are there any guidelines or mechanisms that can help with this?
>
>You can use suie and filter (funnel icon) for your driver(s). The filter is AFAIK populated from MAINTAINERS file.
>
>For me this helps a lot, to keep an eye on patches and their state.
>
>[1] https://netdev.bots.linux.dev/suie.html?delegate=netdev

Didn't know about this tool before. Thanks for sharing, really
helpful!

Best regards,
Dust
