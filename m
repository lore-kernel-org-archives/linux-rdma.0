Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966543FFD
	for <linux-rdma@vger.kernel.org>; Wed, 20 May 2026 00:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779235663; cv=none; b=BmNB7bIzb4SwC9ixnWPnoSt7rtjKZs/FejQ3SkTBPvdx0cPtFJszXQbkXgVj33wJGGy5re3XDFcVDx+EYJu9cUyF0ciSWMzOshqdmEPOUdYjG7mnq8DhQ4/JzsW7/GDoIpAo2GSv359Yam49w3v2RG4FgFXYeYoEe+Q0BXlrPwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779235663; c=relaxed/simple;
	bh=2FoxEkHUt4qACFP8F93e3ISzMsLxT1o9j0/jALd42lc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kHdtLbXRpfqXUfsm6ET+cZJp1nonyWU5gFyR7co2A7S1d21mJ2EzsRT6RYCmKmAZhXWzupjG4n+z9UzTStwiHPxOC+NgV/ZkWYFFw3xmdwIY6TFmNdpr6Gt2aVKneJ2AtGt8kYD81a/wFf2PRSSsTgt7in8Eh7CBXaoXI/BYHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZEEjXqQe; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZEEjXqQe"
Message-ID: <6cb1092d-e3d6-4596-92e3-e0c7030680af@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779235659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ci2X4KHTZpQUeGxUn9r9ic3tbMQhgf9+uX56j35MnJA=;
	b=ZEEjXqQeE8gleOk5Xa2h8TmnYxH6oeWfJcSUYPD85xWgyyQ4zpBFDuTOuB/Aodmvh7neZ/
	U1aCuLRyv0bJmW1ow1VV8WbeHO/H962Gr0FKO10rEvPRTnC9XA7IZ8aAIMeClbC1YuXV++
	3YwAOBIIPhudE/D5vWeXpMzM0xUlxko=
Date: Tue, 19 May 2026 17:07:35 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] RDMA/rxe: fix shared memory TOCTOU in receive path
To: Tristan Madani <tristmd@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 linux-rdma@vger.kernel.org
References: <20260518215040.1598586-1-tristan@talencesecurity.com>
 <0ae59679-5cc9-48e4-87e9-63299684acf8@linux.dev>
 <20260519145610.GA33515@unreal> <20260519150042.GL7702@ziepe.ca>
 <6a0ce47d.096dab79.284c84.5b30@mx.google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <6a0ce47d.096dab79.284c84.5b30@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 5/19/26 3:30 PM, Tristan Madani wrote:
> On Tue, 19 May 2026, Jason Gunthorpe wrote:
>> Simple misbehave is one thing, but if userspace can hack the kernel
>> and gain control of it through this shared memory then we have to fix
>> it.
> The non-SRQ receive path in check_resource() sets qp->resp.wqe
> directly into the shared mmap buffer:
>
>      qp->resp.wqe = queue_head(qp->rq.queue, QUEUE_TYPE_FROM_CLIENT);
>
> No copy, no validation of the WQE fields. Every subsequent access
> to wqe->dma.num_sge, wqe->dma.sge[].lkey, and wqe->dma.sge[].addr
> reads from memory that userspace can modify concurrently.
>
> The concrete problem is in copy_data(), called via send_data_in().
> It re-reads dma->num_sge from the shared buffer on every loop
> iteration (the dma->cur_sge >= dma->num_sge bound check), and uses
> sge->lkey for lookup_mr() and sge->addr to compute the iova for
> rxe_mr_copy(). A concurrent thread can:
>
>    1. Increase num_sge: the sge pointer walks past the WQE's
>       allocated SGE slots into adjacent queue entries, and the
>       kernel acts on whatever lkey/addr/length values it finds
>       there -- all attacker-controlled through the same mmap.
>
>    2. Swap sge[].lkey between iterations: redirect the MR lookup
>       to a different memory region.
>
>    3. Modify sge[].addr: shift the write target within the
>       resolved MR.
>
> The data being written is incoming packet payload (attacker-
> controlled in loopback), direction is RXE_TO_MR_OBJ.
>
> The SRQ path already handles this correctly: get_srq_wqe() copies
> the WQE to kernel memory with memcpy() and validates num_sge
> against max_sge before use. The comment there says "don't trust
> user space data". The non-SRQ path has neither the copy nor the
> validation.
>
> The race window is not tight -- the shared pointer is set during
> RESPST_CHK_RESOURCE and the fields are consumed across CHK_LENGTH
> and EXECUTE before copy_data() runs.
>
> I can provide a reproducer if that helps move the patches forward.

yes. Please provide a reproducer.

Thanks,

Zhu Yanjun

>
> Tristan
