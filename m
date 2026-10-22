Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684629;
	b=09maRbRdhbdvrrA3YKHxoa8LcffcWuZwRIyV49jjLKICpKCBElA2mXQ+rWpcCqcomuZo
	 tcAtaGYgfGnRmdB6LpjjgAsVFlgSdPDEfEtlc8cT0NZ+9TbvqjZM+uUD9Zte0NK/GMGNT
	 IAPHqugfaREqHUGcVhNj9L/tbLaw1UY8axNloPBh8+DfmpJ33YwP9cqrKZqCA3xPJ27pR
	 BjexXT8gQBJZIYeTpTNtm+ZCOktuPDfxZbVYrUbESK37/bpDqTOHXG2aKiTMCaLGZk/ja
	 oyt9V7lfSpaEH9FDALJLwNFkhFKjfHLJnA71pkZrziRSH8pAMw5Lpzhw/tmVmSSHS4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684629;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FX/sU3FBedZKsYkZYV38KBHElp5MTIf0KxoEfx1Y/RY=;
	b=RDcLuuOsTenntf/cfvInCNN6jfzwYGtg7gkGjiKfG36amAth4DqvviycL5WkK1RCgnNA
	 Ie9MeDVpqpfDgyHg9Z/CXqRxkW2xMVCKtoN4gJ9QCAKKGljyRpTHaOH8UGKL4fPTkL5Ka
	 8YQVZxqK89sWU5GyL21JBTcrYizojt1q1V7/QiuTpxh6k3pcIIvlWbR1ewy64tY5NE361
	 RYbVX0llDVIyteD2Sl9U2q/bD3g4K3W51Q8wSKuRY7wSI2jYTo/uTfajuwdIdcsmn4I9k
	 W13W/c207LaVBErZwZt6G8qq7bOvnum6o91md4Hy8DXVtapTf0xo7v0x80+ZjewUOBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="DIS/zmcX";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3B8606A319;
	Thu, 22 Oct 2026 15:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E3B8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=DIS/zmcX
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j9W4N3M4Vz1XM30h;
	Thu, 22 Oct 2026 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792684626; x=1795276627; bh=FX/sU3FBedZKsYkZYV38KBHE
	lp5MTIf0KxoEfx1Y/RY=; b=DIS/zmcXbCt1BwILH255jWVcBc6m9gM7HNq9VI/4
	e5o3U163TDXtnQUZXxvB92eZVdHIvvPxVi1zr4YZLXjU+2FzfmVk19ax1hxR2MU6
	5aozhp4P5xXOQmRR1duzaQZvZ9v6j1FgMEEfbOJSRjnAGQNOSv84VwHwfcCF+/Ji
	TY6NaTVg3tx7A4XKzYa63rh1X794Q6QWni67K5p8YcOYTY1Gt4HMjdDGIYYNKIZ5
	sljKcQthdhsn6vea5O9t0rWgRVZOGmizbdITy9P/BOX9e5wqwReNEyNqwFMLebi0
	ayl9+Gfgtdk1ZnyOuwD5ESsM4P+P5imwg70QdB56f5HOsw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ogSJCXhAogOe; Thu, 22 Oct 2026 15:57:06 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j9W4K5SsTz1XM30g;
	Thu, 22 Oct 2026 15:57:05 +0000 (UTC)
Message-ID: <65d23010-ca3e-402f-8384-732678b6ffb3@acm.org>
Date: Thu, 22 Oct 2026 08:57:04 -0700
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
Subject: Re: [PATCH v3 2/2] RDMA/srpt: widen the indirect RDMA context
 counters
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
 <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 7:39 AM, Yehyeong Lee wrote:
> Make both counters int, the type the values they accumulate already have.

Why int, which is signed, instead of an unsigned type?

Thanks,

Bart.
