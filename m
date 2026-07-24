Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2BB388361;
	Fri, 24 Jul 2026 18:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784918927; cv=none; b=hTjIDk6Hgu/ElL5uacmimaNVxyFaxy4a6ADU2RAF4nTj5CswQkU2ME5PeCD+aSaBC5x9G+yozA+4IBnKbHOOchWzBNyawBRdHXi/Np74EvDfPwN3vzFuHCg06rV1Fmad8V/s5qsyN/cLOopr02/jB20gG0StPZ7SfIv7+JpRv1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784918927; c=relaxed/simple;
	bh=JbTo4I+DRipFpniSL/Ai8DAUcMBQ+o1TOG0vVUaHUR8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=QQAMQjTdIOT61U7dyMA0vsDSUmF49N0Yd+iHmGQrZ+Jt8c7RFoLjt1XLKOJKv6aMpoLO16VaUYjadymHdlpWzxK7uQL3fevV+PtokN3CitLplb5hGAFOgbHM4VRxfp9Yo4DJMXyH7GOVs1322vhxLXGcPTtD299GwZtLnSfHiN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=CrMKD2tf; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="CrMKD2tf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=lyf4LTVkA3IdyxZk0dAuQutxNJYdqXOmUsPg3x/bmR8=; b=CrMKD2tfE0Krvs8mmKJfzJXDz0
	LF0h/ra2V9nlz87cZyJ86J3H6ImabZnYnPsYqIiEpBXoO9RUv/7g5Dq9VijqQDiKbGYhGn8g+ZhJt
	S4khpU6MaDXMK0mQFi2TPFxSYU/MgpoDxf7ijmhAmiC19FBztWb3kr8mV+7F/MDKiDNXvZ9+xEPp8
	jlFGycdN2IBoBaAq+xYUvS5zjX1ceFxqI075ggPHxB+oTofG2w1BvSeVI0o8Z+Cc+EeBhC312JzBD
	gP5CAE3fmuPoZAI2ruN94yLDmTtp80pO81vOECjgJvynWK3MfrFy1XhpHc5RFpKvGakw1pbEvQwzP
	oBIqCHaw==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([96.51.150.74] helo=[10.0.33.8])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wnKwj-0000000E1PL-2AOY;
	Fri, 24 Jul 2026 12:48:34 -0600
Message-ID: <23b0a3ae-7f11-4ae9-8c1b-0401db0fd299@deltatee.com>
Date: Fri, 24 Jul 2026 12:47:16 -0600
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
 <20260723204206.76930-10-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260723204206.76930-10-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 96.51.150.74
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v5 09/10] nvme-rdma: use ib_dma_map_sgtable_attrs()
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-23 2:42 p.m., Mykola Marzhan wrote:
> ib_dma_map_sg() folds every mapping error into a zero return, losing
> the DMA layer's error code.  Switch both scatterlist mappings to
> ib_dma_map_sgtable_attrs(), which preserves it for the next patch to
> act on.  No behavior change: failures are still reported as -EIO.
> 
> A local sg_table is needed: dma_map_sgtable() maps orig_nents
> entries, and the embedded table's orig_nents is the allocated count,
> not the count blk_rq_map_sg() produced.  rdma_rw_ctx_init() does the
> same.
> 
> Assisted-by: Claude:claude-fable-5
> Cc: stable@vger.kernel.org # v7.1
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

I don't know. I think this could still use a bit more cleanup (see
thoughts below). But the cleanup is probably too much to ask for this
series. See my thoughts below.

Reviewd-by: Logan Gunthorpe <logang@deltatee.com>

> ---
>  drivers/nvme/host/rdma.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 6909e3542794..63830334c73e 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -1469,6 +1469,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
>  		int *count, int *pi_count)
>  {
>  	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
> +	struct sg_table sgt;
>  	int ret;
>  
>  	req->data_sgl.sg_table.sgl = (struct scatterlist *)(req + 1);
> @@ -1480,12 +1481,16 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
>  
>  	req->data_sgl.nents = blk_rq_map_sg(rq, req->data_sgl.sg_table.sgl);
>  
> -	*count = ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
> -			       req->data_sgl.nents, rq_dma_dir(rq));
> -	if (unlikely(*count <= 0)) {
> +	sgt = (struct sg_table) {
> +		.sgl		= req->data_sgl.sg_table.sgl,
> +		.orig_nents	= req->data_sgl.nents,
> +	};
> +	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
> +	if (unlikely(ret)) {
>  		ret = -EIO;
>  		goto out_free_table;
>  	}
> +	*count = sgt.nents;

This really makes these calls really complicated and harder to reason
about just to get an appropriate return code in the next patch. Though I
see the complexity here and I feel like I'm confused by the semantics of
nents and orig_nents all the time. It seems like some cases really need
to track three counts: the number of valid DMA addresses (nents), the
number of valid segments and the number actually allocated. sg_table
only has two fields, and orig_nents ends up doing double duty — the DMA
API reads it as the valid-segment count, while
sg_alloc/free_table_chained() treat it as the allocation size. When
those two differ, as they do here, it creates this complexity.

One cheap thought that might clean up this patch series is to create a
helper that can be used for both the data and the metadata, but that's
only slightly better and I don't know if it is worth the effort.

A better long term option might be to introduce a dma_map_sgtable like
helper that also takes the number of valid segments which would clean
this up pretty nicley. But that would be much more work.

Thanks,

Logan

