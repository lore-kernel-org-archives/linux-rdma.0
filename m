Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD02C3191D6;
	Thu, 23 Jul 2026 06:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784787085; cv=none; b=BnvpvhSdb+eAOoBNyoFjly0KMwg+rF11H+yI/7ejBIdL8dZphLu7rAPIIvpsUmbh9VjIi1I+qQuI8mjkKaeR9M8DvshrtwAp9dwSQyFYt56l7WcY0f1Uw8CpSeSo+K+3womS+LIUTeIwYlPLV337VWy9KonWup4sjWvZh0BVcoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784787085; c=relaxed/simple;
	bh=Qae+3iD0gUpcR0ak4mkDHhk+7oPwN70ONsdbSH40q5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cI1iS3LmMja5Oz8/ygAVGHc9cbZvrAjzcRT2OabmsOr2yYGyJI+MLUHxvFgSUHkvgYf3JImR8LRp1tlxsObFZtHck7NnhnrdJIchxxo1DuqVF8z/LELhaBdriIH1gTxVtX06Ey0v7rTgWk/IApEGRlepeO6Yd1Dz6QOIA8Nebr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQI35ZHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQI35ZHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7994E1F000E9;
	Thu, 23 Jul 2026 06:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784787084;
	bh=VBdn2EWjCzaB/LsGvu5JNC2sbY5O5dhhwEkMKQrKz6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jQI35ZHFBTChYjQ6kfiY3FIG5lc5U7yuTiFHA0MAJuCB5lQhyHKzfGFvMqu0Vg7oS
	 wbmqZnrDUGLV+3FxAGADTsdviVKQKmKxL5b42UsWs1FHa/mxdTow2mrTa9oHPGfiFq
	 7VcDodqNgInG29zaRfj9Q59DE3247biTYu4J02Ld6oUHDbnanBWeSf2IeYtx8nhSGh
	 C4UgTQZqxfkmK2AoIZyCTBNAVlrVMRTOt7Unzfeklkfjs4POShPbXDmJPwwg+nCZOz
	 P8UMjW2HY0eW3UKLb58b2RFEDv2qDkLqgPOUN6Ue6Zq6qTLfJTgAqH/sJ3VXsHAVsq
	 IPE4/hdrctM0g==
Date: Thu, 23 Jul 2026 09:11:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Mykola Marzhan <mykola@meshstor.io>
Cc: Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
Message-ID: <20260723061118.GA110966@unreal>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com>
 <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
 <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com>
 <20260722083015.GU110966@unreal>
 <CAPzsNDuGfneEmx_nWqw5vYLyPyK8krfWChNRcsxO7icTEDDX5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPzsNDuGfneEmx_nWqw5vYLyPyK8krfWChNRcsxO7icTEDDX5g@mail.gmail.com>

On Wed, Jul 22, 2026 at 09:00:16PM +0200, Mykola Marzhan wrote:
> > I had thoughts about this series too. It seems best to avoid
> > the P2P path entirely unless all legs support P2P.
> >
> > Can the md/raid code determine P2P support in advance?
> 
> Yes, and it already does: the block layer ANDs the P2PDMA queue
> feature across all legs, so an array with a non-P2P member
> (e.g. an nvme-tcp leg) never advertises P2P at all.
> 
> But that flag can only say "this driver can do P2P in general".
> md cannot see which HCA device does the DMA for a fabrics leg —
> and with multipath failover it can change at any time.
> 
> So the up-front gate covers what is knowable up front.
> This series is about the remainder.
> In mixed case, one local P2P leg plus a remote replica, with it:
> 1) a failed read just redirects to a capable mirror;
> 2) a failed write records bad blocks instead of retrying forever.

Thanks for the explanation.

> 
> Mykola
> 
