Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EFA347BA7;
	Thu, 23 Jul 2026 03:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776413; cv=none; b=F5ZyAGDB4P8WPSKoffXyZJnwdV31iayOST8IjdxxX6zITW71xcTExZKDmDDn7IzJG/8VxtzuB1qCSSId0uKvWZ3tNM5OCcy6BqMAtDCHFaj+yL33ozdy6jBfWwqVRUes/uYexj63jxvnJaeENjG9NHJJ1mDnLC2SaSW1HlJFcvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776413; c=relaxed/simple;
	bh=XyMab+OUkxBKHtu8UDWuPDUjftyh4T1RtvzWSNwjydY=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=E0WnfMesaUFQhb1Ca6IDdIugYdeH9yqTfnH5VO+7iHflgm/aRaHPxkTTyIvurasLs9SDy3O/KnEXi+Lu/JaVGV1GtOTrW3zXxqZ1wO7A40a4eYQ3MzWgMrD6cRvTHCJxVhb4F+nUlyPYdEdTdO6vhITKZDZoM1jmlGi+W7v1Rbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=q+v6LAw8; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="q+v6LAw8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=rC+XBUGFmySIn3VPBg9GBg/XbZWxt1FvpkzqM8RzAE4=; b=q+v6LAw8gBxwqa3cOIQEXC3cMJ
	5756S4TXTL4zSiuUzMe7/27YHQiwEj2NiG58xC4WGPsEogiXd4aNH0NiQKiMGKQDRYhy28+R9Us8A
	S3/LYRjonw7QSDPJONdDVL84N1x8hi9e8CYS2M2oLa1ArrwIfsPkWM32waaBEuKpm8pVVWgs89+Hi
	shfawWP5ZD2XU8jhY+4r+ACVr6ngu9egpW2Jg/yBYsRjil73XH5Ji4LZqH8H9P7hGIaCPmXuTtidN
	lwRb7AMjkgpBYB/Zxfi92semLE1yV8AXiFNJRWR4A0FLEJs0p/74dPjiBQLJR4dV3+/5NYMjyvInc
	EOVWi+Ow==;
Received: from [104.157.31.28] (helo=[192.168.1.251])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wmjs7-0000000Cf7r-20SR;
	Wed, 22 Jul 2026 21:13:20 -0600
Message-ID: <38fc491b-ce80-4bb0-85b4-7987936afb26@deltatee.com>
Date: Wed, 22 Jul 2026 21:11:33 -0600
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
 <20260722185841.449934-9-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260722185841.449934-9-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 104.157.31.28
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v4 8/9] md/raid1,raid10: set IO_BLOCKED in case of
 BLK_STS_P2PDMA
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-22 12:58 p.m., Mykola Marzhan wrote:
> From: Logan Gunthorpe <logang@deltatee.com>
> 
> A read that fails with BLK_STS_P2PDMA cannot succeed against that
> member, so mark the leg IO_BLOCKED and let the retry redirect elsewhere.
> Skip the read-error machinery: there is nothing on the medium to fix,
> fix_read_error()'s probe reads into host pages and would "succeed", and
> charging the read-error budget would evict a healthy member under a P2P
> read workload.  FailFast eviction is skipped for the same reason -- the
> request never reached the wire.
> 
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Co-developed-by: Mykola Marzhan <mykola@meshstor.io>
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
> ---
>  drivers/md/raid1.c  | 4 +++-
>  drivers/md/raid10.c | 5 ++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 917d694ef401..76a1426e64f0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2658,6 +2658,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  {
>  	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
>  	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
> +	/* evaluate before the bio_put() below */
> +	bool p2pdma_error = bio->bi_status == BLK_STS_P2PDMA;


Sorry, I had one late nit-picky thought tonight I thought I'd suggest:

It might be better to store bi_status in a local variable instead of the
much more specific p2pdma_error value. I think this would read a lot
better, make the intent a little more clear and be reusable if other
bi_status conditions need to be handled specially.

Thanks,

Logan
