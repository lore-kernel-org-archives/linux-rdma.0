Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B52434404E;
	Wed, 22 Jul 2026 02:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784686749; cv=none; b=uHrBJfNMSPvojjHVMIyyQrthQavfjcK1Fq5+yqjUaRD72GbmDidhnxr/TVVPHWANwcDI7GYmFoRBgKbGABoSp+5n4MyyL9T5YvoXetfaLjDeHd1xPFoyHMaxqoj09sUVta3RpGi170boPsBFekB4PDBg5egwHRFZu3bAE8/+vy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784686749; c=relaxed/simple;
	bh=qqnDV6PkKG6hsFvG0qBXgE438bjkCts6kFmdXXNszbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mRlc4M02WLlhseyFGZhKFEyP8cm+viYGxSGKCsy3ymM8DMCTsS3/AT5TxFE7aCUrOnjTl6kUBR98FYX1gjmHanZ7ixgl4NQ2D/K/JiU+Yir4J4+2eaoHveJxw0VYFNxFwaWqjxnk13OH450fH690Eg3Nnwc8LoXAqG9RjgLpLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eRa5U4Ul; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eRa5U4Ul"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784686737; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ywJQsi87DKdDcipY2YOm4e5HzhnX/LMLRlfHXmZPOdo=;
	b=eRa5U4UlpfvFF7S9SgL0o77qWPirOBlKRt2Cotbt1ZByrm+YCYXUFesEKbPAGHYJvlao9RDvRw7BoZ9/FYB3X80VJ/domNaaDcDEXByci4OIu7MCKb5oeqQ9LbPfQaLYoFKvA+qsLRjUdKdoM3VVLqUnALNFLPzw//ioezWtnJU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7bqisn_1784686736;
Received: from 30.221.106.174(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X7bqisn_1784686736 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 10:18:56 +0800
Message-ID: <c61972bb-bdb9-c1f8-be16-5e98fd28fa5c@linux.alibaba.com>
Date: Wed, 22 Jul 2026 10:18:54 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
Content-Language: en-US
To: Jacob Moroni <jmoroni@google.com>
Cc: Myeonghun Pak <mhun512@gmail.com>, Kai Shen <kaishen@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ijae Kim <ae878000@gmail.com>
References: <20260721082545.47395-1-mhun512@gmail.com>
 <5dda3040-67c9-7916-436e-47125daeb310@linux.alibaba.com>
 <CAHYDg1QDaWPxD7pb-A1ZmqxaX6YACWTsinzEG4_EZDKbAX38kQ@mail.gmail.com>
From: Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <CAHYDg1QDaWPxD7pb-A1ZmqxaX6YACWTsinzEG4_EZDKbAX38kQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/21/26 9:24 PM, Jacob Moroni wrote:
> Hi,
> 
> I was looking at this driver and was curious if you also need
> some type of synchronization after the xa_erase in erdma_destroy_cq.
> 
> Otherwise, it seems like the CEQ tasklet could do the xa_load right
> before erdma_destroy_cq does the xa_erase, then destroy_cq proceeds
> to return and kfree the CQ while the tasket is in the middle of comp_handler.
> 
> Most drivers either do a synchronize_irq (which I don't think would work for
> this since it's a tasklet) or some form of locked refcounting when
> accessing the xarray.
> 

Hi Jacob,

Thanks for pointing this out.

For kernel CQs this should be unlikely in practice, since the associated
QPs are destroyed first and the kernel QP destroy path drains the WQEs
before the CQ is destroyed.

However, the user CQ path does not have the same guarantee, so the race
you described still needs to be handled. We need to add synchronization
in the CQ destroy path, and I will take a closer look at this.

Thanks,
Cheng Xu

> Thanks,
> Jake
