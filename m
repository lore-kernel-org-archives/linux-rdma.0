Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601890;
	b=u1osFgkw93LJS9+TsKzujKCqF4mfqvK94YeEa1JxlddHV6s2B4FB7A8NJSjHBoF2JywJ
	 h2r+hcCz7uGNSpGM5pbTAX3ZgbF/2BauHzenQdM7LhVwrHciVsaXfAJ0oObY0wDrhISQh
	 p2ZHvBcigrSCdFT6YuKy2BFyDRfMn7WU/CM3nucq19Ichgj/kGSeF55Q6sNLk/u9wJWBt
	 C6csXOuPFbCjD4awhN9y4a60O5iFTh6bKgmez1o3N4f8gJbiCmRkKEbARK88QXMXJ90fG
	 kl1vHr/6Boaz+T6YmdRVnVJDm7YfZv4D8sv+Iay3VjyoxwUdYpdPqUQcTRmMf7PB9pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601890;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=nj+iuLYFqPKGLuk1V/E9vvGG8pcq2PgpgfmlaoYvIbU=;
	b=MjalNkNbx4E2iSbZVPUmKcydfe+BWUSdFNYs84okxLLkzIf2lt7Ka3dvzFmFGdWQS+/E
	 8btbs2NiDOd189S1wJRHItIVOuXiY3geLkTXvCLlqNM7rUvNl4JNja8y2avNm4NCz7D6b
	 J8njtY4/yD89aBoO7kU+n85XkJSe4uEZ2bilQB0DvxxtPZS+u46+1G6WOyzg4OnurnaVQ
	 2pBmeko/u6ZPqmp2BXlpL4gNrzVOnnSk4wfLagKBm0dQFzroAsviOi5o2r3QRCr1LWH0P
	 EHXoLRJfvoTV9eb0PRrEElCHzrjc4BUIIeWsHoCrH4nCvETqw/rIbmX5n4W1cthX/nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ebYM3BT8;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702E2606A31F;
	Wed, 21 Oct 2026 16:58:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 702E2606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ebYM3BT8
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8wTD6HKtz1XM4Tn;
	Wed, 21 Oct 2026 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792601885; x=1795193886; bh=nj+iuLYFqPKGLuk1V/E9vvGG
	8pcq2PgpgfmlaoYvIbU=; b=ebYM3BT8/5SXWwxSowH0s6PNVJJ5u/gKE5SoZdYR
	ht+0xF8xJOpcPK8tXjOD4KZ9Z6FdmBuftZOS8TDHcdbzCStGutL9IWMF9G0AVHtD
	KApB3LoGtS52PMHf3gE9sTXlSRtIs/8I+pB/G9Rdn45+RyIwoJuiD2MdnOOj6DSo
	kaCo9JxCX9mkdVldJ93qHi1/jBLW/2hzaPQhKcG5Wlc9hhQJ8Zx8WoNVDV2aGUwF
	G9S/MV+0XFRpOJ9/DYAzKD34eOjbFFFyJrCTp/YXkgKjXHdg6ECBZYkIrpe1UPRA
	aHcEYfwQO5Uql8XbVmg1ms8W/s51LCxRp2JCiBTTt4VYmg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mJCtlsC6kclW; Wed, 21 Oct 2026 16:58:05 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8wT90Z3bz1XM4Tl;
	Wed, 21 Oct 2026 16:58:04 +0000 (UTC)
Message-ID: <266b742e-5568-421f-a861-945e6dd54eed@acm.org>
Date: Wed, 21 Oct 2026 09:58:04 -0700
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
Subject: Re: [PATCH v2] RDMA/srpt: bound the indirect descriptor table and
 widen the counters
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 5:18 PM, Yehyeong Lee wrote:
>    BUG: KASAN: slab-out-of-bounds in srpt_alloc_rw_ctxs+0x6ee/0x950
>    Read of size 4 at addr 000000006318205c by task kunit_try_catch/33

Some feedback about this patch:
* Since this patch fixes two separate bugs, should it perhaps be split
   into two patches? The fixed issues are:
    - The missing bound on the descriptor table goes back to
      commit a42d985bd5b2. The original code did `memcpy(ioctx->rbufs,
      db, n_rbuf * sizeof *db)` with the same missing check.
    - The `u8` `n_rw_ctx`/`n_rdma` counters came in with commit
      b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE
      API").
* n_rdma can overflow without many descriptors. It is the sum of
   rdma_rw_ctx_init() return values (work requests per context), and that
   can exceed 255 even for a few large descriptors. Widening it fixes
   more than the commit message says; please mention that.
* The `idb` header ends at most at offset 320, and `MIN_MAX_REQ_SIZE` is
   996, so reading it is never out of bounds; at worst it reads stale
   data. The extra check is fine, but both checks could be folded into
   one, placed after the existing descriptor-count check.

Thanks,

Bart.
