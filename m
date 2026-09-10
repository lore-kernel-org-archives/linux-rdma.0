Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D033955D6;
	Thu, 10 Sep 2026 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079129; cv=none; b=AECrVnOA2beQlvYLlntx9mJ9xjSKps7pkEHm3g+hD9wdxg1R6N218eO22OXrGjfjA6+egbFtEIBFWJYGv0/O/bGNSuylTmtRfFtyYcHjDU3r7O5mo1mkUtmu3IB0dkN07GapoSNFOwZTxStm9zlYM4bBJXpT2CrgHfhbpwCjOgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079129; c=relaxed/simple;
	bh=2xNRMzbI2gZyS3yG2LeH4A38YZJAATEqjRK6fOTIqCY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iGpK/cxmzjwY8bGgynJVwKEhRwnJjt+Fx6/xqES/GSY+DAF/UwiNs9csUOS9auo67k2q6Sk5YyWy8/gsNupJ/aI6z6lUg14XWauSC9hzyQZPv5/WKUG2vHOvzejVZ5HQpzeP8xdJpI9TxOdB7b/P7Rx7SCtBuEM8f9BkfRcD/Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBjzLSL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBjzLSL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D6B1F0089F;
	Thu, 10 Sep 2026 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079126;
	bh=xfT8KVWkd7CqHEqrFfFQaJX8vI8MjJGZRNtRtr6NcYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cBjzLSL+a0m5Q6BZ3mLFjyL9olDWBTkP7sKgRmjeTxaubSbP+dgDD4ksqKTqEX0ae
	 kiY2rGv6rbCPXeYmKS9swh3WC+/q5gn9OLa5JMLkOuQZyBtIxh60KGzmnVXxzBgxtW
	 PYJe6p/YE81e+TgzyHRFCz+Co/5evpiaonz/m9qc43N74oCd/d6rOd/6DGluf2hly7
	 PtQSIeMFDHqm4SqVDkUKxXgepTrN9bBj7lp6ZDhzpi3+BqrtjNbYqmJS8OH+6jqev9
	 zz4T44Nq0zF0X1bmzO4ExgM5OKc4ZSuNmpv1xcFPZglwsaQzUMktPXdERznA8u0Jxo
	 jkzGlTEtSe2wA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 12/13] net: mana: keep the surviving queues
 when the channel count is reduced
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-13-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-13-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:26 +0000
Message-Id: <20260910222526.84D6B1F0089F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Missing `synchronize_net()` on the rollback path of `mana_publish_=
qset` allows concurrent readers to dereference newly allocated containers a=
fter they are freed.

Pre-existing issues:
- [High] u64_stats writer runs with preemption enabled, which can deadlock =
32-bit readers in BH context
--

commit ac5cec529175b7a19576c74efe705cb50e0c6d42
Author: Long Li <longli@microsoft.com>

net: mana: keep the surviving queues when the channel count is reduced

Split the live set into a kept prefix and a retiring tail. Reductions
allocate only pointer arrays and steering tables, retaining the kept
queues' page pools, buffers, NAPI state and XDP references.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 78be88b29c99b..158f9a6ce4215 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -4351,9 +4459,7 @@ int mana_publish_qset(struct mana_port_context *apc=
, struct mana_qset *newq,
>  	if (err)
>  		goto rollback;
> =20
> -	/* Install XDP and per-RXQ references before steering reaches new
> -	 * queues.
> -	 */
> +	/* Install XDP before steering reaches the incoming RXQs. */
>  	mana_chn_setxdp(apc, mana_xdp_get(apc));
> =20
>  	err =3D mana_config_rss(apc, TRI_STATE_TRUE, true, true);

[Severity: High]
This is a pre-existing issue, but the rollback path here appears to have a
synchronization problem. If mana_publish_qset() fails, it triggers a rollba=
ck
that ultimately calls mana_fold_rxq_stats() to update stats:

drivers/net/ethernet/microsoft/mana/mana_en.c:mana_fold_rxq_stats() {
    ...
	u64_stats_update_begin(&dst->syncp);
	dst->packets		+=3D src->packets;
	dst->bytes		+=3D src->bytes;
	u64_stats_update_end(&dst->syncp);
    ...
}

Since this update runs under the RTNL lock in process context without
disabling preemption or bottom halves, what happens if a softirq interrupts
this writer and executes dev_get_stats() (which calls u64_stats_fetch_begin=
())?

Could this lead to the reader spinning infinitely waiting for the seqcount
to become even, resulting in a hard lockup on 32-bit architectures?

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers=
/net/ethernet/microsoft/mana/mana_ethtool.c
> index acc82fa9f0057..0b8c2f61d6263 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c

[ ... ]

> @@ -737,6 +737,36 @@ static int mana_set_channels(struct net_device *ndev,
>  		goto clear_flag;
>  	}
> =20
> +	if (new_count < apc->num_queues) {
> +		struct mana_qset tailq;
> +
> +		err =3D mana_split_qset(apc, scratch, new_count, &newq, &tailq);
> +		if (err)
> +			goto free_scratch;
> +
> +		err =3D mana_publish_qset(apc, &newq, &oldq);
> +		if (err) {
> +			/* Discard containers only; their queues still belong to
> +			 * the old set.
> +			 */
> +			mana_discard_split(&newq, &tailq);

[Severity: High]
If mana_publish_qset() fails, its rollback path restores the old pointers v=
ia
mana_qset_install(apc, out_old) but returns err without waiting for an RCU=
=20
grace period (such as via synchronize_net()) to ensure readers that observed
the newq pointers have finished.

Here in mana_set_channels(), mana_discard_split() is called immediately,
which frees the newly allocated containers:

drivers/net/ethernet/microsoft/mana/mana_en.c:mana_discard_split() {
    kfree(newq->tx_qp);
    kfree(newq->rxqs);
    kfree(newq->indir_table);
    kfree(newq->rxobj_table);
    ...
}

Could concurrent RCU-protected readers like ndo_select_queue (which are not
blocked by netif_tx_disable()) observe the new pointers and execute a
use-after-free when these containers are freed?

> +			goto free_scratch;
> +		}
> +
> +		/* Wait for ndo_select_queue() readers of oldq.indir_table. Free
> +		 * only containers; the queues belong to the kept set or tail.
> +		 */
> +		synchronize_net();
> +
> +		kfree(oldq.tx_qp);
> +		kfree(oldq.rxqs);
> +		kfree(oldq.indir_table);
> +		kfree(oldq.rxobj_table);
> +
> +		mana_free_qset(scratch, &tailq);
> +		goto free_scratch;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D12
