Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6229C35836A
	for <linux-rdma@vger.kernel.org>; Thu, 12 Mar 2026 11:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773313452; cv=none; b=EKjwnXOHqUo9coEnwQ8MjMlS0MYUwwV5c9yZHu9d5NgnTpLgwr1uH6pkQY1iZqwQW4sfiCZUuxfB1XGb0V/GgxaKuF9Mp/FyQBlvFtMuBaTPBm3EnAN32TvdTm4sp1RiOoB/5xaA5O3YO0jDQHNGeLQmhkB79NikGt13gZ/IlmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773313452; c=relaxed/simple;
	bh=AGpfmJFxK5PxlACbbcHQUKhEk/a6Nj1sbdWpe5HegsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MT/XBH6M5ispO0dXnfiIHHn/JrIxlildQZUfSpT+FydMSJVf303gyGZn0lhrrpYsEq1L0jMbjSSGRlUmUDO/XOvgEkGKNo/cmqVkomKgveqqpDj/+EQVDchBWv129D3tDY2wdZxECBFzrA6YkpKgsFv8jnXTTOwKXANAr+QgNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DcLRGgzN; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DcLRGgzN"
Message-ID: <cf3bbf89-0bb1-4c58-b78f-37afdb2ff99c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773313449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AGpfmJFxK5PxlACbbcHQUKhEk/a6Nj1sbdWpe5HegsM=;
	b=DcLRGgzNCwq/u8nCkjTe9/TbSD9C145ONZ/euOj4YooX8kbgBJjia/2E3IhRQxP8cPBUzL
	Yz8j4c+BWsRScRHndRPNsE40Blft8si2yV7of93yQWmFCOh7EF4nGIr24lp6yG9zcVEugc
	tN9aVrxvQSY4Pvqm+HbZhqWeGe2HdMk=
Date: Thu, 12 Mar 2026 13:03:59 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 10/16] RDMA/efa: Use ib_copy_validate_udata_in_cm()
To: Jason Gunthorpe <jgg@nvidia.com>,
 Abhijit Gangurde <abhijit.gangurde@amd.com>,
 Allen Hubbe <allen.hubbe@amd.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Bernard Metzler <bernard.metzler@linux.dev>,
 Bryan Tan <bryan-bt.tan@broadcom.com>, Cheng Xu
 <chengyou@linux.alibaba.com>, Junxian Huang <huangjunxian6@hisilicon.com>,
 Kai Shen <kaishen@linux.alibaba.com>,
 Konstantin Taranov <kotaranov@microsoft.com>,
 Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
 Leon Romanovsky <leon@kernel.org>, linux-hyperv@vger.kernel.org,
 linux-rdma@vger.kernel.org, Long Li <longli@microsoft.com>,
 Michal Kalderon <mkalderon@marvell.com>,
 Michael Margolin <mrgolin@amazon.com>, Nelson Escobar <neescoba@cisco.com>,
 Satish Kharat <satishkh@cisco.com>,
 Selvin Xavier <selvin.xavier@broadcom.com>,
 Yossi Leybovich <sleybo@amazon.com>,
 Chengchang Tang <tangchengchang@huawei.com>,
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
 Vishnu Dasa <vishnu.dasa@broadcom.com>, Yishai Hadas <yishaih@nvidia.com>,
 Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: patches@lists.linux.dev
References: <10-v1-2b86f54cda42+7d-rdma_udata_req_jgg@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Gal Pressman <gal.pressman@linux.dev>
Content-Language: en-US
In-Reply-To: <10-v1-2b86f54cda42+7d-rdma_udata_req_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 12/03/2026 2:24, Jason Gunthorpe wrote:
> Add the missed check for unsupported comp_mask bits.

Is it really missed? IIRC, it's intended.

See the comment above your hunk, and efa_user_comp_handshake()?
