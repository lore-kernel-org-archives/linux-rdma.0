Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7773F3B6BF4;
	Tue, 15 Sep 2026 13:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789479455; cv=none; b=JlJi/c+O1vAm6Py/xrLSdcdUT+kWV41AiE7S5AR2cI7MpQ7PmQA251csl4pi2+uFnP6msv8aO8E5Fu60C1XIiWzpB/zZu1Erd4T25tSXSibFXpF8r6lyz/eBgXf/046IImP8qDZtLsQc2bbvjKUDAaS2jw/waPuzCw0rtsuhpGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789479455; c=relaxed/simple;
	bh=XbkzJmU+ohpQZw6QRlajImSOTkSJ3D6nxxEIRSVEvsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P19/y94E4lbIlz2odaPrqumPSepBSozZOFbxoUaNoK5LoT4wzfXItSJWYQgWn74agV1j6t1brDSaL+HOzf4Q35bq0WIyz+huMo8DFM/xJdodKnCDhmcPFcXwE5SQ2DAA9n6dJ8up/AeD8Sy//n4zkW50R8TkBchKTR0lAw7seic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvFjMZIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvFjMZIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439941F00893;
	Tue, 15 Sep 2026 13:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479453;
	bh=BM51LqCTQKkxQjHuUWYfXlc+A3jyZ7CPDkL+FFiZnQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RvFjMZISrAofoxatI3txRLvKezud9CwyRisHK6u/f7qV4yUT2+fhG50Licn4tOFTn
	 aUpbIemAcM0nYY73vFMmlmR1G3bd+rt/EKqZZnRrCEtiulHGzVYlo1mfwJKw5wEt1L
	 veYt//N/IyOSrGXAkw1MeTdTZ2AM54UXpTGiPVffI88yWhxPkdAceI85FeCNds2r4u
	 sMz8bBUFz776GaC6PwE+AI/nJ0iZQZZSS6dOKyITBPk7GK5hUpSLwFzs/e94djAAI5
	 B1VOzp9xLYXS5P36Ut/yF0LzCU8F2BPhT15C5ehGRRkZgEiLj+ihYaoD/RGFGUzvdG
	 Nl076XXX2qyeQ==
Date: Tue, 15 Sep 2026 16:37:29 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Zhiping Zhang <zhipingz@meta.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v13 0/5] vfio/dma-buf: add TPH support for peer-to-peer
 access - ping
Message-ID: <20260915133729.GO13683@unreal>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
 <CAH3zFs2XnH6gT0fO4=WLi4x1SL2+Y0S=Jo45SWkR=unPegQ8Hw@mail.gmail.com>
 <CAH3zFs2X8=x-XMXhwC7_aUZivCCPQOSuyXMy-ryKqxLEFY9u-Q@mail.gmail.com>
 <c0c8dea4-1571-482e-be33-f965c7c357d2@amd.com>
 <20260915113752.GK13683@unreal>
 <92950084-ddd1-4868-a81a-bfe214184122@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92950084-ddd1-4868-a81a-bfe214184122@amd.com>

On Tue, Sep 15, 2026 at 02:59:43PM +0200, Christian König wrote:
> On 9/15/26 13:37, Leon Romanovsky wrote:
> > On Fri, Sep 11, 2026 at 09:58:28AM +0200, Christian König wrote:
> >> Hi Zhiping,
> >>
> >> sorry I'm completely underwater at the moment and don't have time to take another look at the full set.
> >>
> >> But IIRC you already fixed my documentation requirements and skimming over the patch once more I can't see anything wrong of hand.
> >>
> >> So feel free to add Acked-by: Christian König <christian.koenig@amd.com> to patch "dma-buf: add optional get_pci_tph() callback" and push it upstream through the VFIO channels.
> > 
> > Christian,
> > 
> > I'm slightly confused here. In the other thread, you expressed concerns
> > about having PCI details common to every device in the P2P world in the
> > dma-buf code, but here you seem fine with adding a niche P2P feature.
> 
> That one is only using u16 and u8 types and has no dependency on the PCI subsystem whatsoever.
> 
> Giving those adjacent information sounds perfectly fine to me, we just can't have any hard dependency on PCI subsystem types or functions.
> 
> DMA-buf itself is massively used with vendor specific P2P interconnects, PCI P2P is just a special case of that.

You are looking at it from the DRM perspective. Outside the DRM world, PCI is
THE interconnect, everything else is a special case :).

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > Thanks,
