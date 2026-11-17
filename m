Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938975;
	b=v/XzRrQir54NO4g/UTfksiXmhjT6e8/mcX2uVny/s3FeBM38n2RmdZaf8cPRQDjoakmV
	 aNrJfSBUWXXtBZYjYIhUJnGEMnyenkbQwJiLVRHR4cDqICJmbtFOa1hGs6K4HkOEsXvBa
	 oYSqKNQ+6aQr6DAVif8HIJ7p+T9oIAoYE2aVLQJSVxVa6SONJp92jp+p/jfYd2QlPjQpV
	 X2UgOQYVr+IkArlGBN6gEzBMLW9G/UDWxgUdxLUjRcc1EqYewYMwVCDzpto4+Jqqou3sD
	 YofMYH+WQ94seS6i9K90uB+E4zIKSFg4lxygKhZzPPUmaXevoYYM5U7kqA3bq9Sjlhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938975;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BsKxt9nBAEfHX3Rjct/RuZ6P/gqzP6gTfo1UjEyhmRg=;
	b=yanHkJPqbFtaLynAMEAwdmhQmGDF+LyUDGvOmvSZWOCuNyS6l/RzGR7C9lLDN5BSFzQy
	 sVsX28u1i2zhVsepeJ/PnjZp5HmN1246XiyVgLfnl4yqYd7App1hcmYPOCES7zCsRFwYj
	 jMs7RjFLcUYg2ycJ2IK+iz+dlEsrZNAUmxOzKaAJSvKLaL+YpONinV+GcaMS+YvGj8oRf
	 ABHlRgIIcKjdgVramAKDuyuuZlt3MYCsjK3Xu1mIGb4wIi4A4lG1BLMoG8ZqukIciacEk
	 9Zgha22xUcPxOjuyEROFITUUWOLbjXVoG0swlDZrZwKFiHbkutBA76C3v+2cv84HQTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X9bgNJXQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20B1606A31C;
	Tue, 17 Nov 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X9bgNJXQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5A71F000C4;
	Tue, 17 Nov 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794938975;
	bh=BsKxt9nBAEfHX3Rjct/RuZ6P/gqzP6gTfo1UjEyhmRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X9bgNJXQaOXS1uA/Of7mTNbh5+XkG0/WlduzwZAR/P1OlrcTQsurTkjIMJc6MQMm9
	 R+U6ZngdfMXMalhwFOUWVJn8VAw2lp7+MsOrm7bTNiczmVru8ilT0OSpWzrXsR2Dja
	 03QA/maQ/odkiL6qE41DxRGCrpgzHTlY99y0aSpszjFWdADbshxHHR+egN26yOZenQ
	 FdZLFb3VCJnUZyWFxwoi6V+NkS+TsiLUO6Up1iTT9zyiQOLB/68sLJUknqDLSV/XnB
	 xS8j+UeusWkmCkw3PdTzGf9QIARNp08XUPnXlqHXmkP6CtulZj+H6MfORn1OUsGCUB
	 SpK4IcmwfOqFQ==
Date: Tue, 17 Nov 2026 20:09:31 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
	andrew+netdev@lunn.ch, jgg@ziepe.ca, haiyangz@microsoft.com,
	wei.liu@kernel.org, decui@microsoft.com,
	shradhagupta@linux.microsoft.com, horms@kernel.org,
	ernis@linux.microsoft.com, stephen@networkplumber.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com, kees+treewide@kernel.org,
	kees@kernel.org, mawasthi@linux.microsoft.com, weh@microsoft.com,
	edumazet@kernel.org, shacharr@microsoft.com
Subject: Re: [PATCH net-next v11 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Message-ID: <20261117180931.GE162713@unreal>
References: <cover.1794751992.git.weh@linux.microsoft.com>
 <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com>

On Tue, Nov 17, 2026 at 04:01:01PM +0000, Wei Hu wrote:
> From: Long Li <longli@microsoft.com>
> 
> The HWC starts with depth-one bootstrap queues. Treat the PF-reported depth
> as a maximum and rebuild the channel exactly for reports from 2 through
> 128. Keep the untouched bootstrap queues for depth one and reports above
> 128, and require a rebuilt channel to repeat the selected depth.
> 
> Treat the reported request and response sizes as directional maxima.
> Rebuild only when both reports equal the 4096-byte bootstrap allocation.
> Keep allocation strides separate from these limits, and share the effective
> host-to-PF request budget with the GDMA and RDMA request builders. Bound
> RDMA CREATE and ADD_PAGES batches by that budget, checking that the headers
> and at least one page address fit before subtracting their sizes.
> 
> Require nonzero depth, request-size and response-size reports before
> deciding whether to keep the bootstrap queues. Apply the same validation
> to a restored bootstrap channel. A missing or zero required report fails
> with -EPROTO, even at depth one; do not silently substitute guessed limits.
> 
> Reject oversized messages before acquiring a slot or publishing caller
> storage. A retained, stopped channel still returns -ENODEV rather than
> reporting a size error against uninitialized negotiated limits.
> 
> Keep each candidate private through queue creation, establishment and the
> direct EQ test. Publish only the final tested channel. If a rebuild fails,
> including its functional test, tear it down and restore fresh, tested
> bootstrap queues. Stop if teardown is not acknowledged; never reuse
> PF-owned mappings. Restore the previous live timeout budget before the
> fallback so a failed test's fail-fast reduction does not poison the retry,
> without reviving terminal cancellation.
> 
> Invalidate the previous HWC doorbell before every ESTABLISH_HWC. Validate
> the BAR0 page geometry and reported index before accepting a new doorbell,
> and suppress MMIO while it is invalid. The original driver accepted an
> unchecked device-supplied index in its MMIO address calculation; this also
> fixes that existing out-of-bounds MMIO path. Backports need the complete
> ownership and validation dependencies, not the entire feature stack by
> default. A malformed doorbell completes initialization with -EPROTO without
> relying on later INIT_DONE events that might require re-arming through that
> doorbell.
> 
> Use the initial PF report to select the queue geometry. The PF directs
> this choice; the absence of VF size fields in ESTABLISH_HWC does not require
> keeping the bootstrap geometry. Driver-version advertisement occurs after
> HWC establishment and cannot negotiate behavior needed during creation.
> 
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
> Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@kernel.org
> Link: https://lore.kernel.org/r/179455240227.2199510.2666165032389090040@kernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>
> Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
> Copilot-Session: 8c2361e6-c0f4-4b0c-bf01-b5e4cdacec50
> ---
>  drivers/infiniband/hw/mana/main.c             |  19 +-
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  26 +-
>  .../net/ethernet/microsoft/mana/hw_channel.c  | 316 +++++++++++++++---
>  include/net/mana/gdma.h                       |   2 +
>  include/net/mana/hw_channel.h                 |  19 +-
>  5 files changed, 317 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> index 7d5a8fc7380d..6e036a25a9f7 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -427,28 +427,38 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
>  	unsigned int create_req_msg_size;
>  	struct hw_channel_context *hwc;
>  	struct ib_block_iter biter;
> -	size_t max_pgs_add_cmd = 0;
> +	size_t max_pgs_add_cmd;
>  	size_t max_pgs_create_cmd;
>  	struct gdma_context *gc;
>  	size_t num_pages_total;
>  	unsigned int tail = 0;
> +	u32 req_limit;
>  	u64 *page_addr_list;
>  	void *request_buf;
>  	int err = 0;
>  
>  	gc = mdev_to_gc(dev);
>  	hwc = gc->hwc.driver_data;
> +	req_limit = mana_hwc_get_max_req_size(hwc);
> +	if (req_limit < struct_size(create_req, page_addr_list, 1) ||
> +	    req_limit < struct_size(add_req, page_addr_list, 1)) {
> +		ibdev_dbg(&dev->ib_dev,
> +			  "HWC request budget %u is too small for DMA region commands\n",
> +			  req_limit);
> +		return -EMSGSIZE;
> +	}

No. Make sure you also call mana_ib_gd_create_dma_region() with valid parameters.

Thanks
