Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FFB3D4101;
	Tue, 15 Sep 2026 11:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472278; cv=none; b=ST1Z0+mNJN5wCgjZ2qBs4DeSy/JLyItWzOmojoQyMjT8XL4zEvxzUKUeu9OUSckhtlQbmTDO5ox5F8VFI0bi5H2jPDXvP/XJTtEyIfhRbHz8WoLo9LgUFgcORlV+2tlDmfsWVEaKtOcdLuROpVLL3+xeowxnl/leZyIXx68mnJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472278; c=relaxed/simple;
	bh=tehTLeW/rLdYE+dzcYbMoT2+ZrJ+K9BSsAsIyPOB3hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCmV9fp4Y81wXSWedz14pUQpwu5UmOuIS07SWIkKN8F1aj+wR3Nf2ep402FODXmPHCgozFWcMoTicQGyxtGM8Xg/5vFJMl9adYLJnKUZKcbcdckxIsOSbVPO0OqOKvuSY2I8Abl38z8C2UHTlYT3VeNWUH/AK5Fut2bSg8y8F5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jT8opjhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jT8opjhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B2C1F000FF;
	Tue, 15 Sep 2026 11:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472276;
	bh=sYl0ytaxMndC1p5mXgQdcUeluV41DyVTbBzozC+8wMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jT8opjhiEdiQ6cfZBvQJD0vOKpDRx9kZiBi7PTWcOOCnISBEmjC68q9lBiLmmyVxJ
	 iob0stPbv2i937MR1CZVLg7lxadp1tIYhyFZJ46CUww4G8oS+Cr0tabAeZW0lEqyVd
	 j9hJqlmA7n6jBYw37ANWmvCeSVbP1Rx+vDuRz0uMjsbnxJ41MvrFUy8FHsxiuX6pzC
	 XQaiHKrR0eSgEdY65kwKMCidRNNqiyt5WZjaUlIIkah5mviZF1bdyZq3lS9z+nsq3d
	 nVwbUqvpuBb1MNJNqImVgC9WwVU0RZwLkfO0UUk1CX1nO8KvJ1T5wULwLE64WCpaxk
	 69QSMkkgdihcg==
Date: Tue, 15 Sep 2026 14:37:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Zhiping Zhang <zhipingz@meta.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v13 0/5] vfio/dma-buf: add TPH support for peer-to-peer
 access - ping
Message-ID: <20260915113752.GK13683@unreal>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
 <CAH3zFs2XnH6gT0fO4=WLi4x1SL2+Y0S=Jo45SWkR=unPegQ8Hw@mail.gmail.com>
 <CAH3zFs2X8=x-XMXhwC7_aUZivCCPQOSuyXMy-ryKqxLEFY9u-Q@mail.gmail.com>
 <c0c8dea4-1571-482e-be33-f965c7c357d2@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0c8dea4-1571-482e-be33-f965c7c357d2@amd.com>

On Fri, Sep 11, 2026 at 09:58:28AM +0200, Christian König wrote:
> Hi Zhiping,
> 
> sorry I'm completely underwater at the moment and don't have time to take another look at the full set.
> 
> But IIRC you already fixed my documentation requirements and skimming over the patch once more I can't see anything wrong of hand.
> 
> So feel free to add Acked-by: Christian König <christian.koenig@amd.com> to patch "dma-buf: add optional get_pci_tph() callback" and push it upstream through the VFIO channels.

Christian,

I'm slightly confused here. In the other thread, you expressed concerns
about having PCI details common to every device in the P2P world in the
dma-buf code, but here you seem fine with adding a niche P2P feature.

Thanks,
