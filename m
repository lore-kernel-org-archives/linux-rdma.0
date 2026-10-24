Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792864972;
	b=SDTC76V8blqvfYG314+QXqOpv6js/U4uvuG0WOaehECpTUKOQYGJMPc3e7rwY8UsHi2F
	 s1E2m0sHahqimMjzRlmECiGgNcSl9Wc3q+CaAQH0k6uhHDnsEd5ZUUlF3hBl9PVZ3RLSx
	 llyRbOTumg1z8k5k654yduEoHky47MFbize0XZUvMKhV28svpaWUISRPeBZub5T5tsd6J
	 /P4TYjB1SjGnSAoIqMnBtPoB1r0HMdy94LwOuOH4LAD0vR8BfkxnCTS4yTLIaIWtsRF0L
	 Et3FZ3ZWwXE/y273OD3+7fdCcKSK8J8HBgjSrmzrSWQTddmszA1SzvPmlC/HEFLPHwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792864972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=eIeVJTLozSdLbIKTdmQoMBob0wlVQZIBGS5B40KWhyU=;
	b=pIeGfXR2ygqGnLMhuesASThmpgSlZnpUwClho0DYgUX67c8TQCfSbVWlF66TrrGvK60h
	 aHBnLFZSvdPJBTn+oE2joCHwoZbpyAYcP4aKzErmEIpyEjBaEaH1DGV1VCS+QLqzqw8ZR
	 SBLuWi5ZkQOVYF95ATybylzLQCb161Bcd33m/Uijq4qkAc+lu+6VaC2YBIUPaey4NCvsD
	 ot4BGvPGumrXFaxM+5Lh5fOug58YpWocLJ+jvxcejKKRwq0z6jXvMplpb0xaWDbboAzj0
	 hAiJf+UgKLfqvE1Uf5DOQz7OPdQOsInXe9MgH1islA0i5lraup0lMq1OW+1CluDgfqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=IRccZDxo;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4034F606A31A;
	Sat, 24 Oct 2026 18:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4034F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=IRccZDxo
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jBnmW5x6Zzlfvps;
	Sat, 24 Oct 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792864969; x=1795456970; bh=eIeVJTLozSdLbIKTdmQoMBob
	0wlVQZIBGS5B40KWhyU=; b=IRccZDxowA4GvZGH14ueAYLz8AJ+ye9v8IXWvq8+
	s2Ms7MOTVIJDBz8Lqyex5Daz4zM2rKTGPnT2EgZaWZMEbhKh9X2Z0JlcI9jpEda7
	3UnZ4mWn7XhqluMKncDVgWmujOFlbtL8m8Iiga2kSJn6BYYRwhFV5/fZj+De+yJK
	+Z4TpESdHOMijUavC+vY1Lxb9IfugeULK5ZQWj/6z3FIkGToqJkDV/Kj80b/QNoO
	vQTzLpGvgT+OmSAZyUu/8XeJZSyJnIq5LrwAgviHEY6ufNgENwwbryrLAxVJfg+e
	3VZgoTOEo8U/4euXH0IS4j9nfhk2GEf5hLZ25SN6UasU9g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fZcaJXGGZAEK; Sat, 24 Oct 2026 18:02:49 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jBnmT0TQYzlfvpN;
	Sat, 24 Oct 2026 18:02:48 +0000 (UTC)
Message-ID: <75465b8f-1109-4a83-84ab-f4b464f187e3@acm.org>
Date: Sat, 24 Oct 2026 11:02:48 -0700
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
Subject: Re: [PATCH v4 2/2] RDMA/srpt: widen the indirect RDMA context
 counters
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
 <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/26 9:28 AM, Yehyeong Lee wrote:
> Make both counters int, the type the values they accumulate already have.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
