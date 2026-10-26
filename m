Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793034981;
	b=mnsrTu45v1yDhwNUnvVsygQlhc5mnpkRD6FMB5VFqkJE16aveFglLzFA+mVKZNERXcKT
	 tznJUCEiroWt0JUu4aB7R81q+32e7BxSbGuqrP64J+YeUvfS2DttheXVOPfE4Q6cobhLe
	 nuMUft9nXMe8FNj7+oHVLBR2R7lYAbgGXU+OyB6Eq8C5MPKD/eVlB8D1qUcgOfz5ngN3E
	 WdhLbAf6xK6KsuuzhjxZWFB9lLr/x+2ug/qTz9SLx80GR16SdajfEPpTo+8g8kOU/9lAI
	 mUkPanYsjuq0se1nG9XarI+fhUFwrDfYOfkLyl4kBARvX1LufKUP8qEKat0njFbfp9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793034981;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=1yPaRggC/WPyL34G0gaaj0Ytwub5nQfzFnrlcpIIAmk=;
	b=B+56Y9cLtUgEAEkr8Ks243QvKb/fStYBXFEgvMiUthHwX6rMJkE7Ggau38lNuhqH2iK5
	 IxGpatPYFHh5GYHbia59NSr0sguYAjkvNPBxh/3W4Haq0vR06fldHlZI+WZRiO9fafbjG
	 MWOtH35zBxBh8a/KsKdIbuP5DFrGm1wrPFzI5AzhTkhtQQ05yoV54cik4VldS/IYBfKEK
	 QO+9bs5n3viupmS/mIDpmu4OYAj8Kdd8yIauO+9MBdNgC7su9sXGvpgwLaUcAvCWhSQ4i
	 xXJdX2R/Uw+AChHdG8ZbhdN+wadEGb/hCpvc845wa5eQ4J8ObGiCjkihoxYivli9zIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=vrrntPUQ;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D89606A31A;
	Mon, 26 Oct 2026 17:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63D89606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=vrrntPUQ
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jD0dw65X2zlfvpW;
	Mon, 26 Oct 2026 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793034978; x=1795626979; bh=1yPaRggC/WPyL34G0gaaj0Yt
	wub5nQfzFnrlcpIIAmk=; b=vrrntPUQAYnjLfIV8MNX+WV+Z2q6gX5JwcjZdZlv
	xIh3UkxAZ3pxBLDutIk1IzNCjXarXFfLG641GVmE8/f2nx5/CimBFKHcQVoxJuBI
	r/fdSnLzU8lluh+Y6dthmbXjg80GYPkIX6lBZpLzULo7b9AVw1wATG/bk88sZ5VS
	gz9l8ferGneJMze5QrgzHdEc4rvCj/niwKnWUXTaziVYDI54wgor7ihlioLVm6PB
	tIp9UwXL0MKlIKTH70hHhazSd3EOfDiJi0YqzH/6/hTACx6eULr+M+IAvAZvEonH
	MAYBdfXSnrbs/vqTol0v2xdfJPiDX1EJ4AhATT2fwoXMHQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Q5Yc1tKok9sB; Mon, 26 Oct 2026 17:16:18 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jD0dt3PN2zlfvpT;
	Mon, 26 Oct 2026 17:16:18 +0000 (UTC)
Message-ID: <418587e0-f727-4089-bc98-faaeb88ec308@acm.org>
Date: Mon, 26 Oct 2026 10:16:17 -0700
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
Subject: Re: [PATCH v2 RESEND 0/2] RDMA/srp: bound the receive IU the target
 asks for
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/26 10:54 PM, Yehyeong Lee wrote:
> Resending as a standalone thread; the v2 I sent earlier went out
> In-Reply-To v1 by mistake. No code changes. Apologies for the noise.

We are in the middle of the merge window so this is not the best time to
post or resend patches. Please repost after the merge window has closed.

Thanks,

Bart.
