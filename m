Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792938053;
	b=OMbxJmYH1h5Dxv/zScdaR4APbZ4OnYJSd8gDOg1Q+R4/WbdplgahfnVxHz3t7LuxE0Fw
	 adbKT41l46Xa4fJ4Ir5hCDc9STAobASKZA87h3JkcP8yYTBPx3cQvY0EF/4qtNjFck2mS
	 zdMyAnS/YynUd/2urt9k57dAD3Dvv+MVSfbJGc5dF/StbwXAKr5ikfhjqrB/OuxHaRR0D
	 KOBwrDpWZ0JR1ssp5vN9mQ9zwV9r9EKUMrO0cdEwvHIBB42ZddehG/hYLJTV6KwqfwXvp
	 cOkuy2/hkzlMCc7I3TPr/okHztaGIBOT9j73/e/BaLa6gElfK1wMvBeowfZdPjRPMmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792938053;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=RN69ObHxi3X/sOau5NnEyuslwHR1tK+r4/i/ywS22wU=;
	b=OGGsYlssHgYnhdrERTO+UFs4qaF6oPyZNOLls9ulBogoq/cqgtV9IbTSeQNIoh1QB1Ts
	 3MtCyXQZI02CE1fXhOR2mnmsolu7kOJulrJBgYnuJhwT2wfelnAVNZ1YcbY0MtYQUDSgi
	 ZtUHCTxsKDfK7FhxN0lxGigD0Y2YXAKfAmi41d7kXHiCMiO3tzHlTVWIW0uK9kGFNic+Y
	 4uIRglO0Q2DD0gFJ2wF4mQXoZMYwtvAqsXvWzB0afUaPTaq32dbTiAq0exI9pEeEANfic
	 chrs2p4ExR0Dh+81g+1eevJZJd6rBWohnNOaexk174+CjzgKOa6H+8QoN7MkUVapkfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=oJYdYZQQ;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6C5606A31A;
	Sun, 25 Oct 2026 14:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A6C5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=oJYdYZQQ
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jCJnp2pn2z1XM30g;
	Sun, 25 Oct 2026 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792938043; x=1795530044; bh=RN69ObHxi3X/sOau5NnEyusl
	wHR1tK+r4/i/ywS22wU=; b=oJYdYZQQw1LjVm2zakRcbjLrC6mnVfjOumC94Gfg
	sXUM8pufKmvr37drSBh6foA/Y07q4rdapoEgQnnxG4U+iLlL5bdup/QMn8u/6sEy
	4HAKx5OezzjJWkFpAUf03P5027q2zK4y16r8/hMnV6u4dpJDAkgFt4lLY/UO/xnQ
	m/JV58lyBn6LyUfbZ5+PQzIe0yRJ5ybxr1y+zfOnfwcw9jo30McRNL/lb7z7Lnqo
	hhw195k8OahcZ5J/Fsk5kqu3kgve2u2BTK98C1s5SlHrar2HMt7NEA5JQLHD9MXf
	TlOebnJIMf6zXtG6rz6HTWSRpkQDki7D7QD8oFK05KMRAQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KQ_r8W8dzc0n; Sun, 25 Oct 2026 14:20:43 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jCJnl2qvjz1XM4Tl;
	Sun, 25 Oct 2026 14:20:43 +0000 (UTC)
Message-ID: <7b6a0aba-9068-4ff0-8e4f-76f05ee25bfd@acm.org>
Date: Sun, 25 Oct 2026 07:20:42 -0700
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
Subject: Re: [PATCH 2/2] RDMA/srp: drop a truncated SRP_RSP
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261025114155.4007867-3-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261025114155.4007867-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/26 4:41 AM, Yehyeong Lee wrote:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index a85d28b95306a..d891029087b7e 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1946,6 +1946,12 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp,
>   	struct scsi_cmnd *scmnd;
>   	unsigned long flags;
>   
> +	if (byte_len < sizeof(*rsp)) {
> +		shost_printk(KERN_ERR, target->scsi_host, PFX
> +			     "dropping truncated SRP_RSP (%u bytes)\n", byte_len);
> +		return;
> +	}
> +
>   	if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
>   		spin_lock_irqsave(&ch->lock, flags);
>   		ch->req_lim += be32_to_cpu(rsp->req_lim_delta);

Dropping a response causes its req_lim_delta credit to be lost. I'm
afraid this will cause trouble.

Thanks,

Bart.
