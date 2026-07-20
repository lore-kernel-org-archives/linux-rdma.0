Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1FA74BE1;
	Mon, 20 Jul 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784558990; cv=none; b=mncpLe/FF9Yn4aT4Cz1T9z4ysTfgcP0s1k8ml6OzFCErGu83eD0QcGP75ZdXbzeshTBuOUxGYs84JqG8xhO5n8D1YT6xdAB+SzIbE2SWWXkIQMcWB/91pXeN31eFhFlF5NPhyvLyjmzL21yxxRViGUijK09PBC3e/GVrjszKsWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784558990; c=relaxed/simple;
	bh=iR6kr1AJ9R1UNAyVimsd/834QO0ilMIUmrx2JKD+oGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekH3kVPjUHaXcBykxdlnlKFJe7UqRpeVbChOeuug4c/s6ApuvKUkzAMy4qQAsxI+Zaq0BvUWW82aWUc4qCh4erbkTfJfv7IbW89OaYd1btZBkjLjbONr2VHcORZT9ZMmYGBd79+FoJvZwlcecJtRREfKWpM7UnClq6/62Zl4iJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 96DBE68C4E; Mon, 20 Jul 2026 16:49:43 +0200 (CEST)
Date: Mon, 20 Jul 2026 16:49:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mykola Marzhan <mykola@meshstor.io>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/7] blk-mq-dma: restore BLK_STS_TARGET for
 unsupported P2P transfers
Message-ID: <20260720144943.GA17375@lst.de>
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-2-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719105327.864949-2-mykola@meshstor.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 19, 2026 at 10:53:21AM +0000, Mykola Marzhan wrote:
> matching dma_map_sgtable()'s -EREMOTEIO: "When this happens, return
> BLK_STS_TARGET so the request isn't retried." The conversion to
> blk_rq_dma_map silently changed the status to BLK_STS_INVAL, which
> regresses two consumers:

This is a really weird writing style, and suggested to me you neither
understand the code nor the problem.  Please actually think yourself,
write the patches and commit logs yourself instdad of this garbage.

And please also explain how you even generate the I/O that fails this
way.

