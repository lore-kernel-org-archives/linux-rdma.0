Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6941E570D;
	Fri, 27 Feb 2026 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772153771; cv=none; b=MvKOYhLZA4aHZdhoqWHI/BtGpWkVff53m8cZdd07fQZZ5bPAuJEEVDrxZkooHv5LBO5Tp0/xzRsnOxrsYu8uC+TaTEBaRennnG841zBqpR9f7+bHfYpt+AyQpPLjI3EhBOTsDBw90E8nwYSjECP4qSc/W7GOUOCg04Rh5MMRzKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772153771; c=relaxed/simple;
	bh=+S7zYZsdu0WacFrE45kUE7EgJJuP3ii1APz8o9WAnTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JS85rm1YGHxaQp7hE6e7Y6ztfDMgMFG9l1hd20qVIfySY4RjolXC7pEVt7oNJtFjC1SimC8PBKbDD2/KTFEhKuoIA+uJXU7y7vxvYkdNPOVl3sHjR3ymxlt7cZ7lt3R5L4u6Yq01qfrBAjBxHbFP9JIwCQXtNcow9DCx+IyqpTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNtYZnfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNtYZnfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE24C116C6;
	Fri, 27 Feb 2026 00:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772153770;
	bh=+S7zYZsdu0WacFrE45kUE7EgJJuP3ii1APz8o9WAnTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RNtYZnfqrWSMog4trw9W/VxWf/ECyF52xUHLxU2TJwqo1lw9Zm96BLKiVQp1C1kq8
	 ozuaki1jAUzVb7kVzzx/em+XSBUDr3Zdqvi8MuCKSSV2/6pu3x3TiIZ5TlCq7PuzSa
	 8akY65SXNQAndUEv9WJfW+dSTZH7tUDpL04zvcZGy5L4cxpStl79FlasJmxmVYJAmf
	 QVcGewsKQWQJftrTxW32tiJpAaEHGtDRufXmHoLBdnGgeQ1cGBuuT9r2Mw1iw+OQWB
	 KBOGz10+O80fHMGrlRiXlypJ03cXyfbhohL2RiPGCBW2zP+2PhPwyy169rPuKxsCBQ
	 UM5aO1wLf7tWA==
Date: Thu, 26 Feb 2026 17:56:07 -0700
From: Keith Busch <kbusch@kernel.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Yochai Cohen <yochai@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [RFC 1/2] Vfio: add callback to get tph info for dmabuf
Message-ID: <aaDrp7teQoutU79s@kbusch-mbp>
References: <20260210194014.2147481-1-zhipingz@meta.com>
 <20260210194014.2147481-2-zhipingz@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210194014.2147481-2-zhipingz@meta.com>

The subject prefix should be lower case "vfio" to match the subsystem
commit style.

On Tue, Feb 10, 2026 at 11:39:54AM -0800, Zhiping Zhang wrote:
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ac2329f24141..bff2f5f7e38d 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1501,6 +1501,8 @@ struct vfio_region_dma_range {
>  struct vfio_device_feature_dma_buf {
>  	__u32	region_index;
>  	__u32	open_flags;
> +	__u16   steering_tag;
> +	__u8    ph;
>  	__u32   flags;
>  	__u32   nr_ranges;
>  	struct vfio_region_dma_range dma_ranges[] __counted_by(nr_ranges);

I don't think you can add fields to a uapi struct like this since it
breaks comptibility. Instead, I think you may be able to carve it out of
the "flags" field since it's currently reserved to be 0, so I guess it's
potentially available to define a new feature.
