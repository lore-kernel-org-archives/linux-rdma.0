Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6EA3D7D8D
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 09:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193092; cv=none; b=tLMgMTANLkYVuh7xD9eYzKo9LhTcJuOJJpycwO52aouoIHu9jNbVshUuCPgAodKfTlOI0mbX/bg+vwup9GU4hLzJW41tL7K5ZHkE0EB3i/eHZflksiCeZ2u3Cn69qq195MstB6MlEiGGWc1Rr92iAyFK6M5X0RV5rhx5txVFCiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193092; c=relaxed/simple;
	bh=p8/VRM5zq9vAPsFhZZyKfynd+xtFRb63mxpcnVwBQXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUbvbTRubyKZwIGH8D8W7dP/Rr622/+b4en33zWkyAPYA1ZEPughBWLnbzdkLx8OGKZYmYTCATo899KLwPSRlOAqIOtsgEr4yUCxdFhIXNrz2/PfVqGAJBUP/QyxYXienAxuzZyQbOExd0mJHzsDOfgNNRj17eGwoxzcv2gIhXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9rITwgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9rITwgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E101F000E9;
	Thu, 16 Jul 2026 09:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784193083;
	bh=Ojuzko3LdxGyuyoL6Hh9D0snIRxo5S8wZ70kGBXx39I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F9rITwgWJP8bWe4HkhHGiM41ox/dBweW2OIMokQaWk5yRgnjLy8Hy4XshLRZJLRue
	 C3Qvu3hOpY6mp5e5+mLtINrsDDhpbKZMlp9yEI33Mum037oRj60oOrtbU3vLVrEzuF
	 A7ntd7s550AkFZOm2rD0xwcI196cECeqVHUULllr8rBMlYKW5zISeeVMBV7zGW+VSt
	 38AU1F+dggLgKh0eBzL/1D/iyn8Af/9PqsIW2yd62hzH3qQrOHNf8NfLGDWC7MkjV0
	 2x3ZYMIZx0E2Wu20c3EIUaWqzC3Ds16eCEBUsh6uyG+twWbQv3P1i9mqgUO3sIkxdZ
	 91cOKgAON/SFg==
Date: Thu, 16 Jul 2026 12:11:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com, alhouseenyousef@gmail.com
Subject: Re: [PATCH for-next v3 1/4] RDMA/bnxt_re: Replace per-device hash
 tables with per-context XArrays
Message-ID: <20260716091117.GA357857@unreal>
References: <20260713135830.1934471-1-selvin.xavier@broadcom.com>
 <20260713135830.1934471-2-selvin.xavier@broadcom.com>
 <20260714121944.GC19233@unreal>
 <CA+sbYW2N_uGeHuqdh1Ca+cNED1huqeVbf3QNTx1dQpUv8Zi7uA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+sbYW2N_uGeHuqdh1Ca+cNED1huqeVbf3QNTx1dQpUv8Zi7uA@mail.gmail.com>

On Thu, Jul 16, 2026 at 02:22:34PM +0530, Selvin Xavier wrote:
> On Tue, Jul 14, 2026 at 5:49 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Jul 13, 2026 at 06:58:27AM -0700, Selvin Xavier wrote:
> > > The CQ and SRQ hash tables (cq_hash, srq_hash) on struct bnxt_re_dev
> > > were used exclusively to look up a toggle-page pointer from a
> > > user-space-supplied hardware queue ID in the GET_TOGGLE_MEM
> > > ioctl handler. This approach has couple of problems. First,
> > > because the tables are per-device, any user can look up another
> > > user's CQ or SRQ by guessing the hardware queue ID. Second,
> > > concurrent add and remove operations on the hash table are not
> > > protected by any lock, leaving a race window.
> > >
> > > The correct fix is to retrieve the CQ and SRQ objects via the uverbs
> > > object handle, which gives built-in ownership verification and reference
> > > pinning for the duration of the ioctl. That is added in the next patch of
> > > this series.
> > >
> > > To maintain backward compatibility with older rdma-core versions that
> > > do not send a uverbs object handle, the driver must continue to support
> > > the existing TYPE + RES_ID lookup path. This patch replaces the per-device
> > > hash tables with per-ucontext XArrays (cq_xa and srq_xa on struct
> > > bnxt_re_ucontext), which narrows the lookup scope to the calling context,
> > > eliminating the cross-user visibility. Also adds Xarray locking mechanism
> > > for synchronization.
> > >
> > > The GET_TOGGLE_MEM ioctl handler is updated to call xa_load()
> > > in place of the now-removed bnxt_re_search_for_cq()/
> > > bnxt_re_search_for_srq() helpers. No ABI changes are required.
> > >
> > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > ---
> > >  drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  5 --
> > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 76 ++++++++++++++++++------
> > >  drivers/infiniband/hw/bnxt_re/ib_verbs.h |  6 +-
> > >  drivers/infiniband/hw/bnxt_re/main.c     |  4 --
> > >  drivers/infiniband/hw/bnxt_re/uapi.c     | 75 ++++++++---------------
> > >  5 files changed, 87 insertions(+), 79 deletions(-)
> >
> > <...>
> >
> > > +             if (uctx) {
> > > +                     xa_lock(&uctx->srq_xa);
> > > +                     __xa_erase(&uctx->srq_xa, srq->qplib_srq.id);
> > > +                     xa_unlock(&uctx->srq_xa);
> >
> > Something very minor, there is no need in this lock->__erase->unlock
> > pattern, use xa_erase() directly as it will perform locking internally.
> >
> > > +                     free_page((unsigned long)srq->uctx_srq_page);
> >
> > It is worth to get rid of get_zeroed_page/free_page too.
> > https://lore.kernel.org/linux-rdma/20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org/T/#t
> Leon,
> Do you want me to take care of this in the next version of this series
> or should i wait till you post the series that makes this change
> across all drivers in rdma tree?

I posted it, but there is nothing for you to do at the moment. This
get_zeroed_page() call cannot be converted to kzalloc() yet, as the
memory is exposed to userspace, which is not supported for slub memory.

Regarding this series, I'm waiting for any other comments.

Thanks

> 
> >
> > Thanks


