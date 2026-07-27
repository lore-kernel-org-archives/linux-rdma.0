Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CAA348C52;
	Mon, 27 Jul 2026 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785167375; cv=none; b=YIToYRJJwf+wFsdW+wY+5JFv6uIovaX+UO9fuWVhbagMN4VpdbltlsDsTr1plmh9KYGbKL1GHBFXlbeeMqyYaDBDWzKQM0MwCiSyfjCeIgYIjAIT0n64KjAElpJU4sCnbkqkB0kXGt5+llXOSXa47JcoZ0NJGOJq1XcljSws35I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785167375; c=relaxed/simple;
	bh=/mWGiKv4o5WsbNp1EvcaSaF/2pobFyqmigN47mq+NEM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=SrByjDasE6DnMc++amX8goOpfReWJexC0ui/M+1tgP0mW/T0RIBzr01SDDEuvI0IYc4k5RXdgzIiXz0Cutdf6tBP21L9F4hZMjzWJYgUxYByNdZHFaXjf1oMHtNT8HxaIReIV+4YHbadEAIorY5ZnO92zy63mkY2nVqg/xTSWzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=ZsYU5w7M; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="ZsYU5w7M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=pAsOaMbYD+VLrKmhf9xajBJNx4DVk5XK8SrCLkgsxyc=; b=ZsYU5w7MEJcCZBLtMtpliX1JwA
	/y8H3I10OsJZWklS/25iu56zAVAZ8t/+TlzVdpnHXVphyuImR1Idx0/8+CTzcBebY62EPLblLBSfz
	tolaxekj2wdB9OJMK6gyR4PskuKv9cllyHRS9GfwKKEZ7A9W0fnf4UpgnSs3906atM7muZ8njM85i
	ajLfOJymqCg24FUJdIfr0JWwd18k8h+HPao5khF1R4Yasfv21ZP6rrHxs7ksPkyGvK67DRT6qO12+
	v98wGAvY0y6GnqR7PTMLlajN6WRLcmEHnA66pt8y4qwllU2Kb5bONRdju7kUIzmDPKunMe9wE62dp
	0ooG+icg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1woNa3-0000000GHTa-2lIC;
	Mon, 27 Jul 2026 09:49:28 -0600
Message-ID: <ba159aaa-648c-418e-b762-29822aaf12ab@deltatee.com>
Date: Mon, 27 Jul 2026 09:49:27 -0600
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
 <20260726113229.2154269-13-mykola@meshstor.io>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260726113229.2154269-13-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mykola@meshstor.io, axboe@kernel.dk, song@kernel.org, yukuai@fygo.io, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, magiclinan@didiglobal.com, xiao@kernel.org, guoqing.jiang@linux.dev, leon@kernel.org, jgg@ziepe.ca, kmodukuri@nvidia.com, kch@nvidia.com, bhelgaas@google.com, shivajikant@google.com, praan@google.com, henrique.carvalho@suse.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, regressions@leemhuis.info, mwilck@suse.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH v6 12/12] nvme-rdma: factor out the scatterlist DMA
 mapping helper
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-07-26 05:32, Mykola Marzhan wrote:
> The data and the metadata mapping do the same thing: describe the
> segments blk_rq_map_sg() produced in a local sg_table -- the embedded
> one's orig_nents is the allocated size, not the valid-segment count --
> map that, and hand back the DMA-mapped count.  Fold both into a
> helper.
> 
> No functional change.
> 
> Suggested-by: Logan Gunthorpe <logang@deltatee.com>
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

In the future, it's usually better to do the refactoring commits before
the commits that change things (as that makes the important commits
easier to understand). But that is a very minor nit. Thanks!

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
