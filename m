Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FEF470E8A;
	Wed, 22 Jul 2026 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747978; cv=none; b=vCN7zFSjYp9P7u/Zg+W+1rpTDH6/xdXe68i1SWKL1OzfSSTxwxLit6gh3By5t1QX9SBGP9e3vr1Z9nWrswdUqQRkPcyYVA4omWY3K63t103hUkWbd4VH+MKpXx1JfQJHjhvKLhhvmOCTexnDAXuxMYFW8qLm0oteac2BaJWfiDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747978; c=relaxed/simple;
	bh=w4ohT//4srnT//XbpT91/xlrNycZFUuC2JhcXtoooJg=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=PaSwlxNDImrC8w6dJYMCuO+XUoKj7KJ+s1VyUFmQX5CgYBNBgMvcp/iu2CqNiIcsyqESxkz9VMzrDVLYkY/abTRWoFfJ245TFeLCJLQ/DjUm2CfqHlG8OrM2hDuyULK31udEClKayEbJiWZ3x6WTIqEfg6YSOtVsNwukQroNZV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=cRN/668f; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="cRN/668f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=Ag7JybFwd1Hljy8FXU4GMOuS37EW2IpYIz19SCB7FmY=; b=cRN/668fxd1DGWOTgoIoSTt7Te
	OxVzTKBp/YlJSgXLQ44VW8bAYhP6LezdoIIsBSZDPbBMhcTHoBDQBwDTZsJIRrIG6rEO811rEpRW3
	T/yPw+BJly9z3pXslNbGadE35GvW2pAu3L5ch9pAsJypoHocuFmjMFIghW0LLSaGzacdEUOMs0OxD
	z4dqjV1HobwfKr6gefBIPdEjPf+ERneFK22S7t4yBFTT4Co5bYJwoPzbD4fFNZNAMzT3TuHmHTHH9
	MK8ozXJ4XCbUq2QsGfp1Q246wH1X5JybsmZKLSCRuPHk9IrxvyCmSMyKQza7yR/BxC2zvhLIH6h7f
	lfN4z2cw==;
Received: from d172-219-145-25.abhsia.telus.net ([172.219.145.25] helo=[192.168.11.155])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wmcTa-0000000CaCN-19fj;
	Wed, 22 Jul 2026 13:19:31 -0600
Message-ID: <536428fd-9c23-45c3-be0a-5eaaf8f3939a@deltatee.com>
Date: Wed, 22 Jul 2026 13:19:29 -0600
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
Content-Language: en-US
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260722185841.449934-9-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.219.145.25
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v4 8/9] md/raid1,raid10: set IO_BLOCKED in case of
 BLK_STS_P2PDMA
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-22 12:58, Mykola Marzhan wrote:
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
>  	struct mddev *mddev = conf->mddev;
>  	sector_t sector;
>  
> @@ -2675,7 +2677,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  	 * read error.  This is all done synchronously while the array is
>  	 * frozen.
>  	 */
> -	if (mddev->ro) {
> +	if (mddev->ro || p2pdma_error) {
>  		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>  	} else if (test_bit(FailFast, &rdev->flags)) {
>  		md_error(mddev, rdev);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9045a3f02dae..e35aeac29f06 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2848,6 +2848,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  {
>  	int slot = r10_bio->read_slot;
>  	struct bio *bio;
> +	bool p2pdma_error;
>  	struct r10conf *conf = mddev->private;
>  	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
>  
> @@ -2860,10 +2861,12 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  	 * frozen.
>  	 */
>  	bio = r10_bio->devs[slot].bio;
> +	/* evaluate before the bio_put() below */
> +	p2pdma_error = bio->bi_status == BLK_STS_P2PDMA;

I see why we needed to add the p2pdma_error variable now. I guess I
missed that. But can we maybe do both raid10 and raid1 the same even if
it means moving the `bio =` line up a bit? I think it would be better to
move the code more towards similarity with raid1 instead of diverging it
further. Maybe someday it can be cleaned up into more common code and
that will be easier if we make both changes the same.

Thanks,

Logan
