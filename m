Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270766;
	b=UWR87lUS0r/+xc0ujaorI3iLLypiE1ZGlhleynukev6RctmtjZ3jDfXZY7TgnB2g9az4
	 Z7JDubxhpovUwrEpzTN/yEOwbodHMpsbQbM+hg4Vjuiy19c7Sgp+kIXEonBF/utyFbCNL
	 zCz6g4nlGCC7dfvvJPBApmE7lMYntYa2M2mo+2j/Xa1kafnEycPT5t2wyQgzoF+1wJrNA
	 M7yHUCi0YTu3jN94n6dMlNKxl29eJ1CAHbrkV6gZeslpsTd+YUCTRfrDXMiN3yYmT+7Iy
	 yCSpzWO9R4jXLOR56Z7aQqoQ4OZUG5+gZbpLG0sVp7v+HxXrw6OGK7isdkd6fN53NMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270766;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=VdvlGvHc17Ho1RVg/HbNQxMrDh7Us0FmqUHW62zV8B8=;
	b=ok0oH4FAkXNLDgXj0/TKd/EiduKYR1EXgDlvV2aG8jUZPao4ArF/auejbThyp4yGVstH
	 VwChc6LeXL990fDNvbGeIie7ZsZIWHLK/t0L8Md/rIVWHF8c3TKq7kWoHyKO/opySZwQA
	 QFcciiLU0IizYhc3Ij+6QkbVGplWIdrXVNlNhhTtGzUUCzdiseuk0hvszfJgzcb+2+XGZ
	 v788i84f8DiSy94mcPcs5eAauIZWyvKy7Rik0trciqEa1T8i2o4w/XpPSNPekQ22vZiqx
	 kfCM1NhAqBv2FCJoFo+AuPV+5cxWLY8juatJyC6k7+SqU1My8F1t2yVKvilj14hvzjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=kzWmt4Hj;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09526606A332
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 00:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09526606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=kzWmt4Hj
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91eb3fea2a9so14015616d6.3
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 16:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794270765; x=1794875565; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VdvlGvHc17Ho1RVg/HbNQxMrDh7Us0FmqUHW62zV8B8=;
        b=kzWmt4HjS0Ob3TApjhD6m0vQ8+cdTUubBft5vXUq+hRDeOLCzySITPT8uJZ4JVXqaX
         Y/y7CPrLg14fG7bh2prkBH9prZd/vZNvMjrGiZWHOALe3QoDyNHJE49AeyD60lim8y36
         fhv/x4kz+k3Xw2vrf4SxuWLSwFw4fY1UYP1d4KCV0DuTEYu8ZvULYrL9tNtMeXyJoGS4
         oTQhjAgmm+al9ATKBbUMf4lzEkaO4CEEP3Lfsn7s5BBGGh7RdU+5v2lrqbqe+MZSuW99
         zeVHFE/6A8dnibUeSMQB0Sf+AWch51fJaQSvgeqbNfCy1bT9jeBGaLefcBErkwty01/P
         rpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794270765; x=1794875565;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VdvlGvHc17Ho1RVg/HbNQxMrDh7Us0FmqUHW62zV8B8=;
        b=plXzjg4lIOkjVXmmwW3Hjy7uZOAphVnh8KbGS1tJnCjVWu39Pcw7+EHXyK0Hymltaj
         8f8PPnsn3DNj56cCJrFS5/n+WFamyCB0KOGYQh6jLL2NMZMrjuaHuaOwUkrmja8uVal3
         ysWNq5unCknjIzsOFpCYdUH566EHn0kxmgzfnQ6leHMkIPBnP5O7lk+TAjrGkOvZQtMh
         htTzNhAInswx/MbbeOuXEVxD95TkHOTREggdZ/Xj8wuD5VX3cRvoyC8e4g5rWBaYFSN1
         JwKDP92LAzyKYL8UmNnJXy3e4Blf86h1xIHu3674RmepfGWrxW2u/ZZ7lZ8aumKdwKk3
         Gfvw==
X-Gm-Message-State: APuU4Z89yCGMcMfxw6+HJQ/5MlvBqUpUez0FU+rlOL7tO2oy9zGF2YPy
	c9uCyLwDHPnf5U4XPvHZRUHOhBVHtZLrvUmdOC1jQR0gWKbRoXP16BWuQPSSCdIcgjQ=
X-Gm-Gg: AYBFou23gyHNE1lPKMlwIyjUI/EMSrNaxtcoVPTBfIBnE7/az01czxuTE38FhRNLEa1
	UfCyfZQDAKeqk5bA2f7MwfY1jvMIX3tj2dxeREt1j/eUNsthv7Bqeo2bTjxK7ZTSKRtt0QmR1nv
	p2Y5RjHOSGs5nTuNAKMNBrIA9SKIjZGg0OfasXS3co0UYksqZbKJQGPMIbvo3pFNfU87R8rLcr2
	+FjT0LCiFND7AKdAwint3Ns2p0qFIyp1sEIXQTW4ct1VChWyeG1e+NKUIdXFv9O8G/O+Rk7iRz7
	B7og4HZCo2QjYvUnM5lF8oHAIN3QX1sGFugJUnqwYDAHvnmcxzVqdwT/gGkFj8+N/fVOvAa+2xr
	QAMSvhMhy914J5I6ffgyyQhIT3wZrP7BOVcBLQX+7aBYAv4JpfF2q7fLwUYCZ6p/UZnnnOADl8n
	0HsbgFoUJy/wQWzl3IsdKthbqzD5gQ4IN5QCm/GalRfFin0EGtDn4DQo8P5dR8DK8FnT6N7nfAd
	RZ/U6p4DRhEYbiN/FgdqdLXWF4z643ClMdmjEZTUdOrS2tanG1zCWKQ6/8lGcQJy4TvwkQ0Y8cP
	ZVxdKim2E3lPWakUNFZT1ChwqDUFe1SiWJzzuhp6adMsSxcq09YcmcXJiTwpprm4wEN0DUt+a2A
	QLTf/6ZJ14A==
X-Received: by 2002:a05:6214:4288:b0:91e:9811:7a2e with SMTP id 6a1803df08f44-91eef8cf6fcmr20963496d6.13.1794270764615;
        Mon, 09 Nov 2026 16:32:44 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef050ef22sm8450236d6.31.2026.11.09.16.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 16:32:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xQZn1-00000003JiH-1vxr;
	Mon, 09 Nov 2026 20:32:43 -0400
Date: Mon, 9 Nov 2026 20:32:43 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Surabhi Gogte <sgogte@purestorage.com>
Subject: Re: [PATCH RFC 2/2] nvmet-rdma: use a separate lockdep class for the
 listening cm_id
Message-ID: <20261110003243.GS663069@ziepe.ca>
References: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
 <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>
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
In-Reply-To: <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>

On Sun, Nov 08, 2026 at 09:01:54PM +0900, Shin'ichiro Kawasaki wrote:
> @@ -1914,6 +1914,8 @@ static int nvmet_rdma_enable_port(struct nvmet_rdma_port *port)
>  		return PTR_ERR(cm_id);
>  	}
>  
> +	rdma_reclassify_id_for_listen(cm_id);
> +

It seems like a flag or new function for the create would make more
sense, and if this is the right fix then all the callers with the
pattern of rdma_create_id() .. rdma_listen() should be fixed too?

I suppose we cannot change the lock class in rdma_listen ?

Jason
