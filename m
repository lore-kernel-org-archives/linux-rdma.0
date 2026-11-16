Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827730;
	b=jqDadgMDRcntiXwWZKiaqbUuBWxmXpMDPEtNgvBF9W/O4KjEudxog3ucjw6GrLN4biN/
	 /jrlcrx+z6R/6DR7+AwfsnJiRUoae51ln/HQbTBWtA5O7u5QUELAojmGqF1QOQK+SPl73
	 2zaxGnti/hVMOuadJ65aYdqaaVFwMxuaIdupAtySyRLA20mRI33TKO+wK07Te/+iukljL
	 GHV6UF7WljrX4QxlFyy1y5gNBFXB/nFpevCA7Y3z8m1H9OCmmAubPlkhKqQt/Y8aiXEYg
	 Y0u+/uOHTpusKtJvhQrjB732d1qSvcj1CPHN2QB/FYHkaYYD1+WZHa/YRmyNGoOylQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827730;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ydckW8oreVdglh0/os1ZEAzHkaThw7PcNlQbyjNKfnw=;
	b=46x1EYBJkFOznm/hHo5LP4V9uusYbwGoNKFHJ0QAt2R54Y4ugrPzvF3PBaBE9KUc95NS
	 UoN4N3vSi2bjU4P3XHvZbMU5qenhkreFUjHYWVOsWOR5HGM45Dneazwgpw6oW+1kgiVgk
	 27wM8k86Hw6cpr9iNPIIKCiRxPHmdJMNq6+7jDON/eR1QmE1St0SQ2uQ8hBi45DiylwvL
	 mnMj3OWkfsEmstKb2qtaO3Mx9UOC5cu0/YPZy+zRxNidPVhb3ONHGLdqKPY3E8SDsGM0R
	 JdJFn2ErTLtH/VgdNHFEE1FX5OPz14a4XKN4/9XlkDXmrqRAYAe9OIh4s/SLvOPCJ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ljt+SaR4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635B1606BE34;
	Mon, 16 Nov 2026 11:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ljt+SaR4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442931F000C4;
	Mon, 16 Nov 2026 11:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827729;
	bh=ydckW8oreVdglh0/os1ZEAzHkaThw7PcNlQbyjNKfnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ljt+SaR4D98ygNDHQlQlA5jDPNRphrXLiOEvs4unFRGXb58Yx69WDAIbSZTC83vlI
	 yeRxnNdrmftttmE9fN1R/qLEKtN38ls8EmuXEINjT5HfUgld/mmfrgqS0o0bciAytZ
	 Xh7fI3H9bxncDBd91lEb45KPKC73PfryDn1JXphTTvqvROOHm52t6WFUwBMJwgdAQB
	 iZsPpFJIe+P1nvW33/9eGYptqJCC8Kf7sHWr1V/5mGIR0EEXe+RcBWYTvI37aEDhsE
	 7HIXC5q5lsCJhY1/UhW6x6nnDIAViJMO7pyYkZLh8GzDpxKqQ2UjBBGZPRfC7aiLHl
	 oZN3ZgO+p/3MQ==
Date: Mon, 16 Nov 2026 13:15:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Changyul Lee <lcy8047@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cm: Read the remote_id_table root under cm.lock
Message-ID: <20261116111526.GH11319@unreal>
References: <20261111191913.98044-1-lcy8047@gmail.com>
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
In-Reply-To: <20261111191913.98044-1-lcy8047@gmail.com>

On Wed, Nov 11, 2026 at 02:19:13PM -0500, Changyul Lee wrote:
> cm_find_remote_id() reads the root of cm.remote_id_table before it
> takes cm.lock. While it waits for the lock, cm_destroy_id() or
> cm_reset_to_idle() on another CPU can remove that cm_timewait_info from
> the tree and free it, and the lookup then starts from freed memory.
> This lookup is done for a REJ with reason IB_CM_REJ_TIMEOUT.
> 
> Read the root after taking cm.lock.
> 
> Fixes: cfa68b0d0440 ("RDMA/cm: Make find_remote_id() return a cm_id_private")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>
> ---
> Found with a static analysis tool we are developing.
> 
> Reproduced in QEMU (x86_64, KASAN) on rdma_rxe over virtio-net, with a
> test module that connects to a listener on the same device through
> rdma_cm and destroys each active cm_id while it is in IB_CM_REQ_SENT,
> so a REJ with IB_CM_REJ_TIMEOUT is sent. Another kthread destroys the
> passive cm_ids. The window was widened for the test with an msleep(20)
> between reading the root and taking cm.lock. Without this patch, KASAN
> reported 46 to 48 slab-use-after-free reads in cm_work_handler() per
> 20 second run in three runs, on a cm_timewait_info allocated by
> cm_create_timewait_info() and freed by cm_destroy_id() through
> cm_reset_to_idle(). With it, there was no KASAN report in three runs.

I'll take this patch, since it's simple enough. However, using a test module
that misuses an in-kernel API is not the right approach.

Thanks

> 
>  drivers/infiniband/core/cm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 1a2c2775b14d..5347b7519a8d 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -734,11 +734,12 @@ cm_insert_remote_id(struct cm_timewait_info *timewait_info)
>  static struct cm_id_private *cm_find_remote_id(__be64 remote_ca_guid,
>  					       __be32 remote_id)
>  {
> -	struct rb_node *node = cm.remote_id_table.rb_node;
> +	struct rb_node *node;
>  	struct cm_timewait_info *timewait_info;
>  	struct cm_id_private *res = NULL;
>  
>  	spin_lock_irq(&cm.lock);
> +	node = cm.remote_id_table.rb_node;
>  	while (node) {
>  		timewait_info = rb_entry(node, struct cm_timewait_info,
>  					 remote_id_node);
> 
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> -- 
> 2.43.0
> 
