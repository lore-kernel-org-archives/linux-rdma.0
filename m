Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CCC345EBF;
	Wed, 22 Jul 2026 22:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757613; cv=none; b=Z1pjuA+uXntgJl1zJvmQTkW4X+oalZYTY0czHkNw4XodR/dLuoRtFYkasdH/xIQ9Vfq4nzvwEBNOrBoZv3Th851cdCYrZUeWeny0WQG/Pbo/X4UhSljG7AJLvuytV7HXmg5lJWg7WuM9+sTIOBggjFBoJwiI8nqOMesd6bn7xbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757613; c=relaxed/simple;
	bh=AlOzJ3PucvMhjsxe049wK97vJfOJA8H9ozMVnIVACpg=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=OJworiymcQ2mmcqKZApAeABYeWnjmcPy+dj/HbRBIuSPo9fcq8o+X47vuZmQNtvovPKhScI3ICsxKrBxpPKT/eRAZ8Ty+GoFNocGljMthT34ohRo9aL8qOYcHtXSD1bkrr9BVEDgOgaA2tOuNVGhANqfBeubzNoiUGIF0WZG/94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=H80nSWfW; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="H80nSWfW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=mWLM0sNqj8A+i8RsOd2Hmw7WLj+R4XIGUQ97gxss7QY=; b=H80nSWfWXMG7+WawMVnp9g982Y
	l4MDmkHHwJaBipGMWml11JCpIMHWEkOL0zPbZo1GPMWZLvgdAga9WMfiySF/nWucEmoClt6MNfuC0
	YHiEocy1hNKn1EVedB09F2jVj+0gga1as3yohtlIgoxcbfK01gAFK+01mdKyAzxlqLp/45Tnyx1rT
	a1sC3iXJoCQ2ecHm5Orlcj5VRGuxiiB4sL7LpgQLyvwy6y3pewb+vltNHNm8KC9yrMmCMsyT7234k
	vcCqRG2a3kQYmw/efvm+QkJ2qDX6WcKGkQzTQodogTuyyOgqc0q0GAPUAsr07MXpDUphBq7rhPdJI
	O95uAEmg==;
Received: from d172-219-145-25.abhsia.telus.net ([172.219.145.25] helo=[192.168.11.155])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wmeyv-0000000CbjN-1hVE;
	Wed, 22 Jul 2026 16:00:02 -0600
Message-ID: <528ead56-5621-48ec-8828-d9071ebfa2bb@deltatee.com>
Date: Wed, 22 Jul 2026 15:59:55 -0600
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
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-10-mykola@meshstor.io>
Content-Language: en-US
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260722185841.449934-10-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.219.145.25
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v4 9/9] nvme-rdma: return BLK_STS_P2PDMA for unsupported
 P2P transfers
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-22 12:58, Mykola Marzhan wrote:
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 6909e3542794..2f50509a7a61 100644
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
> @@ -1480,12 +1481,14 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
>  
>  	req->data_sgl.nents = blk_rq_map_sg(rq, req->data_sgl.sg_table.sgl);
>  
> -	*count = ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
> -			       req->data_sgl.nents, rq_dma_dir(rq));
> -	if (unlikely(*count <= 0)) {
> -		ret = -EIO;
> +	sgt = (struct sg_table) {
> +		.sgl		= req->data_sgl.sg_table.sgl,
> +		.orig_nents	= req->data_sgl.nents,
> +	};

Maybe we could make this patch a little clearer by splitting the change
to sg_table into it's own patch? That would make it much easier for me
to review. I've looked through it now a couple times and think it's ok,
but it's a little more complex than I can really untangle in my head.

Per your other email, I think that will make things good from my
perspective for v5, but I reserve the right to find something new when I
look at it ;)

Thanks for your efforts cleaning this up.

Logan
