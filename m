Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E2D3C109F;
	Tue, 25 Aug 2026 06:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639097; cv=none; b=r1pQjajh/H851RXoG8vgf6VU/J0uc6bNghx7aHWWKM6dfIiLhXyEmCEHrmgX9NytIf6kLE+3KhUnOsrHYhIzbTiHlEpc0386h+2maqXP1Vr/EZxdo8UJq3nf8b6MADiOn0MPhMZSXhS0mnRmzsb5VUvT5E1O+eggTv7+kzjEgCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639097; c=relaxed/simple;
	bh=Xr4/ogVHoJd1TWU++fUgSw+dYoYcu7TCJGi7k9Ff21I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bbdkNcczs5qFrhC4TfJV7AtIbQDKX6C1Dk/tS+0WFqpJfxkOry6ot6bvYuMXYqM0mg5zdtDGtrL6nj/bxqE6zZFABkvKnecXD6fhKlKJk15k/gfrI8aBxtLMcPDTDs2KsbhPmUYcj4iFOjkCtFu7uqtZp4/JKKfjLHQADhu8jcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkAX9wAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkAX9wAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9631A1F000E9;
	Tue, 25 Aug 2026 06:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787639094;
	bh=XI1I+ystZ9RJeodzH+bRQW5gDWN31PgOmzzw95y1/mw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZkAX9wAKtL5wr7f7xd+5lqayshEDVMZ13F+xH8QueiD3R5bSftJHRBRT0JyH1zqeC
	 Sh1NdNbxxd2feA5N4wxVafr+S8FEUPaFoj6kAFDDiYugD7ujDotoWViK5Q9HjUCBW5
	 u46qZBBZR4L6WIWt64BT+USVUYzyl+I7ToIh8pJTDqI8eaDdJl+/SjaRk46Y10rG1j
	 GjDg05M9qrp7EOEn8SYF+X6b/a3AOj1PlcKCsIw9PQVwg6k451Zltut5NxOKSPZv+2
	 XFN9LLXRYFYKqmyZidQwurJE2KpQjo5rGno6v0E272fTWXxN4ncFCzuN2F0dGvbcGz
	 xOkeHVoLnTCVA==
Message-ID: <50e5a8e2c6d31732e7d57af2c2b7de164d3f0af5.camel@kernel.org>
Subject: Re: [PATCH net v2] net: rds: fix uninitialized trans dereference in
 CM event handler
From: Allison Henderson <achender@kernel.org>
To: Aohan Mei <ljp1205831794@gmail.com>, netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
 linux-kernel@vger.kernel.org, Jason Xing <kerneljasonxing@gmail.com>, Aohan
 Mei <henrymei@tencent.com>, TencentOS Corvus AI <corvus@tencent.com>, 
 stable@vger.kernel.org
Date: Mon, 24 Aug 2026 23:24:52 -0700
In-Reply-To: <20260825021223.3483044-1-ljp1205831794@gmail.com>
References: <20260825021223.3483044-1-ljp1205831794@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-08-25 at 10:12 +0800, Aohan Mei wrote:
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
> The iWARP transport was dropped long ago and IB is the only
> transport left, so make that explicit: initialize trans to
> &rds_ib_transport at declaration, drop the conditional assignment,
> and reject events from non-IB devices before the event switch.
>=20
> Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Assisted-by: CodeBuddy:Kimi-K3
> Signed-off-by: Aohan Mei <henrymei@tencent.com>

This looks good to me.  Thanks for the quick response.

Reviewed-by: Allison Henderson <achender@kernel.org>

> ---
> v2:
> - Enforce the IB transport directly instead of NULL-guarding trans,
>   as suggested by Allison Henderson.
> v1: https://lore.kernel.org/netdev/20260824111701.2979194-1-ljp1205831794=
@gmail.com
>  net/rds/rdma_transport.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a..2c5481f1fcb4 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -52,7 +52,7 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm=
_id *cm_id,
>  {
>  	/* this can be null in the listening path */
>  	struct rds_connection *conn =3D cm_id->context;
> -	struct rds_transport *trans;
> +	struct rds_transport *trans =3D &rds_ib_transport;
>  	int ret =3D 0;
>  	int *err;
>  	u8 len;
> @@ -60,9 +60,6 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm=
_id *cm_id,
>  	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
>  		 event->event, rdma_event_msg(event->event));
> =20
> -	if (cm_id->device->node_type =3D=3D RDMA_NODE_IB_CA)
> -		trans =3D &rds_ib_transport;
> -
>  	/* Prevent shutdown from tearing down the connection
>  	 * while we're executing. */
>  	if (conn) {
> @@ -80,6 +77,12 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_c=
m_id *cm_id,
>  		}
>  	}
> =20
> +	/* Only the IB transport is supported. */
> +	if (cm_id->device->node_type !=3D RDMA_NODE_IB_CA) {
> +		ret =3D 1;
> +		goto out;
> +	}
> +
>  	switch (event->event) {
>  	case RDMA_CM_EVENT_CONNECT_REQUEST:
>  		ret =3D trans->cm_handle_connect(cm_id, event, isv6);

