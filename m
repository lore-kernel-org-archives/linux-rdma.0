Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9A97E105;
	Mon, 24 Aug 2026 18:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787597797; cv=none; b=EWdQWPvXoEblWBkI44ygDvXrmwVZ8d/p5vUSaG4CfWroqWc3rwS9RA3e5BjZg1vd6cR1CW7g91t0mMFts98YTQxwT0hUPVjTs5ZTQRJEz8iODRV1e2xEeBCabi/neeNbnOXNQwme3+fIwlY65OPo5tXEmA9QI2fedxQyhxS2h/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787597797; c=relaxed/simple;
	bh=OLGkBfQgwD3VV61/5CLfbR4/BZrD2w8BtZqoWHhXdYw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i1TPTurJpQIyiS89rNSOcOS4TDyILts+qHoxGI+kR5dT+vJYcp9m+RIvyvJhVqVJv31TBabgykP1XS8ds/ZFg2ByDBOUAWKpE0vUnNvHXKdDp74GGfD/fatYH8nbJTE5wzVpXX3LLxfGRQ4GjTUT8Xa9a59eg8ZZBK/v0q97CIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekHxVc7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekHxVc7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081971F00A3A;
	Mon, 24 Aug 2026 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787597796;
	bh=OTnTfNKx3yZisGodE0G7jqPvwprpXxsPPbrVpgqd9+o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ekHxVc7u1cR1iObiIRnsBlRuLBjjMsankhFfEYl6suLs2p+kqtEZGsGuaCsckFPoW
	 tv5wuhBEUPooDS8C24B3Zbn+HL3fheJ+LbJCBSGRWdT7yfgdBDsvxTCSZW/4Y3KOEV
	 7rGKYY8+E5Yys56iBv9krRA+kCEBi4OPd9iO77H0nhcFthvdlnDvCqnVxnuc+Q1yL+
	 RFH8j1JiXYdKpb0YlQ4yHA3uAQQG8z/DGtubDQBcKibC2sp8FPlErlvsV8nx2I6vRB
	 QlvU8MND0QBWbEHs4p9Lw3veXAgWlxNkh6q1NWSbZMJwfR22O46q6HlMILbGVA9Mq3
	 iPgYyRnbQrUFw==
Message-ID: <c4c495fbc56774c012aebb5979dd72070e4a1c9d.camel@kernel.org>
Subject: Re: [PATCH net] net: rds: fix uninitialized trans dereference in CM
 event handler
From: Allison Henderson <achender@kernel.org>
To: Aohan Mei <ljp1205831794@gmail.com>, netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
 linux-kernel@vger.kernel.org, Jason Xing <kerneljasonxing@gmail.com>, Aohan
 Mei <henrymei@tencent.com>, TencentOS Corvus AI <corvus@tencent.com>, 
 stable@vger.kernel.org
Date: Mon, 24 Aug 2026 11:56:35 -0700
In-Reply-To: <20260824111701.2979194-1-ljp1205831794@gmail.com>
References: <20260824111701.2979194-1-ljp1205831794@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-24 at 19:17 +0800, Aohan Mei wrote:
> From: Aohan Mei <henrymei@tencent.com>
>=20
> rds_rdma_cm_event_handler_cmn() assigns trans only when the RDMA
> device is an InfiniBand CA (RDMA_NODE_IB_CA).  On any other device
> type, e.g. an iWARP RNIC such as siw, trans stays uninitialized, but
> the event switch dereferences it: unconditionally in the
> RDMA_CM_EVENT_CONNECT_REQUEST case via trans->cm_handle_connect(),
> and (with a connection context) in the ROUTE_RESOLVED and
> ESTABLISHED cases.
>=20
> An RDS listener on an iWARP device therefore crashes the kernel as
> soon as a connect request arrives: with CONFIG_INIT_STACK_ALL_ZERO
> the wild load becomes a NULL dereference at offset 0xa0
> (&trans->cm_handle_connect) in the iw_cm_wq workqueue.
>=20
> GCC masks the bug in default builds by folding the uninitialized
> load into &rds_ib_transport; Clang-built kernels take the real
> uninitialized path and oops.
>=20
> Reject events that arrive on device types without an RDS transport:
> initialize trans to NULL and bail out before the event switch when
> no transport matched.
>=20
> Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Assisted-by: CodeBuddy:Kimi-K3
> Signed-off-by: Aohan Mei <henrymei@tencent.com>
>=20
>=20

Hi Aohan,

Thanks for catching this.  A few comments below:

> ---
>  net/rds/rdma_transport.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a..ad9244a09848 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -52,7 +52,7 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm=
_id *cm_id,
>  {
>  	/* this can be null in the listening path */
>  	struct rds_connection *conn =3D cm_id->context;
> -	struct rds_transport *trans;
> +	struct rds_transport *trans =3D NULL;
>  	int ret =3D 0;
>  	int *err;
>  	u8 len;
> @@ -80,6 +80,14 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_c=
m_id *cm_id,
>  		}
>  	}
> =20
> +	/* No RDS transport exists for this device type (e.g. iWARP RNIC),
> +	 * so trans was never assigned; reject instead of dereferencing it.
> +	 */
> +	if (!trans) {
> +		ret =3D 1;
> +		goto out;
> +	}
> +

Support for iWarp was removed in dcdede0406d30e1 and this function only sup=
ports ib.  So we should probably just enforce
the ib transport:

	if (cm_id->device->node_type !=3D RDMA_NODE_IB_CA) {
		ret =3D 1;
		goto out;
	}

Then we can just initialize trans to &rds_ib_transport at the top, and remo=
ve the conditional assignment that appears a
few lines up from here.=20

Thanks!
Allison


>  	switch (event->event) {
>  	case RDMA_CM_EVENT_CONNECT_REQUEST:
>  		ret =3D trans->cm_handle_connect(cm_id, event, isv6);

