Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706227;
	b=yLm7ENeMxPNliS3wbvN7DLUgva5ocyDMUknwNmKFPIsBmlwZKlGjG93odNq5tpqNLc2a
	 EeQ1jrh6JKqfmj501qIs5kQUWP/qt8O8WfWCcsHH7u2vnU4S2AhQZGUFVn2g1rDXZhvMM
	 C8JBVb0wrcMZSNKImy4jY2aLMncB1+/ZeaAbbr/6LbqWQtaRGP6nCIpTFtJK3UH54QmdG
	 z+/MzeOC4xZMoM/NmNy11mscTczWuHM2KnVj+xIx7u9S2JiyzzHRV6jhb4wbY1kbquCDf
	 1zZgZfXVEVBsTXqn+NF1JmKbGol7f/JBAdq/HmXuc7Tc47foGfJYKzwORBuqcI00ZIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=tgtlx4NMqS10ms61luKx47rdjQPmLcLUwVEPmpsB7nw=;
	b=IwybVkPElIouYM6YrFenqHgLypRr6+nI6Di9zH5OQnJffP58N9CneFZHss4O0IlfUe+a
	 TrQY97sLZZvBPjDN++ujbQ0qgi+jIbYhfmImnQTOMvXKOy2yIAs1WCvdb8rRphvfqmfgb
	 z1QurpPVRUzc8mJDCMb4K0gOfBXmFHYynwjkkLw5HLZCys80gNpxh7bmpbV8Dz5eGtwmi
	 uM24CTOcXTUEda/6K9EdBzne5b+0jW5EOBJZfAbs3bLJQIuwNSdqHTYwv2uyU6EbP5S4Q
	 cSVURfLTUPNp3rQ05V19OkyVF0STXLa6wJenpTJu7GUsVYTn1yZibP5gTPjt5elJBGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Lgj8JxzH;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC24606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 15:17:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CC24606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Lgj8JxzH
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-55d846e884eso44125301cf.2
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 07:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795706226; x=1796311026; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tgtlx4NMqS10ms61luKx47rdjQPmLcLUwVEPmpsB7nw=;
        b=Lgj8JxzHME6WRyO42EXjOwFqtXShGWOSbbZUOSElpVywVH//VHeT+b/D+kkHM0j6vi
         tzjKM5iLJeKDtyO5UXXIC3iLflw1Q79Uh2ZB5YhXzn7W5XRfwDB9ZEuZ+tdHNlQbn/a9
         BildDDxbCkxIOCmWxTCeaSK/UetRr3GrHrwJGxIczcmxr8OTSPd9+9gOFOOyIJ2TZaRx
         5h98xhXnzh2+zkXKEbiNhE+VHKAX2sAkEOzD9q3H7aJPbOgS+8tB0U9gmfvWtFx0sU1O
         tykhLDuJ96m5PRgtQhn3zn9lBD8PFZ+5XTV4oLntTbE/bNu6gPOSXmNoBymwrX81wRmx
         jKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795706226; x=1796311026;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tgtlx4NMqS10ms61luKx47rdjQPmLcLUwVEPmpsB7nw=;
        b=dy5jlbXuDMC/CD8dbQZJjd4ei+Mb/9PaewtSPxryovffDA6cT92fDMUsGLYorMSQyd
         iifzeKdT7WLSKmDabiYIfeHlBIZhtzqXyeT5zgLhzGSG6Z7aAtx8dMbx7hl8EkB7JOFl
         L5R/HHwJYbbjcFA76UG3NP6wv7Se5oo61ItcXlrSpKipKrFMIQSUT3jF0wGlcInSb9P+
         kUy8rX928lAf33AHUiUYLmqIt4CY9YspsZXEByx0RC+TOShZBJJSomiiRtCVmxWviUEv
         tACItvg4IJHPFbrK+NXGKLy+JEFtkDSfUluN27/6PWN1TOn2nw44hBJoE9u5JPNV4k+a
         j1jw==
X-Forwarded-Encrypted: i=1; AL+hErGy4u0z682GwLtm7RM0AoLnsGSdLiyyUtsqOG0rY0EwLbGxFIZo2FzIngNdxXdKDzlbgWxbYJ2Itccg@vger.kernel.org
X-Gm-Message-State: APuU4Z/zdzTmRU7GGGj0femZEPVDUvx1A+ze+o9pVw35dR1yQ8Kmms5k
	9ST03I1uXUPzRQQnHN2V3Q1SEZvOAiMIdsnAOWGCHl3OxViCi9TVSdKzpnvUZcUVmVo=
X-Gm-Gg: AZFdTZc5gWXK/f0r1zY6s6Qg8755yapJZXL93NwEOJWulbEcGFnyZhTDnwYIZCFKLXF
	ZyUr454Vf15n1Vix4sjDXW6U0kaT/hbOtuakLS5uRHk0YVwoHXr7ft9QFpAUWnp9Jsj2jrMHAaT
	4G05fTOkqXdRj+QnW+XOa6ZVEF2Q5179CXvha6PP1f/mlJub4BlcTRE+kxK4tYx42tzd5iFUiTE
	YSJoSeVrL004zW0H99Uo/8VzJBGnMzHnbxC3sEApSkiMU2xWzuyx3m016VGCx2RYGun4vVP9Rha
	+jd6VYmSm6Rmj5EpSBQhoLP/qSpgDC7QoWmE8gfO6Nl+qGm8yGNWALZ/dfz60ocNK0geK0aVYcJ
	bhLeYTPxo8yxrP45g/RRhlykHmMGmSDTti3f7oVxks6GFdHzwietZy7QPOeF88MgFjQ+oweR/aO
	tiBWQOIbGojeVBR2qvzZAJ7dyXzbIX3YrwbfSM3EwANEQFYd6RbqhWUpbvOwXQB/VCcagHyuUPU
	vI4md02eow98iCy5i0ZcvV7MiJG+i+hTHy9HYztOhVYrSP1ZciCm+b5qqgGWzBT2MKfx2dMyRuA
	F1Zo/Q==
X-Received: by 2002:a05:622a:60e:b0:55d:324a:8207 with SMTP id d75a77b69052e-55d76a4f23cmr396621371cf.29.1795706226390;
        Thu, 26 Nov 2026 07:17:06 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55dc8895beesm6928491cf.11.2026.11.26.07.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 07:17:05 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWbDd-00000004Ns4-1bDr;
	Thu, 26 Nov 2026 11:17:05 -0400
Date: Thu, 26 Nov 2026 11:17:05 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261126151705.GP246011@ziepe.ca>
References: <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal>
 <20261124143024.GO9566@ziepe.ca>
 <20261125090309.GY14811@unreal>
 <20261125144521.GI246011@ziepe.ca>
 <20261126140511.GP774860@unreal>
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
In-Reply-To: <20261126140511.GP774860@unreal>

On Thu, Nov 26, 2026 at 04:05:11PM +0200, Leon Romanovsky wrote:

> > > > It is not a security mechanism to hard guarantee that rdma-core has no
> > > > bugs.
> > > 
> > > It is you who talked about "... security downgrade ...".
> > 
> > Yes, in that I want people using normal software to have a safer more
> > secure experience. Meaning you need supporting rdma-core if the kernel
> > is in adversarial mode, because otherwise you don't get the right
> > security outcome.
> > 
> > You took it to some absurd scenario of a user hacking their rdma-core
> > to defeat the check, which is not the point at all.
> 
> No. I'm evaluating each newly added UAPI field passed from userspace to
> determine whether the kernel needs it. In this case, it does not. The
> kernel will behave EXACTLY the same with or without this flag.

Not at all, the kernel will accept an old rdma-core that should not be
used in this mode instead of rejecting it. That is not "Exactly" the
same and is the behavior this is all intended to create.

It is simple version negotiation and since this is security related we
do need to do a minimum to help users.

Jason
