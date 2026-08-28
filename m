Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500CE3911AB;
	Fri, 28 Aug 2026 03:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889325; cv=none; b=HmuEeIi1+jq0IS9qBYPTCuKiQFIHYd1v2e4kAi4MZ5X6ZcVNcwwlteN4VuT2DT0Ny1Lv69ZW02rpgkQOhCqfSINJhsp3Gh9avpFr59LZ+xgDKAOzHCKBo6xPbSse308GcRiEyQuyoBakGNO+VNQ1fF1VOLzGoOm5CI21iAg0EFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889325; c=relaxed/simple;
	bh=FCpEZDxc4jEepPZ3bdAy23c/UIgwajhvEbvF74xOfpA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z6Oa8bCtmXnMieZSqFEXQcyUaIBZLsde8QjTZHL8Yc6PiysfrpDz0QtYJixIeGaYplGDLTh689cmU2hJ060nbWy6mM8A3z9sAvUFFrvdUgjKiF3K4f4Ea8wCmmE2KQBHf86C38N266kz+VU2MHMkhFtNA2NHM3gBM2Rx4nkTvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UoNaC3y+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UoNaC3y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A801F000E9;
	Fri, 28 Aug 2026 03:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787889324;
	bh=4+zCmYDgwdjFjvy4pwMM+TuoalPKK3GwFiN1mmUURkE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UoNaC3y+DvalM35SWgtiNtZVjEaqCu7pHPeVItgXMgS2fUheBfbH8H5WccHo9bxqw
	 nJLYCC/TqBI/GZ73S+AF/SSuBJACyhLQW9pKFTF/QgVO8DASb+3XQ+Em1Of70X0kM3
	 eeyN2M95I1Px1ecEbqqPr0nFjrnvQpYPa9ZR8xmlVxP6/q4ecFd8l2GTCC5vk7W0qW
	 dVlcSrEsABZC9SR2B+0Rm0rosuR3HJ0bH85lmjFnQwUKEhbyDSNA/SGpBpw16jbLKe
	 iUqKmX/0Poacbsxy/wAzm+9RB+xbalIgbdD711xj404sPmJPecDSm4bA+JCwtXyZB9
	 gUoA79kiMmNdw==
Message-ID: <f61be21da825131657194f9fec83a77d7a92fe8a.camel@kernel.org>
Subject: Re: [PATCH net v2] net: rds: fix uninitialized trans dereference in
 CM event handler
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>, ljp1205831794@gmail.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, 
	kerneljasonxing@gmail.com, henrymei@tencent.com, corvus@tencent.com, 
	stable@vger.kernel.org
Date: Thu, 27 Aug 2026 20:55:22 -0700
In-Reply-To: <20260827161820.3867858-1-kuba@kernel.org>
References: <20260825021223.3483044-1-ljp1205831794@gmail.com>
	 <20260827161820.3867858-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-27 at 09:18 -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> net: rds: fix uninitialized trans dereference in CM event handler
>=20
> This initializes trans to &rds_ib_transport at declaration in
> rds_rdma_cm_event_handler_cmn(), drops the conditional assignment based o=
n
> cm_id->device->node_type, and adds an early bail-out that returns 1 for a=
ny
> event arriving on a device that is not RDMA_NODE_IB_CA.
>=20
> > diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> > index b15cf316b23a2..2c5481f1fcb4f 100644
> > --- a/net/rds/rdma_transport.c
> > +++ b/net/rds/rdma_transport.c
>=20
> [ ... ]
>=20
> > @@ -80,6 +77,12 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma=
_cm_id *cm_id,
> >  		}
> >  	}
> > =20
> > +	/* Only the IB transport is supported. */
> > +	if (cm_id->device->node_type !=3D RDMA_NODE_IB_CA) {
> > +		ret =3D 1;
> > +		goto out;
> > +	}
> > +
>=20
> [Severity: High]
> Should this non-zero return be limited to RDMA_CM_EVENT_CONNECT_REQUEST?
> As written it applies to every event type.
>=20
> include/rdma/rdma_cm.h documents what a non-zero return means:
>=20
> /**
>  * rdma_cm_event_handler - Callback used to report user events.
>  *
>  * Notes: Users may not call rdma_destroy_id from this callback to destro=
y
>  *   the passed in id, or a corresponding listen id.  Returning a
>  *   non-zero value from the callback will destroy the passed in id.
>  */
>=20
> The cma dispatchers implement exactly that, for example addr_handler() an=
d
> cma_work_handler() in drivers/infiniband/core/cma.c:
>=20
> 	if (cma_cm_event_handler(id_priv, &event)) {
> 		destroy_id_handler_unlock(id_priv);
> 		return;
> 	}
>=20
> But RDS keeps ownership of connection cm_ids.  rds_ib_conn_path_connect()
> stores it:
>=20
> 	ic->i_cm_id =3D rdma_create_id(&init_net, handler, conn,
> 				     RDMA_PS_TCP, IB_QPT_RC);
>=20
> and rds_ib_conn_path_shutdown() later dereferences and destroys the same
> pointer, clearing it only afterwards:
>=20
> 	if (ic->i_cm_id) {
> 		rdsdebug("disconnecting cm %p\n", ic->i_cm_id);
> 		err =3D rdma_disconnect(ic->i_cm_id);
> 	...
> 		rdma_destroy_id(ic->i_cm_id);
> 	...
> 		ic->i_cm_id =3D NULL;
>=20
> So if any event other than CONNECT_REQUEST is delivered with conn !=3D NU=
LL on
> a cm_id whose device node_type is not RDMA_NODE_IB_CA, does the core free=
 the
> cm_id while ic->i_cm_id still points at it?  Can the following conn drop,
> socket close or module unload then hit freed memory in
> rds_ib_conn_path_shutdown(), including a second rdma_destroy_id() on the =
same
> id?
>=20
> A reachable path without any race: rds_ib_laddr_check() short-circuits vi=
a
> rds_ib_get_device(), which only walks the ipaddr_list of RDS's own IB
> devices:
>=20
> net/rds/ib_rdma.c:rds_ib_get_device() {
> 	list_for_each_entry_rcu(rds_ibdev, &rds_ib_devices, list) {
> 		list_for_each_entry_rcu(i_ipaddr, &rds_ibdev->ipaddr_list, list) {
> 			if (i_ipaddr->ipaddr =3D=3D ipaddr) {
> 	...
> }
>=20
> while the device actually bound for the outgoing connection is picked lat=
er
> by cma_acquire_dev_by_src_ip(), which walks the global cma dev_list and c=
an
> match a siw device on the same address.  siw_device_create() sets:
>=20
> 	base_dev->node_type =3D RDMA_NODE_RNIC;
>=20
> In that configuration, rdma_resolve_addr() from rds_ib_conn_path_connect(=
)
> binds a RDMA_NODE_RNIC device, and the resulting RDMA_CM_EVENT_ADDR_RESOL=
VED
> with conn !=3D NULL now returns 1, so addr_handler() destroys the id whil=
e RDS
> still tracks it.
>=20
> The same function a few lines above already documents the opposite
> convention:
>=20
> 		/* If the connection is being shut down, bail out
> 		 * right away. We return 0 so cm_id doesn't get
> 		 * destroyed prematurely */
> 		if (rds_conn_state(conn) =3D=3D RDS_CONN_DISCONNECTING) {
> 			/* Reject incoming connections while we're tearing
> 			 * down an existing one. */
> 			if (event->event =3D=3D RDMA_CM_EVENT_CONNECT_REQUEST)
> 				ret =3D 1;
> 			goto out;
> 		}
>=20
> Separately, does the unconditional goto out also skip the rds_conn_drop()
> that the ADDR_ERROR, ROUTE_ERROR, CONNECT_ERROR, UNREACHABLE,
> DEVICE_REMOVAL, ADDR_CHANGE, DISCONNECTED and TIMEWAIT_EXIT cases perform=
,
> leaving the RDS connection stuck in CONNECTING or UP with no error
> propagated?
>=20
> Would something along these lines match the existing convention, while st=
ill
> dropping the conn for the remaining events:
>=20
> 	ret =3D (event->event =3D=3D RDMA_CM_EVENT_CONNECT_REQUEST) ? 1 : 0;
>=20
> or moving the node_type test into the RDMA_CM_EVENT_CONNECT_REQUEST case?

I think the cleaner solution here would be to hoist the check into the call=
ing function.  So in
rds_rdma_cm_event_handler_cmn():

        case RDMA_CM_EVENT_CONNECT_REQUEST:
		/* Only the IB transport is supported. */
                if (cm_id->device->node_type =3D=3D RDMA_NODE_IB_CA)
                        ret =3D trans->cm_handle_connect(cm_id, event, isv6=
);
                else
                	ret =3D 1;
                break;

Thanks for working on this!
Allison

