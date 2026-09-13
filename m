Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E11338239B
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271443; cv=none; b=S381Sjx5AQdWK4gVYiHzRqv3oz0JILf7flxEdgvy5HXLmzLJvWmFYliEJUYoJ4j02SAogni1Xt13BW6ThGmY6aME4EyxuDZvu1RP3IrXGAeKG5YCmOIuilt1zIGbnITa8VtwbWh/jh/QeCClj5MNzbneaY8T+M907OgptL4+TxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271443; c=relaxed/simple;
	bh=ODPJaKV37TbFjwVNuRnoMMLDnSLawTWF0QfaxRha9kw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LA2AsUvTmng91U8rzlyGtTwvDyN685cczThSarJnx136ymyLwoubttpMF527HIlsfTjw8TOYT/S1Hr85NB+nfB6pl0pgHdB+317G+z0BIVrlkrHP95GHeAqA8hEKlOo0bzBZW8XZQ3Dp7pcDpZHWDSVxD9ys1wJwdyaVD5eyH8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwYtOM5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwYtOM5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239FB1F00898;
	Sun, 13 Sep 2026 03:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271442;
	bh=wjku3v92oQlgSaxp1iidOCkOezDZp95QW6oF/uVlliE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YwYtOM5vfbXAT4QWFKE4uVSTc+wHVjI4SWgZ0ic0i1ZEGqLVNKrv6zQ6VXY6OJH/B
	 7Rb4AWRtJy8vHR4MpGjm67TIwJlaGhvJHbnlsQvi5V2PaFHG5KprbTVmFs/UUvlegU
	 WBEnGFVPyOFpTcIogtwSjTwdmEev/VPv1YwJ7Qj1P95mltVoYB1EEWCtlCo4zp1Iwg
	 +IQyhEHMXRS+x9SFeDgtUsSBGEa+gecQFcwSIAvTbDln0MnWBJAbnmDPx6RB94B914
	 z3OTlQz4mzVQkffkPl6Br3yfBFj68LbJneyAzINNbYRb5oiL13mSHVQyw4Qvgm0aHt
	 SRfjV1TLNVn3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 6/9] net/rds: hold connection references in
 lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-7-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:41 +0000
Message-Id: <20260913035042.239FB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Linked-list corruption in cp_send_queue because rds_conn_path_quie=
sce() mutates it without holding cp_lock, racing with rds_sendmsg().
- [High] rds_tcp_accept_one() can attach a newly accepted socket to a dying=
 RDS connection, leading to a Use-After-Free when the connection is freed.
- [Medium] Mismatched locks used for reading and writing `rs->rs_tos` in `r=
ds_ioctl`.

Pre-existing issues:
- [High] rds_ib_conn_free() uses spin_unlock_irq(), which illegally enables=
 interrupts while the caller __rds_conn_create() holds an outer irqsave spi=
nlock.
--

commit d9df1c8410e812fbc2590e40004d81636ec5259e
Author: Sharath Srinivasan <sharath.srinivasan@oracle.com>

net/rds: hold connection references in lookup, sockets and c_passive

This patch introduces reference counting for struct rds_connection objects =
to
prevent use-after-free bugs. It hands out live references on connection
lookup, creation, and within the rs_conn sendmsg cache. The c_passive
connection pointer also now owns a reference that is dropped during parent
destruction.

Closes: https://syzkaller.appspot.com/bug?extid=3D879c1877016972360186

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e36..63baac8aeb2d1 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c
[ ... ]
> @@ -255,6 +263,7 @@ static int rds_ioctl(struct socket *sock, unsigned in=
t cmd, unsigned long arg)
[ ... ]
> -		spin_lock_bh(&rds_sock_lock);
> +		spin_lock_irqsave(&rs->rs_lock, flags);
>  		if (rs->rs_tos || rs->rs_conn) {
> -			spin_unlock_bh(&rds_sock_lock);
> +			spin_unlock_irqrestore(&rs->rs_lock, flags);
>  			return -EINVAL;
>  		}
>  		rs->rs_tos =3D tos;
> -		spin_unlock_bh(&rds_sock_lock);
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
>  		break;
>  	case SIOCRDSGETTOS:
>  		spin_lock_bh(&rds_sock_lock);
>  		tos =3D rs->rs_tos;
>  		spin_unlock_bh(&rds_sock_lock);

[Severity: Medium]
Could this introduce a data race on rs->rs_tos?

This patch updates the SIOCRDSSETTOS write path to use the new per-socket
rs->rs_lock, but the SIOCRDSGETTOS read path still uses the global
rds_sock_lock:

	spin_lock_bh(&rds_sock_lock);
	tos =3D rs->rs_tos;
	spin_unlock_bh(&rds_sock_lock);

Would concurrent ioctl calls with SIOCRDSSETTOS and SIOCRDSGETTOS on the
same socket cause a locking mismatch and potential KCSAN splat?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 5848dd295911a..1ec141d6faa38 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
[ ... ]
> @@ -318,13 +353,44 @@ static struct rds_connection *__rds_conn_create(str=
uct net *net,
>  	spin_lock_irqsave(&rds_conn_lock, flags);
>  	if (parent) {
>  		/* Creating passive conn */
> -		if (parent->c_passive) {
> +		if (READ_ONCE(parent->c_destroy_in_prog)) {
> +			/* The parent's destroy has begun (it sets the
> +			 * flag and snatches c_passive under this
> +			 * lock); do not install a new passive conn
> +			 * that nothing would ever destroy.
> +			 */
> +			trans->conn_free(conn->c_path[0].cp_transport_data);

[Severity: High]
This is a pre-existing issue, but does calling trans->conn_free() here=20
unintentionally enable hardware interrupts?

__rds_conn_create() acquires rds_conn_lock using spin_lock_irqsave(),
disabling interrupts. When it calls trans->conn_free(), for IB connections
this invokes rds_ib_conn_free(), which uses spin_unlock_irq():

net/rds/ib_cm.c:rds_ib_conn_free() {
	...
	spin_lock_irq(lock_ptr);
	if (!list_empty(&ic->ib_node))
		list_del(&ic->ib_node);
	spin_unlock_irq(lock_ptr);
	...
}

Using spin_unlock_irq() unconditionally enables hardware interrupts, which
destroys the original irqsave state of the caller. Can this break mutual
exclusion or cause deadlocks?

[ ... ]
> @@ -696,7 +771,38 @@ void rds_conn_destroy(struct rds_connection *conn)
[ ... ]
>  	spin_unlock_irq(&rds_conn_lock);
> +	if (parent)
> +		rds_conn_put(parent);
>  	synchronize_rcu();
> =20
>  	/* shut the connection down */

[Severity: High]
Can this concurrent teardown corrupt the cp_send_queue linked list?

With this patch, a connection can be quiesced via rds_conn_destroy() while
a send is in flight. During teardown, rds_conn_path_quiesce() is called and
locklessly iterates over and mutates the cp_send_queue:

net/rds/connection.c:rds_conn_path_quiesce() {
	...
	list_for_each_entry_safe(rm, rtmp, &cp->cp_send_queue, m_conn_item) {
		list_del_init(&rm->m_conn_item);
	...
}

Concurrently, a racing rds_sendmsg() can add messages to the queue using
the cp_lock:

net/rds/send.c:rds_send_queue_rm() {
	...
	spin_lock(&cp->cp_lock);
	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
	...
	spin_unlock(&cp->cp_lock);
}

Does modifying this queue without cp_lock during teardown risk memory leaks
or kernel crashes when racing with active senders?

> diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
> index 8a0c54aced5ea..dcac10a91a67f 100644
> --- a/net/rds/tcp_listen.c
> +++ b/net/rds/tcp_listen.c
[ ... ]
> @@ -229,6 +229,7 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
> =20
>  	if (IS_ERR(conn)) {
>  		ret =3D PTR_ERR(conn);
> +		conn =3D NULL;
>  		goto out;
>  	}
>  	/* An incoming SYN request came in, and TCP just accepted it.

[Severity: High]
Can rds_tcp_accept_one() attach a newly accepted socket to a dying connecti=
on?

This patch allows rds_conn_destroy() to run concurrently with active network
events. However, after creating or looking up a connection, this path lacks=
 a
check for rds_destroy_pending(conn) before attaching the socket:

net/rds/tcp_listen.c:rds_tcp_accept_one() {
	...
	rds_tcp_set_callbacks(new_sock, cp);
	rds_connect_path_complete(cp, RDS_CONN_CONNECTING);
	...
}

If the connection's destruction has already begun, rds_tcp_accept_one() cou=
ld
attach the socket and drop its reference while the connection is subsequent=
ly
freed. The socket would remain alive with sk_user_data pointing to the freed
connection path, potentially leading to a use-after-free when network data
arrives. Should we check if the connection is dying before attaching to it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D6
