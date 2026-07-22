Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EDB381EB6;
	Wed, 22 Jul 2026 19:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747940; cv=none; b=Ab32Wxt7DedjfJKm7wDiZVQm/ZzQB0ZkQ3C8xualV0Vr2m1hJqEhfoUyROJJjVW/LAGZxX93PUqFJo8pRJ6ythfsnXwy3u3zpPNRhhrO34Z3LCZNl+THIWd11MI23o7TEnpPAC60kZxwZtTI548d3by+pktcS7BNdJ0Sk2KXZxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747940; c=relaxed/simple;
	bh=v1VDjxT8i25rfWDR0HJMRa5K/VncR5EaDtE/10jurtA=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=oxpTkb3fW8+WYvzrrrzVjzvXPC/NeWHBYQFVfT/VNGLU0E/1buDx0/vmJtr2ZoB8w2EeWMsQEoJFaKua/z1vb+NTBsJAdInZVpKxTlL8hOj/iqu+moiQNUL2C1E1HkpuIgRw/pL5TCEkWbWvb3oYogC3hVLZ+1qRSHg3s+14ME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=mQRIs3wk; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="mQRIs3wk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=d+TcFgqQukObtCSZvW9VgUWZR2p8E5ySHAMVDnChiis=; b=mQRIs3wkfvk8mukQPjS6/uHcq4
	5tZrNMWxPfrEuKuF3obOH9P+n5ni+wANeG2QV8ZQxeElcgt1o1fQFeTgHuY5qHD4MehFKNjbDQ1nx
	LMMVNpHW74oJNrb7pa2a65oUPkStLb6kxtmVh3bWDnLnajXYk6L/yJIOgeENrD10BgP1HJGba4Mn3
	AGcbgO59VYN5xvVe03XYgvcJBUdWqjk5YsNMkg3E8sKPWXNCR7tvaz7NZUxuIwJQzxf/0mpd412FP
	GeW1wo8P4dZIXeekoOdsD5PWpQopBz8ckA3c+Dv2Xx4jLPm4mqQNm9HCngQKRGoRpDvxbmqURV4CY
	yuejIiJA==;
Received: from d172-219-145-25.abhsia.telus.net ([172.219.145.25] helo=[192.168.11.155])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wmcSm-0000000CaBm-2qki;
	Wed, 22 Jul 2026 13:18:41 -0600
Message-ID: <38c44536-51c0-43a1-b83c-b94915890aa2@deltatee.com>
Date: Wed, 22 Jul 2026 13:18:27 -0600
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
 <20260722185841.449934-8-mykola@meshstor.io>
Content-Language: en-US
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260722185841.449934-8-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.219.145.25
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v4 7/9] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-22 12:58, Mykola Marzhan wrote:
> From: Logan Gunthorpe <logang@deltatee.com>
> 
> BLK_STS_P2PDMA reflects the peer/member pairing, not member health:
> retrying the same pages on the same member cannot succeed.  Keep
> WriteErrorSeen so the range stays fenced, but skip WantReplacement and
> FailFast eviction, as commit f7b24c7b41f2 ("md/raid1,raid10: don't fail
> devices for invalid IO errors") did for BLK_STS_INVAL.
> 
> The failure is whole-range and deterministic, so narrow_write_error()'s
> block-by-block submit_bio_wait() retries are pointless.  Record the
> whole range as a bad block in the completion handler instead.
> 
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Co-developed-by: Mykola Marzhan <mykola@meshstor.io>
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
> ---
>  drivers/md/raid1-10.c |  3 +++
>  drivers/md/raid1.c    | 12 +++++++++---
>  drivers/md/raid10.c   |  8 +++++++-
>  3 files changed, 19 insertions(+), 4 deletions(-)

Maybe drop my authorship from this patch. I only did the first hunk and
don't fully understand the bulk of it.


> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index cee21452e066..89daf8558251 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -309,6 +309,9 @@ static inline void raid1_write_error(struct mddev *mddev, struct md_rdev *rdev,
>  {
>  	set_bit(WriteErrorSeen, &rdev->flags);
>  
> +	if (bio->bi_status == BLK_STS_P2PDMA)
> +		return;
> +
>  	if (!test_and_set_bit(WantReplacement, &rdev->flags))
>  		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19c4dec450de..917d694ef401 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2624,10 +2624,16 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>  			 * narrow down and record precise write
>  			 * errors.
>  			 */
> +			struct md_rdev *rdev = conf->mirrors[m].rdev;
> +
>  			fail = true;
> -			narrow_write_error(r1_bio, m);
> -			rdev_dec_pending(conf->mirrors[m].rdev,
> -					 conf->mddev);
> +			/* Mapping failures are whole-range and deterministic */

I'm not sure I follow the point of this new comment here.


Thanks,

Logan

