Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC1C329E55;
	Mon, 27 Jul 2026 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785167320; cv=none; b=jDPYzYdbF99YjbsJ5hHwt9hwiP4dv2q9UypP4JeOIUO3XlI4mcfKzzkuSIQkQXgtayrk7fjtLFAL7rrbmWQW9G1T6jzOTXOYxmwQRwdHyWex0SVBvdhITQRlGFdAaqSBE7AqGlmq2sX2c92WVd21h83taOYQ/vsAM53T2wpHwOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785167320; c=relaxed/simple;
	bh=Y2/Z3LY/RmRJ8nKeH8GBXkQa5Aru9cXcqr6idaq4720=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=MBqHWcVPsK0fc9LnyWiZ3R3ncn4oFirdp+7NPejrP5n9zauUTLDbEomUs0JR7e7VSAhgpBxW7+okXLyyy+Dit9deMVT5PfrBLrl1ZOlH1tzqwvxEeWIiG2wrdo9ttYhTbwUX/7PANk47S0azsSEE1fo1QGRpU3X6gyqtNGtN6OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=d3Fyd20R; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="d3Fyd20R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=2oQhVvdv6KuXOiBD33tawm7L/XSNS3FQAeB02Lg3Rx8=; b=d3Fyd20RPqcZRPF+6seD52jrxs
	yjAvCdAgZVrU+sB6XDX7ZFpDad4tBDiHMmPolG37tWjhImS68lymNdWNVbq9J4beIpy/cBR/bxo8C
	Ytna5l7NYKOqJPyk3xHR9EqwZy5AC6F3y/euuHm/mzVeBVGKxrAT5xrDHREnCZOjH5l0iSWmZmyS4
	synpvjnCQurud74bxxoVd9M+uK3tIW2m4w8sILjk9Jz2CAOU90M7KK5X27UR+N1VadQirb5CcXqHw
	phpXliLE4QMi4LFi4tZay+vupgomU5LWUKrExwljuf3qPeTABUpKBzlME/M4Z5N3qYxAnGRC0DzwL
	FZ/T295A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1woNYz-0000000GHSh-1tsM;
	Mon, 27 Jul 2026 09:48:22 -0600
Message-ID: <d3d1eb27-f743-4557-b47e-ec2f8ce0091c@deltatee.com>
Date: Mon, 27 Jul 2026 09:48:06 -0600
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
 linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
 Thorsten Leemhuis <regressions@leemhuis.info>, Martin Wilck <mwilck@suse.com>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-12-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260726113229.2154269-12-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, regressions@leemhuis.info, mwilck@suse.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 11/12] nvme-rdma: ratelimit the map-failure error
 message
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-26 05:32, Mykola Marzhan wrote:
> A mapping failure is per-request and, for an unroutable P2P transfer,
> deterministic: a workload that keeps issuing one turns this into a
> log line per I/O.  Ratelimit it, as nvme's per-I/O error logging
> (nvme_log_error()) already is.
> 
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Thanks!

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> ---
>  drivers/nvme/host/rdma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index c38d949502b7..2f50509a7a61 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -2040,8 +2040,8 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
>  
>  	err = nvme_rdma_map_data(queue, rq, c);
>  	if (unlikely(err < 0)) {
> -		dev_err(queue->ctrl->ctrl.device,
> -			     "Failed to map data (%d)\n", err);
> +		dev_err_ratelimited(queue->ctrl->ctrl.device,
> +				    "Failed to map data (%d)\n", err);
>  		goto err;
>  	}
>  

