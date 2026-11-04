Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785274;
	b=DV626SdpG6V94M2i/HLNigBXHYyE9CLL9G+dfGrgOndB63HNFY1swlnOfYOclpMoO2Nh
	 y/KvhJxQxuvEm4x7/UhUrUGOS4I8jDUXpVJEh8PgfbsB9NDhbZhZb2SAud5hHQyIPo6tw
	 WqVEpe02Tf/2U9uMVoD3DyR79/ND6ixyAATFk7eI/gt0HPv5zDUzzXIjd4J+vZTGxc2Jw
	 9zyZMcTO02ynNwirsYeEEvbrcVmlxbkHLECjzpB9jRxb5NJ63ng5LYBES2eJEcHDaYaeM
	 15Jb2A5h6IKpOE0SZeDfZSIAEZIdHV8HxDvw+LnKsj5qwLdUCZGFTYMtFlYgPy3lLnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785274;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=+cJ4KNzcMaefS9I+1TQiXspSd3iTXdGT/XxcZpXEYXU=;
	b=4iOoRHUOLh6Gesn5ofGBioPliCDavSc/fKWD67t4Whq6xUJJ0AZ/NJsDN7pmxyMA891S
	 /TnXKAopaoVNFpt4nBK1Y1/j3nH/ta6dGw33i5zHvJSWYKP+lR1omfLW2oPenCVSbsYSM
	 k3m+iVYWhELK9qlUbn52xC/xAaxmZbMP/tzmEqf2it9w1VyxJSQjFIQeDvfuOfXZcGPis
	 F/mF+wegu+CDaWaS8grX8+t9dKNvxOUM/uFI2Hv2A0JgWViQwEKT7W12mdYNxdd5y1iEK
	 2/X1kg8GFiweMkqEJpeJzxdLihtaC5pu3K9uVlMD8zmzL6t0VwclUw9wSZjhKyrrbMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I/qoaeEr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2DB606A326;
	Wed,  4 Nov 2026 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I/qoaeEr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF21F000C1;
	Wed,  4 Nov 2026 09:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785273;
	bh=+cJ4KNzcMaefS9I+1TQiXspSd3iTXdGT/XxcZpXEYXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I/qoaeErUlBNL23HwnagcgQ64ZOEFcyFW3R2jGEzVehY3XShVlbUwCTpMQadGh4zF
	 Y/2+KO0zOqBAp1ZNqgnesc2dlxH4/xN0Hm0oGfD151ZWo4wN9jNkUDSVHRANztXHEL
	 yPTX8BJxFRv6akt78VhrgAyVwR7OE+6pM2UCYVyiTDCNmNmbgTeMMj5lSTumZQYwDq
	 0yOrCfyRhX5LH+pm1i2kxx7+2zY6wceFgJZuAYWatBppmCYk5IndiQ0/3Tg84ZHRB2
	 rOaUf2Ezqy8d6DP1vUioKBCFDHntHfO7ybMCNoy26v4CJTw4YeK0xP4reZwgUz3/Af
	 +aFdL4Df+4G8Q==
Date: Wed, 4 Nov 2026 11:41:08 +0200
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Konstantin Taranov <kotaranov@linux.microsoft.com>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Enable RDMA devices on the CDX
 bus
Message-ID: <20261104094108.GA478286@unreal>
References: <20261103115032.736554-1-kotaranov@linux.microsoft.com>
 <sashiko-outbox-195213@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-195213@kernel.org>

On Tue, Nov 03, 2026 at 12:05:41PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] RDMA/mana_ib: NULL dma_parms in mana_ib_probe() on CDX devices
> --
> 
> commit 4f88c8811c923b9c16d7e0dbf8674249f05b4f08
> Author: Zhiyue Qiu <zhiyueqiu@microsoft.com>
> 
> RDMA/mana_ib: Enable RDMA devices on the CDX bus
> 
> This commit enables MANA RDMA on the CDX bus by depending on the shared GDMA
> core, matching CDX auxiliary devices, mapping non-PCI userspace doorbells
> with pgprot_device(), and reporting the Microsoft vendor ID directly.
> 
> > diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
> > index 62c7803ca6c60..33e47490755f6 100644
> > --- a/drivers/infiniband/hw/mana/device.c
> > +++ b/drivers/infiniband/hw/mana/device.c
> > @@ -257,6 +257,8 @@ static void mana_ib_remove(struct auxiliary_device *adev)
> >  static const struct auxiliary_device_id mana_id_table[] = {
> >  	{ .name = "mana.rdma", },
> >  	{ .name = "mana.eth", },
> > +	{ .name = "mana_cdx.rdma", },
> > +	{ .name = "mana_cdx.eth", },
> 
> [Severity: High]
> When mana_ib_probe() binds to mana_cdx.rdma or mana_cdx.eth, does passing
> gc->dev to ib_register_device() trigger a warning and fall back to a 64 KiB
> DMA segment size limit because gc->dev->dma_parms is NULL?
> 
> In drivers/infiniband/hw/mana/device.c, mana_ib_probe() registers the IB
> device with gc->dev as the dma_device:
> 
> 	ret = ib_register_device(&dev->ib_dev, mana_ib_is_rnic(dev) ? "mana_%d" : "manae_%d",
> 				 gc->dev);
> 
> And in drivers/infiniband/core/device.c, ib_register_device() checks:
> 
> 	WARN_ON(dma_device && !dma_device->dma_parms);
> 	device->dma_device = dma_device;
> 
> Unlike struct pci_dev, struct cdx_device does not attach a dma_parms
> structure, which is noted in mana_cdx_setup_hwc_irqs() in
> drivers/net/ethernet/microsoft/mana/gdma_cdx.c:
> 
> 	/* The PCI path also calls dma_set_max_seg_size(), but that is
> 	 * deliberately omitted here: the CDX core does not attach a
> 	 * dma_parms to the device, so the helper would only WARN, and MANA
> 	 * never builds scatter-gather lists, so the limit is never read.
> 	 */
> 
> In addition to triggering the warning in ib_register_device() on probe,
> mana_ib_create_queue() and mana_ib_reg_user_mr() build scatter-gather lists
> via ib_umem_get_cq_buf_or_va() and ib_umem_get_va(), where
> __ib_umem_get_va() calls ib_dma_max_seg_size() -> dma_get_max_seg_size() and
> falls back to SZ_64K instead of UINT_MAX when dma_parms is NULL.

The analysis looks correct to me. How was it tested?

Thanks

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261103115032.736554-1-kotaranov@linux.microsoft.com?part=1
> 
