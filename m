Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27EC257845;
	Tue,  2 Jun 2026 20:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780431548; cv=none; b=KwqAzrHSmvH/ndqmH0eU0NsKUoh6Wpf5RigrH9mca6btossmHnVV0x1kCcceiRRaDsjt4ksGq21zFqKxtUJfR6CsuRB8DN6dKAyRFselo3x7em8mx3me7B0PEikO7VDXkJTTml1ptcYPhQToQQV3Bb3eXL6dVDor79h9y/78mcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780431548; c=relaxed/simple;
	bh=8pc7W2Fx61JwhsaRB4XTwFp7oAT5JXs7QnVCFyCEhmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ts2FRVSpxUDQ709O6zryLcswJTAGUVMLFQPHUKCK35tXvWCy+7jsfmSKx9tMapNoweZY5VHij1cJFTa1QVbEsFIevy9Pmkl0bke4S4damp1bMcKM0X92EseBg7RRkBJqjP7ZJzJJxOgcDDAfI8NJ6grHB5wyzzH3tHof2mOiapE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=j59kU3Cz; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="j59kU3Cz"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gVMcB2XtNz1XM0nw;
	Tue,  2 Jun 2026 20:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780431543; x=1783023544; bh=cBYfPAFTtljhsjATWYc9vtTo
	mWq5xnzO4aI9CNrDhvw=; b=j59kU3CzsQ4tuH9H7BD89qJ7XAweUPCJEFfOZshp
	NHRPnYSncE2jIn9W59VgcN2v/hUFl+amKzNdOmQff7UzpTuW7Toqh97ezNbhofUo
	un9GEC2dioTon/HXgsKIDiT5bJTtrfKHerIWAouzw7Qoe/k7PGfD1VA0kLbWsipB
	abrgheyUvEd26xLThOjJdlazpZ3qWj6Y48nJoOrNrDjEVDvPwqu7qlDX+PcaE0lR
	ShrgwqrHhjFMch9eus23yBbbjjlwcRnNrSojIS6Wnad9ZKkqR1JMSX8sDLxAP+kd
	biFw8LIDH0oQQxo/TxsO9f6p1ZQkze/nLWIoRonwgu028A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3FV9BES_FbwC; Tue,  2 Jun 2026 20:19:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gVMc56sHlz1XM5kY;
	Tue,  2 Jun 2026 20:19:01 +0000 (UTC)
Message-ID: <5c9e3206-f3fd-4e5e-b08a-66dd93b0d2f1@acm.org>
Date: Tue, 2 Jun 2026 13:19:00 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srp: bound SRP_RSP sense copy by the received length
To: Michael Bommarito <michael.bommarito@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260602194619.2272486-1-michael.bommarito@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260602194619.2272486-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/26 12:46 PM, Michael Bommarito wrote:
> A malicious or compromised SRP target on the InfiniBand/RoCE fabric that
> the initiator has logged into can return an SRP_RSP with
> SRP_RSP_FLAG_SNSVALID set and resp_data_len set to a large value such as
> 0xFFFFFFFF. The receive buffer is allocated at the target-chosen
> max_ti_iu_len, so the copy source lands far past the allocation.
> 
> The memcpy then reads out of bounds of the kzalloc'd receive IU; with
> resp_data_len near 0xFFFFFFFF the source is multiple gigabytes past the
> buffer and faults.

The above is misleading because it does not mention that the SRP
initiator copies at most SCSI_SENSE_BUFFERSIZE bytes sense data.

> Pass wc->byte_len into srp_process_rsp() and copy the sense data only
> when the response header, the response data, and the sense region fit
> within the bytes actually received; otherwise drop the sense and log.
> The in-tree iSER and NVMe-RDMA receive paths already bound their parse
> by wc->byte_len; this brings ib_srp into line with them.

This sounds weird. I'd write this as follows: "... copy only if the
sense data has not been truncated".

> +			else
> +				shost_printk(KERN_ERR, target->scsi_host,
> +					     "dropping oversized sense (resp_data_len %u sense_data_len %u) in %u-byte RSP\n",
> +					     resp_len, sense_len, byte_len);
No, in this case the sense data is not oversized but has been truncated.

Thanks,

Bart.
