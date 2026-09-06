Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A883A45038
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 06:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788675238; cv=none; b=SnczrV3xG8gw6dHWdxJKMsCEyux8iv+wgOg2x7wp5bhzsqY7tcQCIggupSRdHMylbDtzzSBLhvi/ZZnKH9OYk/PsgtoQqsHV8yJqzndP+Lyr3KuBRqdgfdaDzbunXOQH/+2YXrnhyjUECt/slbf0dfRLle70N/vtybrwrL2NJBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788675238; c=relaxed/simple;
	bh=9ZG5lGBVy3Updp+uGRuJk2PL/ry2F280NMF/pQ6TFAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POm0bkE8UARpfIDLKGQkYvs/T9CgGN8qmTzVjvTP42/pOFyRag7hAMIfjMOLmRfNXfSi8XWNYnhp1+RMwxLEI5vnfJpFz7lv4mTdfT+Jx4BcLTcuvpvolrAsjtBdwsJw90Ql1e+0PjjHhQAyySVUDBzBaEFeXti4px7QYFCOsmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxdQPA+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxdQPA+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5314C1F00A3A;
	Sun,  6 Sep 2026 06:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788675236;
	bh=ogE5EW9VU2hECLVrFVvXpprs37Mbqd+ytzQbo+fs5jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UxdQPA+c7olXQNk1tXefNnKIGNiroQuqpIrqmUoH74H5tLPqc2/pxlEkqXzkw4Pe0
	 Iquzn6ZEAC+w8ao/OHEHBuaBnR1xX5Jz0NpUlJCgOmyvbbLoQw066axSkDfFEQyFcV
	 ALUBX21JUx1PiBuhwL026le5EfwO8JtMFWasvifsfk17mFIWwV5V1iNKWhs++7MSAP
	 wsF+nRaj4IV3/0FfK/GXqe5sWDILcsJOdRvMEALQbUcgxJarUI2uKWpUBie39kmESJ
	 24nhr9p/bapU9kZH2Nbj3RfHzdl2ds8c8q9i5UznXNbpxQ17HhIMMW/G5CLd768pPi
	 VpTnXtV/3Gu5g==
Date: Sun, 6 Sep 2026 09:13:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Stefan Metzmacher <metze@samba.org>,
	Kees Cook <kees@kernel.org>, Or Gerlitz <ogerlitz@ddn.com>,
	Norbert Szetei <norbert@doyensec.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/cma: publish service records after initializing them
Message-ID: <20260906061352.GA13683@unreal>
References: <20260826110213.18378-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826110213.18378-1-lirongqing@baidu.com>

On Wed, Aug 26, 2026 at 07:02:13PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> cma_query_ib_service_handler() stores the freshly allocated
> service_recs array and its count before the records are filled in:
> 
> 	id_priv->id.route.service_recs = kmalloc_objs(*recs, num_recs);
> 	...
> 	id_priv->id.route.num_service_recs = num_recs;
> 	memcpy(id_priv->id.route.service_recs, recs, ...);
> 
> ucma_query_ib_service() only holds ctx->mutex and is not serialized
> against this SA callback.

No, this sentence is wrong.
ucma_query_ib_service() holds ctx->mutex and cma_query_ib_service_handler()
is executed under same mutex too.

mutex_lock(&ctx->mutex)
rdma_resolve_ib_service() ->
	cma_resolve_ib_service() ->
		ib_sa_service_rec_get() ->
			cma_query_ib_service_handler()

Thanks
