Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514776;
	b=Knt26+/y59pQt1m4qw803/G0XF8QCayhY7hYkICFlpahYrzyNbjm9plwXO19fSPEI2jg
	 MxtPLg98vjShF5//L9W8ouUfc0D/0UlJqSg524WM7bnUXnxRjyjxauBpV/vIe1xma3b66
	 iKaU8qBIqYG5YjMt7WoJBnVPNd0ugDAL2Ni/oKw/tsV3+XfpYe6AH4uL/IWyThHEvTV6K
	 Rty91g793txnl5t9U2DU6GxQCimMsRgc99vpPVxv1K5EUXrO08klwwyzlm+tT3reW2VKw
	 VAOVzDIAtGCrHf9cCoBeBW57IwM/kXtMXj1YDXeh2LxxUUXCZJZQ58zEJTkizlmxNkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514776;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=8/gOIm3nGzAJjdD/EAnNE2wG5YiggBqsPEfb1AbQ2W4=;
	b=SyevzEPHyDhroFyHVVpZ3oTwqigTxVbFfcGXzl7pexeDswCfV3ZbhlI94okkfyW3BRnO
	 FL4I2LU9Ni2Ind1c3hmkHeOrntq/fEFzEO0bV2G/Kp75Z88AHR52/lRUBVywF13ms/9mR
	 qCG3CgS7n7Uga/5cIwPWNutDbZ7sKCJgY+CRziRJf3dkFAXR1MKlumi5d6P/ZNAZIiBhx
	 4CbmQd+mo6yDAokLvxcxqrMyncX5KeD2DXRVdgqXkMxW9baYbyNiF+b3RMnZLWk2Oofte
	 nzBRclD8Sx5jLpDRXkVuEIWkn1zp/0H6CnqNtqLFs7WCaH5TQkzFaHaL5sln/Hyfjtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005BF60A3811;
	Tue, 20 Oct 2026 16:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E1D1F000C9;
	Tue, 20 Oct 2026 16:46:14 +0000 (UTC)
Subject: Re: [PATCH net-next v7 01/13] net: mana: add queue-set allocation and
 teardown helpers
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net, hawk@kernel.org,
 ast@kernel.org, john.fastabend@gmail.com, weh@microsoft.com,
 edumazet@kernel.org
Date: Tue, 20 Oct 2026 16:45:43 +0000
Message-ID: <179251474395.3135.5673130274434349982@kernel.org>
In-Reply-To: =?utf-8?q?=3C05911ee531022aa0103a35b45a70995aad74dc71=2E1791710?=
 =?utf-8?q?735=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C05911ee531022aa0103a35b45a70995aad74dc71=2E17917107?=
 =?utf-8?q?35=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message presents the patch as uncalled helper
  infrastructure ('These helpers have no live replacement callers yet').
- [Low] mana_qset_scratch_alloc() clears scratch->rxbufs_pre, das_pre and
  rxbpre_total, with the comment 'Do not consume the live set's pre-…
- [Low] struct mana_qset does not carry mana_eqs_debugfs, and
  mana_qset_scratch_alloc() sets scratch->mana_eqs_debugfs = NULL.
- [Low] mana_qset_scratch_alloc() copies the whole live port context
  (`*scratch = *apc`) without holding any lock.

--

net: mana: add queue-set allocation and teardown helpers

This commit adds mana_qset_scratch_alloc(), mana_alloc_qset() and
mana_free_qset(), which build and tear down a queue set on a scratch copy
of the port context, along with XDP program peek and release helpers. It
also adds a txq->retiring flag checked in mana_poll_tx_cq(), changes how
mana_create_page_pool() sizes the pool, and clears ac->ports[i] in
mana_remove().

> Leave ordinary mana_dealloc_queues() byte-identical to the pinned
> base. Do not introduce reset generations, sibling-port rebuilds, or
> an incomplete independent failed-FLR TX-buffer policy change.

[ ... ]

> adds that nonresetting pre-publication wait. These helpers have no
> live replacement callers yet.

[Severity: Low]

The message presents the patch as helper code with no callers yet. The
patch also changes three live paths, and the message mentions none of
them.

mana_poll_tx_cq() now checks txq->retiring in the TX completion path:

    if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
        avail_space >= MAX_TX_WQE_SIZE) {

mana_create_page_pool() now sizes the pool from rxq->num_rx_buf rather
than netdev_priv(rxq->ndev)->rx_queue_size:

    pprm.pool_size = rxq->num_rx_buf / rxq->frag_count + 1;

mana_remove() now clears the port slot before free_netdev():

    /* Remove the port from reset walks before freeing its netdev.
     */
    ac->ports[i] = NULL;

None of these seem to change runtime behaviour at this commit. Only the
uncalled mana_free_qset() sets retiring, and for every current caller
mana_create_rxq() sets num_rx_buf to apc->rx_queue_size.

The mana_remove() comment mentions reset walks. There doesn't seem to be
any reset walk over ac->ports[], either in this tree or later in the
series. The remaining readers are:

  - mana_link_change_work(), which is already disabled and NULL-checks
    the slot
  - probe and remove
  - mana_get_primary_netdev(), which RDMA uses and which has no NULL
    check:

    ndev = netdev_master_upper_dev_get_rcu(ac->ports[port_index]);

RDMA is removed earlier through remove_adev(). Still, the message doesn't
say how clearing ports[i] interacts with this reader.

Could the mana_remove() change go into a separate patch with its own
rationale, or be dropped?

Could the message also describe what the patch does? Right now it refers
to "the pinned base" and lists things the patch does not do.

This isn't a bug, but the patch also adds an unrelated blank line in
struct mana_context.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 489558176a5de..7586972e78e09 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> +/* Copy the vport identity without borrowing the live queues. */
> +struct mana_port_context *mana_qset_scratch_alloc(struct mana_port_context *apc)
> +{
> +	struct mana_port_context *scratch;
> +
> +	scratch = kvzalloc_obj(*scratch, GFP_KERNEL);
> +	if (!scratch)
> +		return NULL;
> +
> +	*scratch = *apc;

[Severity: Low]

Is it safe to copy the whole live port context here without holding a
lock?

The copy includes:

  - the initialized vport_mutex
  - the queue_reset_work work_struct, which may be linked into a workqueue
  - fields written concurrently, such as eth_stats (written from NAPI in
    mana_poll_tx_cq()) and vport_use_count

Later in the series, the reconfiguration callers set channel_changing,
drop vport_mutex, and then call mana_qset_scratch_alloc(). Meanwhile
mana_cfg_vport() and mana_uncfg_vport() can take apc->vport_mutex from the
RDMA driver without RTNL. That looks like a data race KCSAN could report.

No current helper locks scratch->vport_mutex, queues
scratch->queue_reset_work or reads scratch->eth_stats. Any later code that
did would be working on a copied mutex or work item.

Would it be better to copy only the identity fields the queue helpers
need?

> +
> +	scratch->eqs		= NULL;
> +	scratch->tx_qp		= NULL;
> +	scratch->rxqs		= NULL;
> +	scratch->indir_table	= NULL;
> +	scratch->rxobj_table	= NULL;
> +	scratch->default_rxobj	= INVALID_MANA_HANDLE;
> +	scratch->mana_eqs_debugfs = NULL;
> +
> +	/* Do not consume the live set's pre-allocated RX buffers. */
> +	scratch->rxbufs_pre	= NULL;
> +	scratch->das_pre	= NULL;
> +	scratch->rxbpre_total	= 0;

[Severity: Low]

Do these assignments have any effect? The RX fill path never reads the
scratch context. mana_fill_rx_oob() and mana_get_rxbuf_pre() both get the
port context from the netdev:

mana_fill_rx_oob():
    struct mana_port_context *mpc = netdev_priv(rxq->ndev);
    ...
    if (mpc->rxbufs_pre)

mana_get_rxbuf_pre():
    mpc = netdev_priv(ndev);

rxq->ndev is the live netdev. So if the live apc had pre-allocated
buffers, building a replacement set on the scratch would still take them,
or fail with -ENOMEM on a size mismatch.

mana_alloc_qset() has no callers at this commit. Later in the series,
mana_pre_alloc_rxbufs() is only called from
mana_per_port_queue_reset_work_handler(). That handler allocates and
frees the buffers inside one rtnl_lock() section. So the live
apc->rxbufs_pre appears to always be NULL when a replacement set is
built.

Should these lines and the comment be dropped, or should the fill path use
the context that owns the queue?

> +
> +	/* Suppress debugfs names that would collide with the live set. */
> +	scratch->mana_port_debugfs = ERR_PTR(-ENODEV);
> +
> +	return scratch;
> +}

[ ... ]

> +	/* Fence RQs before unmapping, but teardown proceeds on errors. */
> +	mana_fence_rqs(scratch);
> +
> +	mana_destroy_rxqs(scratch);
> +
> +	mana_chn_xdp_release(retiring_prog, retiring_queues);
> +
> +	mana_destroy_txq(scratch);
> +	mana_destroy_eq(scratch);

[Severity: Low]

Can this leave the live EQ debugfs files pointing at freed memory?

struct mana_qset doesn't carry mana_eqs_debugfs, and
mana_qset_scratch_alloc() sets scratch->mana_eqs_debugfs to NULL. Suppose
mana_free_qset() retires a set whose EQs were created on the live apc.
mana_destroy_eq(scratch) then removes only the scratch's own dentry:

    debugfs_remove_recursive(apc->mana_eqs_debugfs);

That dentry is NULL or an ERR_PTR here. mana_destroy_eq() then frees the
EQs. The EQs/eqN head, tail, irq and eq_dump files that
mana_create_eq_debugfs() created on the live port would still exist.

Nothing reaches this at this commit. Later in the series, "net: mana:
share the EQ pool across a queue-set swap" makes mana_alloc_qset() borrow
apc->eqs and drops mana_destroy_eq() from mana_free_qset(). "net: mana:
release EQs left idle by a channel-count reduction" then stores per-EQ
dentries in apc->eqs[], so the final code no longer reaches this path.

> +	mana_cleanup_indir_table(scratch);
> +	kfree(scratch->rxqs);
> +	scratch->rxqs = NULL;
> +
> +	memset(qset, 0, sizeof(*qset));
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791710735.git.weh%40linux.microsoft.com
