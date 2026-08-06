Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20666456DE8;
	Thu,  6 Aug 2026 11:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786014436; cv=none; b=OC/Cy9hVtRElAehpNhvrbWsczIyG1r2oNGxAVmOlFqA140D4gpeW7NGJuMrT5jlRBT64cxgLvJ4PxsBAIUKLvUslJf6DtFxqZq0KJ5Ow2tmdT2Lk0HwpcIHN5ZwhNuPlmUuIzAQ42TEybjBi2XbNdAB61eGr18WR064vtvw3Ajw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786014436; c=relaxed/simple;
	bh=Q5IetjW607s+50JHzcCVB6cYHECH9/FaNtKK5P85ahk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOVHP7pb7jQhPkEi9eX9pRwyfLGIpDT6YeYjgw+52bI7syc0Eqq7Cv3GByxZfyJoMBGdFjoxRB39jciU6DbN4/7KhH+aEiNMhtvLzA+/9KjEPO47WiKHQjhPKadiXcFJNLroUKuyrOUS7U8VJVR4+t0xF8o/Fo1EgHwEcWlCtDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eveOsmyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eveOsmyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB411F000E9;
	Thu,  6 Aug 2026 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786014431;
	bh=MmTKH2SEmjcziRHSYZ+KjGQNN7Qp+xdNk8UAWwp8R9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eveOsmyu5NbZMr3SKuI39XskcXTUuXxh99nMhWMj5Hn4Ss/dODAzeaWVy821N9XMl
	 mZLiBVttmbH0ViwIirOZcosL6JY7vcLJCNZ48RuN/rPMFFErze7yvIgDso6oA7DPBN
	 JJcY89pYSU/yBZzDdrdfpecuZjrCAv7kpuToXGgS4cvwZpUJ3sUDj29/BuvAaR2OEj
	 eIM9H4Iag8iGQP4ykbzhQOuiP68h0+VelMQvcjk9017ebEWTfzWOr/O6JdrrGmCY+d
	 fs8EteBSZU8ePt+b5UsLPo5o66wrZd22M54DWszGAEFKqtXHQmZgjnaOG3dWFD4qRh
	 QrtYucRFS72Aw==
Date: Thu, 6 Aug 2026 14:07:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, Long Li <longli@microsoft.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Message-ID: <20260806110705.GE23431@unreal>
References: <20260731091041.2250897-1-jiri@resnulli.us>
 <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>
 <anCBtLSxn8TtFcSz@FV6GYCPJ69>
 <20260803132844.GA326170@unreal>
 <anHFniO-9SrlUx0O@FV6GYCPJ69>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHFniO-9SrlUx0O@FV6GYCPJ69>

On Tue, Aug 04, 2026 at 01:08:18PM +0200, Jiri Pirko wrote:
> Mon, Aug 03, 2026 at 03:28:44PM +0200, leon@kernel.org wrote:
> >On Mon, Aug 03, 2026 at 01:59:07PM +0200, Jiri Pirko wrote:
> >> Fri, Jul 31, 2026 at 02:54:31PM +0200, kotaranov@microsoft.com wrote:
> >> >> From: Jiri Pirko <jiri@nvidia.com>
> >> >> 
> >> >> Commit eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata") renamed the
> >> >> "flags" field of struct mana_ib_create_cq to "comp_mask", as
> >> >> ib_copy_validate_udata_in_cm() only validates a member with that name.
> >> >> 
> >> >> The layout did not change, but the field has been a part of the UAPI since
> >> >> commit 44b607ad4cdf ("RDMA/mana_ib: implement uapi for creation of rnic
> >> >> cq"), so the rename breaks userspace referring to it, for example the mana
> >> >> provider of rdma-core assigning cmd_drv->flags.
> >> >> 
> >> >> Convert the field to a union providing both names, so that
> >> >> ib_copy_validate_udata_in_cm() still finds "comp_mask" and userspace keeps
> >> >> "flags", without having to add a helper for this single case.
> >> >> 
> >> >
> >> >Thanks for the patch, but my understanding that it is a common practice to rename the fields,
> >> >and kernels headers should not accumulate historical names. 
> >> 
> >> That is not doable in UAPI.
> >
> >There are multiple levels of UAPI contracts. In RDMA, we guarantee
> >binary compatibility because userspace (rdma-core) is effectively the
> >second half of the RDMA driver stack. These drivers do not exist
> >without rdma-core.
> >
> >As such, this is exactly how the RDMA UAPI is intended to work.
> 
> That is some odd UAPI...

It is not about UAPI itself, but about the rules governing it. The
rule is "don't break userspace"; it does not say "don't break the
build". The latter primarily affects advanced users, who are expected
to be capable of resolving build failures.

Thanks
