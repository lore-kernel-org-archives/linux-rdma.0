Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFCB2F90C9;
	Mon,  3 Aug 2026 13:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763734; cv=none; b=jlq0BwKelq3BK85ANDNrJ0ahgzs6N6Ppy2e5UC0xZNLUTr2p+0ahjM3nbr2Hl/coXwV0ZxOQcs28ENEd/iU9CulZqZsWlQEUtvCnVq6WFTWmYzSaB/fO5J5TKd9NC5hl5bddd1Zwj9GYA2NGFaf/8+K5fzGpa/n4JQBcRAkiego=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763734; c=relaxed/simple;
	bh=NmsbuP4sxYPLIuHtMaVJW1mUSURb4adPASbdHW32UdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YT5g6rcWWxJibeDItiQTmrDKa52DRUbkD3Qh/n1du/QTXJTFrysfEJvxcC18T+9SFloTkEbV9+OHHcjC9M4pRgD63x7BkgV0bPte9KhalJxtFirPYB7MUUvPAJKF8l/LJdxJ0VoRqlgxTFw/fIpVNJT0fuf3DhjqOwoMRnKhlwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkq+xdd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkq+xdd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AD71F00A3A;
	Mon,  3 Aug 2026 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763730;
	bh=ceV4pa/7DQBIYiXQtOkDImv4vmXRhkjRfa6y8CVaaSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nkq+xdd5nBFVe4jQqFZyqUu7sOkbzp+BcXgRymlQ5YjNKWOyHLuuezHxrF2+Y3j/3
	 xEEI0RvczvVA4unkjyhdQNOQ1fPpPYCroDPLWxKK1saa2ce9JK5DvxJVeUheHSHA9a
	 IbP+VpzPXGdUHotSwYYlE7rpx/oiCcYQwS9kBeaUXRycNqKxc0X7hafr7hmm/wW1ko
	 rxEwyvO0HQhPt8u4nPntoHNurooLHOo8C02JnxoKV0a9TYV9ExYYEXBTHEmIj72Afd
	 9LcCa9jRlWcRQX1kDvIneVx0A+htP1wPtE7ls2guJdHI2SuMdANcPNGH7ndlDwH1Ki
	 OIUs/H780xCyw==
Date: Mon, 3 Aug 2026 16:28:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, Long Li <longli@microsoft.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Message-ID: <20260803132844.GA326170@unreal>
References: <20260731091041.2250897-1-jiri@resnulli.us>
 <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>
 <anCBtLSxn8TtFcSz@FV6GYCPJ69>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anCBtLSxn8TtFcSz@FV6GYCPJ69>

On Mon, Aug 03, 2026 at 01:59:07PM +0200, Jiri Pirko wrote:
> Fri, Jul 31, 2026 at 02:54:31PM +0200, kotaranov@microsoft.com wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> Commit eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata") renamed the
> >> "flags" field of struct mana_ib_create_cq to "comp_mask", as
> >> ib_copy_validate_udata_in_cm() only validates a member with that name.
> >> 
> >> The layout did not change, but the field has been a part of the UAPI since
> >> commit 44b607ad4cdf ("RDMA/mana_ib: implement uapi for creation of rnic
> >> cq"), so the rename breaks userspace referring to it, for example the mana
> >> provider of rdma-core assigning cmd_drv->flags.
> >> 
> >> Convert the field to a union providing both names, so that
> >> ib_copy_validate_udata_in_cm() still finds "comp_mask" and userspace keeps
> >> "flags", without having to add a helper for this single case.
> >> 
> >
> >Thanks for the patch, but my understanding that it is a common practice to rename the fields,
> >and kernels headers should not accumulate historical names. 
> 
> That is not doable in UAPI.

There are multiple levels of UAPI contracts. In RDMA, we guarantee
binary compatibility because userspace (rdma-core) is effectively the
second half of the RDMA driver stack. These drivers do not exist
without rdma-core.

As such, this is exactly how the RDMA UAPI is intended to work.


> Some userspace app, like rdma-core in this case, might use it and rename breaks the compilation. Some other
> app you don't know about may use it.

rdma-core does not use these headers directly. Instead, it vendors
them in the kernel-headers directories specifically for this purpose.

> 
> 
> >I also faced a similar problem from renames in other providers, when I needed a new kernel header in rdma-core.
> >If this breaks your rdma-core in a PR, just remove the field rename in kernel update commit as that header update commit is not getting merged anyway from your PR.
> >My understanding that maintainers of RDMA-core will merge the kernel header update, and will bring this change from my PR:
> >https://github.com/linux-rdma/rdma-core/pull/1765/commits/0dcadd9316f1b98e21973e3a6e0f96186d49bd5a
> 
> this is not how UAPI can be changed :/ It simply can't be changed.

It can, at least in RDMA and elsewhere in the kernel, where user
access is provided through properly designed libraries.

Thanks

> 
> 
> >
> >- Konstantin
> >
> >> Fixes: eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata")
> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> ---
> >>  include/uapi/rdma/mana-abi.h | 5 ++++-
> >>  1 file changed, 4 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
> >> index 410f0ddc8c89..431c7076f20a 100644
> >> --- a/include/uapi/rdma/mana-abi.h
> >> +++ b/include/uapi/rdma/mana-abi.h
> >> @@ -25,7 +25,10 @@ enum mana_ib_create_cq_flags {
> >> 
> >>  struct mana_ib_create_cq {
> >>  	__aligned_u64 buf_addr;
> >> -	__u16	comp_mask;
> >> +	union {
> >> +		__u16	comp_mask;
> >> +		__u16	flags; /* the original name of the field */
> >> +	};
> >>  	__u16	reserved0;
> >>  	__u32	reserved1;
> >>  };
> >> --
> >> 2.54.0
> >
