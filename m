Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F8407CF1;
	Mon, 20 Jul 2026 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563757; cv=none; b=RK9LKP9yI/yeInAHL+nyeuDGeotXCrPeQfsknzo0XFRSvNdsnj/5wZyW7G6mHqTSu98a4y/JDNtHtDjz2dq3zQLUcNOB30zgACab69/T2UX3Ou0uzD4gI9TITxfrs2y2hWj5ttMYtOdkWUW1IvkL45ue1Ho5wIZBukbJASVqI98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563757; c=relaxed/simple;
	bh=DFOs462hXB5mATP2NwrDuCBFgLRO6xr5W8mMQp22sME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULmJpJfOqckeXQPbhlL4bh5EzKyyl0GD3ANq8k+9ZAfRMifJ/vQznh65gV+bKgZDARX3Usg5kxe9RtP3hy15qCKgRlBuwjd/NnUgZqlYPO8nYtCJkQJDU+poxesyNUmZWS82CfJELU8X+zdjFQ+yVqelezS1l9xPOwK55qa88BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErsymfqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErsymfqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8428D1F000E9;
	Mon, 20 Jul 2026 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784563755;
	bh=MH4EA/9Q4vMcKE/csYBaDf7EHyZDIanIpVZcoirKkdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ErsymfqArlZZKEf+CLB2/QdT1mzzA/cRgFIFpe98cOTFEiWPpaYpfYlWnfRMWjq4M
	 tLoCBRONpYk5+lv5xFxdHud8HFrpiASAExqGmhwpQpvVJKQdIFcpDDW5mYmmILpgn3
	 vr0bNkj0Arj0NzZs4Aip+6NJqJpv66AOMKHhdyCsWj5f6D56OdMnP/WjLFaUYM6SUo
	 U7ilIkf3ow30r7TOo85OMtLokulfhSnh0LijlS3YhsAUN11UKWJ/OJ1MGx6qAxDx73
	 evZy8dhdcN4nB8ZtwYlRpkfMDPv/EsxfaNcQCWCMDzQcxiDFD5zDkqfELK5NS2/M8U
	 btAXQhiihU99g==
Date: Mon, 20 Jul 2026 10:09:09 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Mykola Marzhan <mykola@meshstor.io>, Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/6] block,md,nvme: correct handling of unsupported
 P2PDMA transfers
Message-ID: <al5IJb-L0FpztnYz@kbusch-mbp>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260720124304.GE110966@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720124304.GE110966@unreal>

On Mon, Jul 20, 2026 at 03:43:04PM +0300, Leon Romanovsky wrote:
> It would be great if developers supervised their AI tools and kept
> commit messages and cover letters concise and readable.
> 
> Everything above can be reduced to a simple sentence: "MD treats an
> unsupported P2P operation as success rather than failure; update the
> code accordingly."

Thank you for TL;DR summary! The verbosity from these things is a bit
annoying.
