Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83E23D955B;
	Fri, 17 Jul 2026 22:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784326482; cv=none; b=ZHCpBfW67Wy4xbOhDpjn9f4wZqpgyCuRSv0SKYj79GpJriTLXSWeShcLu9nlkYfwWk1IWShMywmYxnwcEWhEXe3clMZzqOd561VWfKqQ1T1V1Lq8RDFGhtllwkLhfWUJO0mZYErxhLhfqY4ydXN55vn1iwDJxBQrH1x1Se4GUXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784326482; c=relaxed/simple;
	bh=FfMxDUrSdhWAf6OR6jQrQ6w9/VS83JRakkNOo1x64JQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9isLS6hNwiXwxxqyc0GD2GaZ7kFbJgRyiNJLwmorSNenl9zxq+yRUVq8yErORwZ5y0kFB0vVLDsKPWe6WMG/UoyL97uVXYkyRn7RSW/v4AEgg+USjDSUhkXm9DcNCQ+R6T7Xyy0iGWn6U+XnXiXtSVKeM7St+Fb1lS1DyT/3rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Wrutee8i; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Wrutee8i"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h242m2STCz1XM0p3;
	Fri, 17 Jul 2026 22:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784326476; x=1786918477; bh=Xe8CKg0qGwTZ35OCNQ1sXkC6
	T13Z2+hE48McJ+l7AHs=; b=Wrutee8ic+zeFMcdwG4aKniiUXcskm90Oh7fq6tY
	4l3VL1/DkF6FOKVKdFCH8xJUEeRU96AqflaxBX0lgMfEz7Qh9ygqsLbtYKKUr/Yo
	gAORnAI5CLSm0kr9N65xr8GSTKwHMiCR4Nf56Qssxr+Nq1OL8NBp+M6NtqgiPQD/
	pMZKRYNVidP6NA/t5WMr462pH0Jq6z4sVNGAGwNK3PfXq09TmyUl41ZWHdGcfeyT
	KsxsvjhrhjViDosIQ31LcXu2HKC7DMoYSO1vq94V3P8YMxv15PUOzAoCqpYtqpTI
	kLQomUe8ZjqlcivIz7zCdpkQ4ed5rd/77LaDN6hNsDyLRQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FhdtpCaa3grW; Fri, 17 Jul 2026 22:14:36 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h242f5v9lz1XM0ny;
	Fri, 17 Jul 2026 22:14:34 +0000 (UTC)
Message-ID: <0ff08421-b325-4d5d-adf1-e6ae94516b39@acm.org>
Date: Fri, 17 Jul 2026 15:14:33 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
To: kensanya <kensanya@163.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 TanZheng <tanzheng@kylinos.cn>
References: <20260715101550.45345-1-kensanya@163.com>
 <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>
 <386585bd.1730.19f6dcdb6cf.Coremail.kensanya@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <386585bd.1730.19f6dcdb6cf.Coremail.kensanya@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 7:00 PM, kensanya wrote:
> I have a question about restoring n_rw_ctx/n_rdma from local
> snapshots versus clearing them to 0 on the unwind path.
> 
> Looking at the call chain:
>    srpt_handle_new_iu()
>      -> srpt_get_send_ioctx()   /* sets n_rdma = 0, n_rw_ctx = 0 */
>      -> srpt_get_desc_tbl()
>           -> srpt_alloc_rw_ctxs()
> 
> so when srpt_alloc_rw_ctxs() is entered, both counters are already
> 0.  On the current call path, assigning 0 on unwind seems
> equivalent to restoring the values saved at function entry.
> 
> Is the save/restore preferred because the loop starts from
> ioctx->n_rw_ctx (i.e. the function is written as if it may extend
> an existing allocation), or is there another reason to prefer it
> over clearing to 0?

Your analysis seems correct to me. I misremembered how the code works
when I wrote the message you replied to. It was a while ago when I
implemented srpt_get_send_ioctx() - in 2010 according to the git
history of the original implementation
(https://github.com/SCST-project/scst).

Bart.
