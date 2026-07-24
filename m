Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEBD388393;
	Fri, 24 Jul 2026 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784919092; cv=none; b=EwHMnvXOxlDJ9I5brIs4NFfc0cnBC9U1cIJrcXKmiYlLUdH1A6/mUOPOMULXkcuvDfzC+YyBMxMl7/QC4zm67tZyP0it07GYJ71yQfpQmFnk2u7YVqNxIBole4r39w2S3MpBmYQ1jFisZ4cfemPzIdXMpPAhRosIQWeRFXnZ2/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784919092; c=relaxed/simple;
	bh=sX031qyb3snFrJjKmoNKk/6/fJJWgyZ7ikchVOkegLc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=UyTQsIkSihx/j6jUcNiJFVIWvu6+Hq4f0+QAfmEA4/wElRDrRpCVQRDhfMxGv5yOJVJK80zwCHXJyuPXz7jKb5lpmWH4JFdZh6bx7yJP3P8+AMb+PoN3lwsr3NH2AmvmfpCq1v644nkExC3aw2oPyPKFmosOfLEQysSjWkSPNoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=jjg68SQ2; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="jjg68SQ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=HeLi3cYbc3bVGppW4plLifn1UQG3PWFSk8cImbFB1Pg=; b=jjg68SQ2itQQU+efSypVQfQV2J
	lbOB4CouCbkRF2sBRX6sYzLPn9f3kq0kv0gWydzWQ+3s1s+gTW07PARHqOoSPrPFBEDkD5iIVCRpI
	GPnwepRfWEnaZozV+hzEq+uDhFTVTsFr4TfoSnHyc529MF+F94O4beKkwFj1KSFSqiRRe2c5VnKjB
	42eUHlf0kWy8GMassW93ZTVDDULkoG72VvEB/ZlQqteSejvffLwHqVFyErhseTvUKObOlSKjqMPPm
	FOIBs2Dd5ER0ZPltO9t4SOGmI1kGz4y7xtSGI+5mq8Z34i29DeCsZqxINkGrLCVRxiOBO3GqXcXyW
	veCk0MJw==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([96.51.150.74] helo=[10.0.33.8])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wnKzT-0000000E1Q5-0fGd;
	Fri, 24 Jul 2026 12:51:23 -0600
Message-ID: <15a1fc13-f70d-4403-8084-2836fb05cd0e@deltatee.com>
Date: Fri, 24 Jul 2026 12:50:18 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mykola Marzhan <mykola@meshstor.io>, Jens Axboe <axboe@kernel.dk>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Guoqing Jiang <guoqing.jiang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-11-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260723204206.76930-11-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 96.51.150.74
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v5 10/10] nvme-rdma: return BLK_STS_P2PDMA for unsupported
 P2P transfers
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-23 2:42 p.m., Mykola Marzhan wrote:
> A P2P transfer the PCIe topology cannot route fails DMA mapping
> with -EREMOTEIO.  nvme-rdma folds every mapping error into -EIO, a
> retryable host-path error: multipath requeues the I/O forever, a
> single path burns its whole retry budget.
> 
> Propagate the real error code and return the unroutable case as the
> non-retryable BLK_STS_P2PDMA.  As in nvme-pci, -ENOMEM now requeues
> (BLK_STS_RESOURCE) and -EINVAL fails (BLK_STS_IOERR); -EIO stays a
> retryable host-path error.  While at it, start the request only
> after mapping succeeds -- nvme-pci's order -- and ratelimit the
> map-failure message.
> 
> Fixes: 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA transport")
> Cc: stable@vger.kernel.org # v7.1: requires "nvme-rdma: use ib_dma_map_sgtable_attrs()"
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

This is much more understandable now. Thanks. I have one nit below,
other than that:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> ---
>  drivers/nvme/host/rdma.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 63830334c73e..2f50509a7a61 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -1486,10 +1486,8 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
>  		.orig_nents	= req->data_sgl.nents,
>  	};
>  	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
> -	if (unlikely(ret)) {
> -		ret = -EIO;
> +	if (unlikely(ret))
>  		goto out_free_table;
> -	}
>  	*count = sgt.nents;
>  
>  	if (blk_integrity_rq(rq)) {
> @@ -1511,10 +1509,8 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
>  			.orig_nents	= req->metadata_sgl->nents,
>  		};
>  		ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
> -		if (unlikely(ret)) {
> -			ret = -EIO;
> +		if (unlikely(ret))
>  			goto out_free_pi_table;
> -		}
>  		*pi_count = sgt.nents;
>  	}
>  
> @@ -2033,8 +2029,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	if (ret)
>  		goto unmap_qe;
>  
> -	nvme_start_request(rq);
> -
>  	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
>  	    queue->pi_support &&
>  	    (c->common.opcode == nvme_cmd_write ||
> @@ -2046,11 +2040,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
>  
>  	err = nvme_rdma_map_data(queue, rq, c);
>  	if (unlikely(err < 0)) {
> -		dev_err(queue->ctrl->ctrl.device,
> -			     "Failed to map data (%d)\n", err);
> +		dev_err_ratelimited(queue->ctrl->ctrl.device,
> +				    "Failed to map data (%d)\n", err);

This rate limit change probably doesn't belong in this patch. It's
pretty clear in the commit message with the "while at it" message. Worth
moving to another patch.

Logan
