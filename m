Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4629F39EF23
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 07:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717224; cv=none; b=BIUf01S9wBs+PuZYedreHYYsRUE0XSSWvMXp6XEly4q1qUdg0t9SNQyV9gR6cM4i1HyS/i+kbm9vNI8GoUauFDuQi/LiFzpum9XfuuwcQaQvwlhXTOG54FisRLZc6vY4unA6Fl5h9pQ8sfQ4dNHXxdcGXy8R+wYps3NrBBeigTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717224; c=relaxed/simple;
	bh=NzMM7bTJfM3IgX6GqTTPRILr7ApI+v4nTnvIZzFsSm0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fQBtm5zXtWNjznevdQN2+3MFDhj2dMuiZjfLWnGWr8EDACK3ZKui2mVoDqiLbZyhALd4/8iUHTVgT3Qooigc6mYjL+QMipjB3UaPcMps0eKgwxI1XLLxXeoK1gpJ377tXqy75dPGZIrJkv3dQTF3h+giKubhj9YJyMyN3uZCsko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4FIvgon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4FIvgon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0520A1F000FF;
	Fri, 18 Sep 2026 07:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789717207;
	bh=BPWmYRT6etQJhguwcNCl0zd3UcVWzZeYeMvwsKD0K6A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E4FIvgonOvMlLf4RlsrcWNe3HCapXfbz/VCreA4TH5NCQxD/rH2SfvBg6bPCgWTh7
	 cEjIVlf3uB+HCbCZ/AxL//C/pRUaDbebEM6fzRUBX0eG5PA8ZTXmGmkL+kxNmZdicI
	 1qsnGa3nwbC4To9cV60KIGF0khkgAxug4J0ahCsCuBmovGLQA38tERCenxnXXNdI6D
	 mHX6U27xVg8XNEOyl93UzkuxwzdwF1DDMag7cgXtjp3hq9QywSNbzHyZaQ6sHs1Gkf
	 9fI1cd1juc8eglLGH0GQxGHhuPrisLCkyhyOgBDWctdHzDbOLEPAVyS93/ZX7wqKUF
	 F+B4FoBge8D7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 07/12] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917073958.174056-8-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
 <20260917073958.174056-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 07:40:06 +0000
Message-Id: <20260918074007.0520A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rds: list corruption in rds_ib_destroy_nodev_conns() due to lockle=
ss tmp_list iteration
--

commit 74390d0096652a342da459a13d451c2fb0ee6d1f
Author: Allison Henderson <achender@kernel.org>
Subject: net/rds: unlink transport nodes before a possibly deferred connect=
ion free

This patch modifies transport teardown helpers in RDS to unlink transport n=
odes
right before calling rds_conn_destroy(). It ensures that nodes don't remain=
 on
stack-allocated list heads when connections are kept alive by external
references.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index a9b27f06cbfcf..bdd66c9b93c70 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -123,15 +123,18 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibde=
v, struct rds_connection *con
>  {
>  	struct rds_ib_connection *ic =3D conn->c_transport_data;
> =20
> -	/* conn was previously on the nodev_conns_list */
> +	/* conn was previously on the nodev_conns_list, unless a teardown
> +	 * sweep already unlinked it ahead of destroying it: then it is
> +	 * on its way out and stays off every list.
> +	 */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	BUG_ON(list_empty(&ib_nodev_conns));
> -	BUG_ON(list_empty(&ic->ib_node));
> -	list_del(&ic->ib_node);
> +	if (!list_empty(&ic->ib_node)) {
> +		list_del(&ic->ib_node);

[Severity: High]
Does this correctly identify if a node was already unlinked by a teardown
sweep?=20

Since the teardown sweep in rds_ib_destroy_nodev_conns() moves the node to a
local tmp_list, list_empty(&ic->ib_node) will evaluate to false here.

Could this cause list_del(&ic->ib_node) to inadvertently unlink the node
from tmp_list while the teardown sweep is actively iterating over it?

> =20
> -	spin_lock(&rds_ibdev->spinlock);
> -	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
> -	spin_unlock(&rds_ibdev->spinlock);
> +		spin_lock(&rds_ibdev->spinlock);
> +		list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
> +		spin_unlock(&rds_ibdev->spinlock);
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);

[ ... ]

> @@ -163,13 +173,38 @@ void rds_ib_destroy_nodev_conns(void)
>  	struct rds_ib_connection *ic, *_ic;
>  	LIST_HEAD(tmp_list);
> =20
> -	/* avoid calling conn_destroy with irqs off */
> +	struct rds_connection *conn;
> +
> +	/* Gather the connections and take a reference on each, so that
> +	 * none is freed under the walk below (a connection destroyed
> +	 * earlier, for a protocol version mismatch, can be on this list
> +	 * with only a socket's reference still pending).  One whose free
> +	 * is already running gets no reference: its free unlinks the
> +	 * node itself, under this lock, once we drop it.  Avoid calling
> +	 * conn_destroy with irqs off.
> +	 */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice_init(&ib_nodev_conns, &tmp_list);
> +	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
> +		if (rds_conn_get_unless_zero(ic->conn))
> +			list_move_tail(&ic->ib_node, &tmp_list);
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);
> =20
> -	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
> -		rds_conn_destroy(ic->conn);
> +	/* rds_conn_destroy() can return before the connection is freed,
> +	 * and it is the free - rds_ib_conn_free() - that unlinks ib_node.
> +	 * tmp_list lives on this stack frame, so unlink each node before
> +	 * its destroy; the free then finds it empty and leaves it alone.
> +	 */
> +	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
> +		conn =3D ic->conn;
> +
> +		spin_lock_irq(&ib_nodev_conns_lock);
> +		list_del_init(&ic->ib_node);
> +		spin_unlock_irq(&ib_nodev_conns_lock);

[Severity: High]
Is it safe to iterate over tmp_list locklessly here?

If a concurrent worker calls rds_ib_add_conn(), it will unlink the node from
tmp_list. If the unlinked node happens to be the prefetched _ic pointer in
this loop, its next and prev pointers become LIST_POISON1 and LIST_POISON2,
which can cause a kernel panic on the next loop iteration.

Additionally, if the concurrent rds_ib_add_conn() has already moved the node
onto rds_ibdev->conn_list, could the list_del_init(&ic->ib_node) here
improperly modify rds_ibdev->conn_list without holding rds_ibdev->spinlock?

> +
> +		rds_conn_destroy(conn);
> +		rds_conn_put(conn);
> +	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917073958.1740=
56-1-achender@kernel.org?part=3D7
