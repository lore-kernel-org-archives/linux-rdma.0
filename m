Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792864922;
	b=lEv8QGo4klOmZJQ2DjYPwfpI6xQ2kQj6AULsHLhHbv4ZpcQE7E/d9KTTfgWL18FH5Z1e
	 LKgdkF2pupEUzvh2xIznWZ+4yP0W5GedNbegdy6SG5wDsDMB6W2hzCrAeCh6hvXTvcZQQ
	 YjkiKsnFTfcMTjh/BAtFuIopmFcfx7Q8juDb88D3HWg8vogglEFbs8xJNYlhFX/RjOq7p
	 jzsIP4vTgsI8YBDRyN3rd9hKdBiYAJrhZzg4xsNd1W8HvJJTasOasXiIIlSAvqFvZco4N
	 HRNpcUghwHdQOxYBf8iuIwmYf2N0RRf5Q/ydotNag3JGylJ7DPr5v0VP8PQ5A0s6rKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792864922;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=qfZPTQTR2m8vJcBwv/t24No5oY7rJ8ZDVDVddB3dpnM=;
	b=kMGwdZ+I64MoYxEFnkgGydM2CRaWUqdcMhpTeEUIGWCRqW+mbq4Du7AAVSZTs+LURGcz
	 Rh5lcZVqydgRQGWZ0GdauXLqtg1Z412BlTxfB+E1fKVykufkJxE5xtl9Vf1mttpshUoMI
	 tp0SKVC8gf4O6s7y3qP/Kr6akoh6e2ekfwsl3kvPzgUnwm5MLBb+hBqy1SNPQVBj8lNo2
	 ij3hlI75DpAUxWkFrNBit5fT5IuEv7T3KiMaWfL4HGDv742PxUQTuSc63tixLJ1G1FQ1G
	 LalwqCxIvQmwUlc/NvJVgcvMkilpy1VSclKO+CK5gEJTzl8uB5RV4Pb9ITETdQ3BB5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=RfxfBxpw;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FF8606A31A;
	Sat, 24 Oct 2026 18:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31FF8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=RfxfBxpw
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jBnlY4Fqmzlfvps;
	Sat, 24 Oct 2026 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792864919; x=1795456920; bh=qfZPTQTR2m8vJcBwv/t24No5
	oY7rJ8ZDVDVddB3dpnM=; b=RfxfBxpwFoeFKCOw11xLP6AG0hZkuDC7u5jx9aFE
	qL2fM5zJhHeKTpukHavWJVEhfvnMBQQ6pQwGfI37Y3fwzpiMeZ/3JmcUb1UcI3bP
	iUrBKiky4nAaPHSdgRnLmQjv4vOkZ63z+gSj44aP+3bJKsjcJ/lo0C1xo0umsfLQ
	SWewZJeAGZfLqlcX6oib6o04B26rMfgbeN0NJmJZ1xHm9FeUt7inAF2yqzazCzq+
	CIQITAL73RGpiHPsfzqSTwL3E21hBmHCvkQ8ubfHWxN9xiGJxnoXbvAjigki7k2J
	teQJmnqliS0kxy2EmT/04MlbpdAJ6amKeoCtQFIYNKIG9w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZUd5Y4n7ddQ1; Sat, 24 Oct 2026 18:01:59 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jBnlW2Y40zlfvpN;
	Sat, 24 Oct 2026 18:01:59 +0000 (UTC)
Message-ID: <01fb5172-3f8f-47be-99f2-20f2c9a5244f@acm.org>
Date: Sat, 24 Oct 2026 11:01:58 -0700
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
Subject: Re: [PATCH v4 1/2] RDMA/srpt: bound the indirect descriptor table to
 the IU
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
 <20261024162852.3528224-2-yhlee@isslab.korea.ac.kr>
 <sashiko-outbox-183819@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <sashiko-outbox-183819@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/26 10:06 AM, sashiko-bot@kernel.org wrote:
>> +		if (desc_off + sizeof(*idb) +
>> +		    (size_t)nbufs * sizeof(struct srp_direct_buf) >
>> +		    (size_t)recv_ioctx->byte_len) {

Are the size_t casts really necessary? Please remove these typecasts if
these are not necessary since in C code typecasts reduce the ability of
the compiler to perform type checking.

>> +			pr_err("received SRP_CMD indirect table (%d descriptors) that does not fit the %d-byte IU\n",
>> +			       nbufs, recv_ioctx->byte_len);
>> +			return -EINVAL;
>> +		}
> 
> [Severity: High]
> Does this check actually reject an indirect descriptor table when
> idb->table_desc.len is smaller than sizeof(struct srp_direct_buf), as
> described in the commit message ("and so is a table_desc.len below one
> descriptor")?

I think that Sashiko is right that a table_desc.len below sizeof(struct 
srp_direct_buf) still gets through: nbufs becomes 0, the span check 
passes, and srpt_alloc_rw_ctxs() returns success with n_rw_ctx == 0, 
which makes srpt_write_pending() call ib_post_send() with a NULL WR 
list. Please reject nbufs == 0 too, so the code does what the commit 
message says. Also, please consider struct_size(idb, desc_list, nbufs) 
instead of open-coding sizeof(*idb) + nbufs * sizeof(struct srp_direct_buf).

Thanks,

Bart.
