Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD71407CF1;
	Mon, 20 Jul 2026 16:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563448; cv=none; b=hgTgjtws703qUOI2paZeSYul+UYyt/N+J8w+u66S1mIprkQtX98C8/l5xymF3e2HvMoCUaI6GzwdcwdhkfULNClKwS3g0cP7RwdZPfs/m6NYGyDdCyeqFmWYTk12w6vurgrLLlINl9c+Jh5vyJFjSrZmcR4fKhUYq9fc1GQbsf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563448; c=relaxed/simple;
	bh=vqUI/Q5IOBTGb+xMnEg3WLL7mVn13+xvUOo9O9kihY4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=vFWdf5to/C65m0aXydPYK41EafVomsoXS1n6zjofqsCdvQadtS4ACBFbRXleKthD4XXR8iKfwqWZGJxvJeLz1OhmRPhy9wbOzGWaEiZwJUHtu34yM3pjtssCDSD+kzxcsZu5pCohw1il4jMLCEQCs4yD2NYEFuJStPk3tDD9HEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=j3o8JOj7; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="j3o8JOj7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=T40zLSnGBy2hqHl7tiJhrkhW2pKsi4efBFaej6HGMec=; b=j3o8JOj7B/uTCnqOrY71I6s6MT
	4Uh+dKozXnsM8NdZw4ta/ExCHzOQByj+AHRZbALajjKdcg/BpbL5Tt1X8WkEDwX06kfa2bI4ociYl
	1h1Kf8uyQkd7TtHGm4Pphe8ueAaGakzS8V/KCJBp2lXDiwD4wE7wxDfwwz6mYlgmdYk+iLZW3qMS+
	DGBAOupX5dEpMOl7lyQsycgaVS+VRR57F77wgg5Vq8bq8RnGD+b/YfQD5NcqD6r70VIQzwPnh+1FS
	S2/gP0194XnfJEN6DJdsLJP489/TwajgsH+oXBgm05Z49yYSFulasjT4D5jgrWQPVgtGOZ9MdVG2N
	NtlrjWZQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1wlqTH-0000000B6Il-3Oce;
	Mon, 20 Jul 2026 10:04:00 -0600
Message-ID: <eded3e25-eb53-417a-8040-fcad3854c1a3@deltatee.com>
Date: Mon, 20 Jul 2026 10:03:58 -0600
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
 Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava
 <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-3-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260718162547.448892-3-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, leonro@nvidia.com, jgg@nvidia.com, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH 2/6] md: ensure REQ_NOMERGE is set on P2PDMA bios
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-18 10:25, Mykola Marzhan wrote:
> md_submit_bio() unconditionally strips REQ_NOMERGE before passing the
> bio to the personality, an optimization from commit 9c573de3283a ("MD:
> make bio mergeable"): a bio that md has split may become mergeable
> again below md.
> 
> For PCI P2PDMA bios the flag is load-bearing, not a hint. The block
> layer sets REQ_NOMERGE on P2PDMA bios (__bio_add_page(), and the
> extraction path of bio_iov_iter_get_pages()) because the DMA mapping
> type of a request is resolved once, from its first segment
> (blk_dma_map_iter_start()), and request-level merging is prevented
> only by REQ_NOMERGE. Stripping it allows the member queue to merge a
> P2PDMA bio with a bio carrying pages of a different pgmap, or host
> memory, mapping the merged segments with the wrong bus address:
> silent data corruption on the member.
> 
> Set the flag for P2PDMA bios instead of merely preserving it. No
> in-tree path currently submits P2PDMA pages through the bvec-iter
> path (bio_iov_bvec_set()), which skips the flagging -- but nothing
> structural prevents one, so setting rather than preserving hardens
> md against that gap at the cost of one branch. Everything else keeps
> the original optimization of clearing the flag. This covers every
> personality that advertises BLK_FEAT_PCI_P2PDMA (raid0, raid1,
> raid10), which is why the fix lives in the shared md_submit_bio()
> path.
> 
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Makes sense to me. Matches the similar check in nvmet_bdev_execute_rw().

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
