Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986D13CB2E0;
	Tue, 21 Jul 2026 23:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677170; cv=none; b=umGZ58jmbFiUcWIPBIItuY07COSEIIxSPEiC0XSWbca2TbZLSNC0SQprnURtEjM4+cvhid9+sGBB0q3H3srrT8MrjthQKQFbvWSZKGxGdKT3DDsAczPfMJh95PRm1caAk+qvhsvVa4a7sUdIoiJqiT822zH16VCuRguUFgNwhDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677170; c=relaxed/simple;
	bh=U5noW1vviCeKRF6aP5p06WfDdj+QI3t2g3PPfILXppM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=FT15IYAkO+b5yOJEwX193CNMtychNgnoJ81YQI2beXqyOeDYTOBzt18/C9CTm3spbQmLvmuPiKn6jQrpL50sJr0c9eEUzjKMBSWe/HAQJMfoemACfeDUSx//QisdQxzYa40tpDwO4cKaPU/eaDwhkR800tZhQ5JvgUo9M8I8VE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=JePFvpH8; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="JePFvpH8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=HbarWDj744NAcsuxjg2Rf91YA+KE2onmHu1JCGxVkMk=; b=JePFvpH8O3DliRZI9R402wwaly
	fzTJoa1IC/gAX7iXrnp+PZZCWWxrbTrYtLFQQlDJAALmHAAHkvl9BS90oj/6KpknU6eecrU2DIvi9
	bmrZYjqv2t5S1XlQ3svKNmfTRdxjLDyYuYYN5R0CnhkFkXqnziZ4oteFmlKz/LkSjjght2dXUlK4G
	lSy6UgIhh4jH6/6xxQjEneuIobFofIakqQK67iX4Sf7KN3RdxfHjzseGs93v9EKKTnUngrXY2fMU/
	8U6x0Acyjia92PkagrInKbsSkY9SyISp9cl/sfJWAk+AcZDTbYCeUs056xXviAH1IzKUT6kALehs1
	CBt7pp9w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wmK3R-0000000BuOW-0FPO;
	Tue, 21 Jul 2026 17:39:17 -0600
Message-ID: <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com>
Date: Tue, 21 Jul 2026 17:38:53 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mykola Marzhan <mykola@meshstor.io>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fygo.io>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>,
 Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com>
 <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-21 11:50, Mykola Marzhan wrote:
> I have split it in v3 into a raid1 patch and a raid10 patch.
> I am not sure about separate "introduce the bit" patches.
> R1BIO_P2PDMA and R10BIO_P2PDMA are entries in the two personalities'
> with own r*bio state enums.
> The commit messages are shorter now.

That helps a bit, thanks.


> An early return doesn't work here: on a mapping failure the
> function must still fall through to set R1BIO_WriteError, so the
> completion path runs the (single, whole-range) retry and records
> the bad range -- only WantReplacement and the FailFast md_error()
> are skipped.  v3 folds the two tests into one branch now,
> which reads better and keeps the fall-through. Please check v3.

The early return works if you create a helper.

> I compared the two sides after splitting: the P2PDMA handling is
> symmetric, and the remaining differences are pre-existing
> personality differences rather than missed fixes.
> A shared helper would be heavier than the two open-coded branches,
> so I kept it per-personality.

Yeah, I still think it's a bit of a mess so I dug into it a bit more
myself.

I realized the real problem in this patch set was reusing
BLK_STS_TARGET. I think I may have used that a long time ago and those
paths have since been removed. Using it here doesn't quite make sense
because we end up with those awkward checks (is P2PDMA enabled *and* the
error is a BLK_STS_TARGET). I don't think that can ever really be
correct here seeing something could, in theory return BLK_STS_TARGET for
another reason even when P2PDMA is enabled. So that should be cleaned up.

Instead, I think it makes more sense to introduce a new BLK_STS_P2PDMA
error and use that. Then we don't need to know if a transaction is
P2PDMA when processing the result which simplifies patch 6 and 7
significantly.

I created a basic sketch which demonstrates what I'm thinking here:

https://github.com/lsgunth/linux blk-sts-p2p-err

Feel free to run with that.

(Note: I omitted the narrow_write_error() from the sketch because I
didn't dig into it enough to understand it. It'll need to be added to
this, preferably cleaning up the tabbing style a bit.)

Logan


