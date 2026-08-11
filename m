Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9733A0B3B;
	Tue, 11 Aug 2026 08:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786436290; cv=none; b=NlNTSPFtQZFSCMFS7LahH/c+r1aQJFF7WrOAui3mzFk2OosxT3yCSJIeMVcClBVdI+XR2U+MxdHBACykCZ5QSjGOdRe1y9CTDA6wtNK8tZ+k3y3dJp0DkFL+vh0JnS574sCO1NZ7mNw+/o0BUOgoI4lYPLeuRnjXBuhCV1AWpe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786436290; c=relaxed/simple;
	bh=GBZkSKMRB35nnp93GNKTNI1tGqEifvDr2qVl0X3NrH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hrws1NsGBoJY1AOUS3AXGUO30Jan6Ddbp+yLjGGBCuJacuKh8lBmfNRJEGnQbBlH4yWnWH4iZ155lYR4RQLT4Ksu1+rqaynytcStcawFIU+QeI3VrwJsOCMmzPpZd/ilzalOV5FmT03OLiJOtsGFNCoxiB7op1RYLUGF8R+Inzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQnewV2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQnewV2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811511F000E9;
	Tue, 11 Aug 2026 08:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786436289;
	bh=Hm7kl2t5BzVeTM+JScoXRdPioLQ7IvGBVbKzMUZ6lKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQnewV2W/lRT0ku3cj4unQUJZKScEXOkh2ZwfAe5mjbdjTjk3zcJCdAD+tvPC3k59
	 6y3gbxkRi9B0smgZkt4YezZHEPB3C9RlBsnwQnfNeUY9dBoQAPmxmWguWzcaa1Hmyx
	 hcnpkeeFkmeNHyMeWaTkZN2NwjMItFAEnSd6VdpK9fCTNcDjHFXwhhWY4RkKK06aX6
	 jZM1cjxw3w+knWhr6H2I4A4zsrum5bCGgdmZloDtFbTJ2yNDfsB5ezNP+y0dHQ/gxU
	 RGjCfqMcx7FIVaJe/gLlooL3Oecv31z34ty5M333BO1MfxO+O5Y1EvVdSHaqFdGV94
	 UIfrOtLLyIdHQ==
Date: Tue, 11 Aug 2026 11:18:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com, Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com, stephen@networkplumber.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 1/7] net: mana: RCU-protect gc->cq_table lookups
 against concurrent CQ destroy
Message-ID: <20260811081805.GA30770@unreal>
References: <20260811023823.2391255-1-longli@microsoft.com>
 <20260811023823.2391255-2-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811023823.2391255-2-longli@microsoft.com>

On Mon, Aug 10, 2026 at 07:38:15PM -0700, Long Li wrote:
> The EQ interrupt handler (mana_gd_process_eqe) looks up the completing CQ
> in gc->cq_table[cq_id] and runs its callback, concurrently with CQ
> teardown on another CPU that clears the slot and frees the CQ.  cq_table
> was a plain pointer array freed with no grace period, so the two race
> into a use-after-free:
> 
>   CPU A (mana_gd_intr, hard IRQ)        CPU B (CQ destroy)
>   ----------------------------------    ------------------------------
>   cq = gc->cq_table[cq_id];  // valid
>                                         gc->cq_table[id] = NULL;
>                                         kfree(cq);          // freed
>   cq->cq.callback(ctx, cq);  // use-after-free
> 
> The handler's existing rcu_read_lock() only guards the per-IRQ EQ list
> traversal; cq_table was never under any RCU contract, and a read-side
> lock is inert unless the freer also defers the free past a grace period.
> 
> Put cq_table under RCU: annotate the base pointer and entries __rcu, read
> with rcu_dereference() in the handler, publish with rcu_assign_pointer(),
> and on teardown clear the slot then synchronize_rcu() before freeing the
> CQ.  The grace period blocks until every in-flight handler has dropped
> the old pointer, so the kfree() can no longer race the callback.
> 
> This fixes only the CQ lifetime (the use-after-free); it does not make
> the cq_id bound trustworthy.  gc->max_num_cqs is still range-checked
> outside the published table, and hardening that field against a spoofed
> device value is a separate change.
> 
> netdev teardown destroys a CQ per TX and per RX queue, so one grace
> period each in mana_gd_destroy_cq() would serialize up to
> 2 * MANA_MAX_NUM_QUEUES synchronize_rcu() calls under RTNL on every
> ifdown, MTU change or ring/channel reconfigure.  Clear all of a port's
> CQ slots first and take a single grace period per teardown instead:
> mana_gd_unpublish_cq() clears a slot without waiting, and
> mana_gd_destroy_cq() -- which still serves the single-CQ callers --
> finds the slot already cleared and skips its own synchronize_rcu().
> 
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
> Changes in v6:
>  - mana_gd_unpublish_cq() and mana_ib_remove_cq_cb() clear a cq_table
>    slot only when it still points at the CQ being torn down, so the
>    two-pass teardown cannot wipe an entry a concurrent RDMA CQ create
>    recycled during the grace period.
>  - mana_gd_process_eqe() drops an already-unpublished (NULL) slot quietly
>    instead of a WARN_ON_ONCE() splat during a normal ifdown/MTU change,
>    and reads gc->cq_table before gc->max_num_cqs with an smp_rmb()
>    between them so a shrinking re-establish cannot pair a stale bound
>    with a newly published, smaller table.
>  - Documented the cq_table/max_num_cqs contract on the cq_table field
>    instead of rewording the comment above max_num_cqs.
> 
> Changes in v5:
>  - No code changes since v4 (resend as a standalone thread).
> 
> Changes in v4:
>  - Replaced the per-CQ synchronize_rcu() in the netdev teardown paths
>    with a two-pass quiesce/free that takes one grace period per
>    teardown; mana_gd_unpublish_cq() splits the slot-clear from the grace
>    period.
>  - Snapshot cq->id and max_num_cqs with READ_ONCE() in
>    mana_hwc_establish_channel() so one value sizes, bounds and indexes
>    cq_table.
>  - Corrected the gc->cq_table lifetime comment in gdma.h; rescoped the
>    changelog to the use-after-free fix (the bound is patch 7).
> 
>  drivers/infiniband/hw/mana/cq.c               |  51 ++++++-
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  65 +++++++--
>  .../net/ethernet/microsoft/mana/hw_channel.c  |  29 ++--
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 136 ++++++++++++++----
>  include/net/mana/gdma.h                       |  37 ++++-
>  5 files changed, 268 insertions(+), 50 deletions(-)

This patch is so bloated with AI that it is hard to read and difficult to justify
such a large diff for a simple change, which all drivers experience that
flow.

As a bare minimum. you need to reorder mana_ib_gd_destroy_cq(), mana_ib_destroy_queue(),
and mana_ib_remove_cq_cb() so that HW objects are stopped before SW state is torn down.

And probably introduce get/put CQ primitives.

Thanks
