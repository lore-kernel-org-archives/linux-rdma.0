Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769301;
	b=sA3Ehat5ExsdaHwN58CeedGrhfNqXLvFHsXJSEIEZjHJwqwyeHiRjvuoNQ9MyMVP+7fu
	 Emm9i0DO0skyAy5MmlHG8V9qT4H7tleiblownKl10C4LdjiYzQIqt/a5D9Jm9Xv2dayT5
	 uG5xEKpctqVpgwP0Rh/C1tFAu+ZQZbvd+1FQi03AcIymAPgU050mpXAQHGlYuk2TmyY2d
	 zhD8vREzBiBA/EfoI2XY1GEnN0z7j0ZaR4hbtyNJAXYFkCkKmzboVdHVyKuz192mmebFc
	 1fhS28+z2us46eUJKFtyYBW1KL1srWgI8UOqkblW0mFi1RZmZRlMELLNFDx49jvqqFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769301;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=i6aXJFxheMBmQpoYN3uuGJFUEJUWShe+IIjU3HSWCjA=;
	b=sqOXfb5ldL3zuKciqYcWskkdzRSkLt8TJvNBdp5zR0zTCr1M7ybkv4NBa3rb4X8faPMX
	 e86TmJuVnf+nY86dodxC8Qk5nJke2M7jAD6b0U6/izrTHeXJp4oqk2pK068u20efStEct
	 BhlTmBWyE+B/fq83oM3P22jIimY9dORnjJqIlViCfdljQyn9W6N1puO/kKBdrWVMaDyPK
	 ugeRZL2qbSIRhPY4Sh5jvc7+S4IPE/CKNxGBbWGGf2ygkyiJ2vdKnNBiPhQL28w97jZPC
	 v5r9T2LsiWJrS6l8Dv43hMA78X0QpWpUXq9Jzrs7BPb4A5Mj/xV6+3DpIC1L8818e4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWJSDEKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED8E606A31A;
	Sun, 15 Nov 2026 19:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWJSDEKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4A81F000C4;
	Sun, 15 Nov 2026 19:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794769300;
	bh=i6aXJFxheMBmQpoYN3uuGJFUEJUWShe+IIjU3HSWCjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hWJSDEKnalsdke3N5pJJ5OLMUOmSNVeL8/ZP66/Lb6aVB4Thip181TnPh8OuRmWnD
	 wQEqQlJbV9YxFRiHYHsK/3521Lbk1TKv0drP9y5eKiePM1RRfJbBMakAaykrWINb9o
	 Dvr364d1/LGYpUSRTg2Nz3gjdMeP9OxLDX/BkBJUgVCoe4hUi2HbjqNA+nC100h6V/
	 MrdkZBG5Vuv+7DlQL8XX4mZRc+2p/b7jrbRigsB5xRu5blftaxOkLwBsICwDIyVi/A
	 EivhUDioTbPEuc908QuF+R6s8rqxOZ0wFctMa+3mpcYttCdvG6b3ovIlijILIIg8et
	 XaeZEmDuJJeBg==
Date: Sun, 15 Nov 2026 21:01:35 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, hemanth.selam@gmail.com,
	yishaih@nvidia.com, edwards@nvidia.com, mrgolin@amazon.com,
	michael.j.ruhl@intel.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/uverbs: Fix radix tree node leak in uapi_add_elm()
Message-ID: <20261115190135.GH42525@unreal>
References: <20261106013908.21789-1-kartikey406@gmail.com>
 <20261110004550.GT663069@ziepe.ca>
 <CADhLXY7HKNvAM9=2J+VOVynDW39_PU=ohUKZkvwsqj=ZxSLbrw@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADhLXY7HKNvAM9=2J+VOVynDW39_PU=ohUKZkvwsqj=ZxSLbrw@mail.gmail.com>

On Sun, Nov 15, 2026 at 08:00:25PM +0530, Deepanshu Kartikey wrote:
> On Tue, Nov 10, 2026 at 6:15 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Nov 06, 2026 at 07:09:08AM +0530, Deepanshu Kartikey wrote:
> > > syzbot reported a memory leak of radix_tree_node objects allocated
> > > while registering a siw device:
> > >
> > >   unreferenced object 0xffff88810d78f488 (size 576):
> > >     radix_tree_node_alloc+0x81/0x1a0 lib/radix-tree.c:276
> > >     radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
> > >     uapi_add_elm+0x61/0x140 drivers/infiniband/core/uverbs_uapi.c:41
> > >     uverbs_alloc_api+0x85/0xc50 drivers/infiniband/core/uverbs_uapi.c:659
> > >     ib_uverbs_add_one+0x1b1/0x350 drivers/infiniband/core/uverbs_main.c:1196
> > >     ib_register_device+0x4fe/0x7f0 drivers/infiniband/core/device.c:1503
> > >     siw_newlink+0x36a/0x3f0 drivers/infiniband/sw/siw/siw_main.c:433
> > >
> > > radix_tree_insert() can fail with -ENOMEM after __radix_tree_create()
> > > has already linked intermediate nodes into the tree, leaving them with
> > > no entries. uapi_add_elm() frees the element on failure, but nothing
> > > frees these empty nodes: uverbs_destroy_api() only removes populated
> > > slots, and radix tree nodes are freed only as a side effect of
> > > deleting an entry. The nodes are therefore leaked when the uapi is
> > > destroyed.
> > >
> > > On -ENOMEM, populate the same key with a dummy entry and delete it
> > > again so that radix_tree_delete() reclaims the empty node chain.
> >
> > That seems like an absurd thing to do, can we fix
> > uverbs_destroy_api() to free the entire tree rather just populated
> > slots somehow?
> >
> > Jason
> 
> Hi Jason,
> 
> Agreed. Since radix_tree_root is now an alias for struct xarray,
> uverbs_destroy_api() can call xa_destroy() after removing the
> populated slots, which frees all remaining nodes. I'll send a v2
> with that and drop the dummy insert/delete.

Can you please elaborate more about this sentence "which frees all
remaining nodes"?

Thanks

> 
> Thanks,
> Deepanshu
