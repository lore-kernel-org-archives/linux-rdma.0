Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB61940F73E;
	Fri,  4 Sep 2026 04:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497222; cv=none; b=SaKk1KXFAqqYSqpdxORzLgfZUNlpqKpa3Va+DbIpM+XK6uimjA22egBtIxF+2lnO4D0jm11iQRZpik8okVVaop0U2w4OPRPQGnKye+mV9xnWkcepBwpGUh/N96ABsUlYRPP+yaBMCGEhD5PMInWGMRy0C6FyX+jAXCu/ACIMgRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497222; c=relaxed/simple;
	bh=sjutlRnX8s6YYWfIlOA8LaGYWoOOIdwZxZy9BcY8Mb8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i7yn5NOTUmZFaWHmMLDpbU++jop19eGIdCXmWyLSfvtnUFGjFdQWKukuEPBnJ5bXfYGoiPbJQgh+KIxWutZzLRmw/fwJ1SfTEMJLS3x6RuKQLth3yl0oFOntbmZEsOLx26OpwMbMqooNWbSaribvvSUFdCySLFWltpZeCpm/ykI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jisYx2br; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jisYx2br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A061F00A3D;
	Fri,  4 Sep 2026 04:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497218;
	bh=CGrB/7XKPh3n0cVHga5tgvZK64LxU806jxLMtREIybo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jisYx2bru4D2Gb1S6bSBtMDi3493C4ei6p/rTa64sL7jFpk/M+j4C3LiI33NtXB5N
	 QBqhnrSCLWgBoxBfEWDp02g869rmWhFHcsu1OBjfig51xUrxtMFaV6XBMSq1PRAO3o
	 VP7E+snjtrIQhqp95LhoJoRnQgfcaIa3FL1TP39UcJB5yzgHXMx1acdsr68FivT2/v
	 Jhpl4kox5H9f2+o514gN+wsTmPklF5I14vUgkKX2enDZtSPDnt4xmPHnSKVYvsTkdH
	 RaHl/8CJXbWdOmZhdeqFxJdHmI9YQ/WWqFDM4X/gOieorUd3hJFpSQZ9YS+MO9xqMJ
	 OnBwuyKj7FG+Q==
Subject: Re: [PATCH net-next v3 12/13] net: mana: keep the surviving queues
 when the channel count is reduced
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 04:46:57 +0000
Message-ID: <178849721703.4131868.17508307206547557734@kernel.org>
In-Reply-To: <20260901014442.2945689-13-longli@microsoft.com>
References: <20260901014442.2945689-13-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 2

- [Medium] Use-after-free read of the RSS indirection table in the new
  channel-reduction branch of mana_set_channels().
- [Low] Stale/contradictory in-tree contract comments in
  mana_publish_qset() for the new channel-reduction caller.
- [Low] mana_split_qset()'s header comment at
  drivers/net/ethernet/microsoft/mana/mana_en.c:4335 says "Allocates two…

--

net: mana: keep the surviving queues when the channel count is reduced

A channel-count reduction no longer rebuilds the queues it keeps. The live
set is carved into a kept prefix and a tail by the new mana_split_qset(),
the prefix is published and only the tail is retired. Increases and
per-queue property changes still rebuild a full set.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 6769faada11bc..ae7c664bf76ef 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -4327,7 +4327,135 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
>  	kvfree(scratch);
>  }
>  
> -/* Build a queue set in @scratch, sized and configured from the arguments. The
> +/* Carve the live set into a kept prefix [0, @new_count) in @out_new and a
> + * tail to retire in @out_tail. @apc is untouched, on failure too.
> + *
> + * Queue i is built from the ring sizes and the buffer layout and keeps EQ i
> + * at any count, so a reduction carries the survivors over and destroys only
> + * the tail. Allocates two pointer arrays and a steering table, nothing else:
> + * the queues that stay keep their page pools, posted buffers and NAPI.
> + */

[Severity: Low]
This isn't a bug, but does the allocation inventory in this comment match
what the body does?

Four pointer arrays are allocated, not two, and mana_rss_table_alloc()
allocates two tables (indir_table and rxobj_table), both of which
mana_discard_split() and mana_set_channels() free separately.

The commit message carries the same count:

  "a reduction allocates two pointer arrays and a steering table
   instead of a full queue set"

Should both read four pointer arrays and two tables?

> +int mana_split_qset(struct mana_port_context *apc,
> +		    struct mana_port_context *scratch, unsigned int new_count,
> +		    struct mana_qset *out_new, struct mana_qset *out_tail)
> +{

[ ... ]

> +	scratch->num_queues = new_count;
> +	err = mana_rss_table_alloc(scratch);
> +	if (err)
> +		return err;
> +
> +	if (mana_rss_table_keep(apc, new_count, &indir_lost))
> +		memcpy(scratch->indir_table, apc->indir_table,
> +		       apc->indir_table_sz * sizeof(*apc->indir_table));
> +	else
> +		mana_rss_table_init(scratch);
> +
> +	new_tx = kzalloc_objs(struct mana_tx_qp *, new_count);
> +	new_rx = kzalloc_objs(struct mana_rxq *, new_count);
> +	tail_tx = kzalloc_objs(struct mana_tx_qp *, tail_count);
> +	tail_rx = kzalloc_objs(struct mana_rxq *, tail_count);

[ ... ]

> +	/* The tail. It owns no steering table; bpf_prog is carried so that
> +	 * retiring it drops exactly the tail's per-queue program references
> +	 * and leaves the kept ones alone.
> +	 */

[Severity: Low]
Where does the number of program references dropped for the tail come
from?  mana_free_qset() installs the tail into @scratch and then calls:

	retiring_prog = mana_chn_xdp_peek(scratch);
	retiring_queues = scratch->num_queues;
	...
	mana_chn_xdp_release(retiring_prog, retiring_queues);

so the count comes from the tail's queue count, not from
out_tail->bpf_prog.

Related to that, is the comment in mana_publish_qset() still accurate for
the set this helper builds?

	/* Carry the XDP program over before steering can reach the new RXQs:
	 * they were created with bpf_prog == NULL, so a packet arriving first
	 * would bypass an attached program. This also takes the per-queue
	 * references that mana_free_qset() drops for the old set.
	 */
	mana_chn_setxdp(apc, mana_xdp_get(apc));

For a reduction, newq->rxqs[] are the live queues, so they already carry
apc->bpf_prog and mana_chn_setxdp() returns immediately:

drivers/net/ethernet/microsoft/mana/mana_bpf.c:mana_chn_setxdp() {
	struct bpf_prog *old_prog = mana_chn_xdp_get(apc);
	...
	if (old_prog == prog)
		return;

	if (prog)
		bpf_prog_add(prog, num_queues);
	...
}

The refcount does balance today: old_count references are held going in,
mana_free_qset() puts tail_count, and new_count are left for the new_count
live queues.  Read together though, the two comments describe old_count +
new_count taken against tail_count released, and the balance rests on that
undocumented early return in another file.  Could the publish comment
mention the carried-over case?

The same function's header contract ("On failure the old set is reinstalled
and the caller frees only @newq") also reads oddly for this caller, which
must free only @newq's containers via mana_discard_split() because @newq's
queues are the live ones.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index c7ddd26cada25..b5587764333f1 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> @@ -754,6 +755,39 @@ static int mana_set_coalesce(struct net_device *ndev,
>  		goto clear_flag;
>  	}
>  
> +	/* A reduction keeps its queues configured identically, so carry them
> +	 * over and retire only the tail: no DMA ring, no hardware WQ object,
> +	 * and no old+new peak.
> +	 */
> +	if (new_count < apc->num_queues) {
> +		struct mana_qset tailq;
> +
> +		err = mana_split_qset(apc, scratch, new_count, &newq, &tailq);
> +		if (err)
> +			goto free_scratch; /* current qset untouched */
> +
> +		err = mana_publish_qset(apc, &newq, &oldq);
> +		if (err) {
> +			/* The old set is live again; drop only the containers
> +			 * built above, never the queues they point at.
> +			 */
> +			mana_discard_split(&newq, &tailq);
> +			goto free_scratch;
> +		}
> +
> +		/* @oldq holds the original arrays and steering table. Every
> +		 * queue they referenced is now owned by either the published
> +		 * set or the tail, so only the containers are freed here.
> +		 */
> +		kfree(oldq.tx_qp);
> +		kfree(oldq.rxqs);
> +		kfree(oldq.indir_table);
> +		kfree(oldq.rxobj_table);

[Severity: Medium]
Can this kfree() release the indirection table while the transmit path is
still reading it?

mana_get_tx_queue() dereferences apc->indir_table with no lock and no
port_is_up gate:

drivers/net/ethernet/microsoft/mana/mana_en.c:mana_get_tx_queue() {
	txq = apc->indir_table[hash & (apc->indir_table_sz - 1)];
	...
}

It is reached from ndo_select_queue, netdev_core_pick_tx() ->
mana_select_queue() -> mana_get_tx_queue(), inside __dev_queue_xmit()'s
rcu_read_lock_bh() section.

The only synchronize_net() on the publish success path runs before the
pointer is replaced, and transmits are running again by the time publish
returns:

mana_publish_qset()
	synchronize_net();		/* before the swap */
	mana_qset_set_retiring(newq, NULL, false);
	mana_qset_install(apc, newq);	/* apc->indir_table replaced here */
	...
	WRITE_ONCE(apc->port_is_up, true);
	mana_start_txqs(apc);

mana_set_channels()
	kfree(oldq.indir_table);	/* no grace period since the swap */

So a CPU that loaded the old apc->indir_table before mana_qset_install()
and has not yet done the array load can read freed memory.
mana_config_rss() only waits on an HWC completion, which says nothing about
other CPUs' read-side sections.

Before this patch the reduction freed the old table inside mana_free_qset()
-> mana_cleanup_indir_table(scratch), which happens after that function's
synchronize_net() and therefore after the new set is installed.

Would a synchronize_net() before these frees, or moving them after
mana_free_qset(), close that window?  The same pattern appears in the grow
branch added later in the series ("net: mana: keep the existing queues when
the channel count is raised"), where oldq.indir_table is freed the same way,
so both branches look affected at the end of the series.

> +
> +		mana_free_qset(apc, scratch, &tailq);
> +		goto free_scratch;
> +	}
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
