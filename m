Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4609477289;
	Thu, 17 Sep 2026 07:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630676; cv=none; b=YAqQFOYtigekm7Byn+WotlK0XGQkgIrQ0VtzWC5EaaOt//nJD6TQD5JbaHIx33gz1P/QA/MwDqWqwBJ+paFco7HWweMWud6SZJLk1u36y87h2s6TtXl7U8ZJGYiFaCco2jpOqCRfuwnkWqiv1t/XeDg9JSGffYtAiu5RYmb1nls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630676; c=relaxed/simple;
	bh=vO/q2mbznj3c2bSlBs9Ij4ftwvAIyCO2JLr0+w/27Nk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R2wB8Ei9PYoSubM4D2QtXHvCN95mDW3npuTgoCS7O/xjf+t1mWH/6iBLYcHAcDHqq4gQ93WeZBvtyM4DHp6z90nJF/fEopdpW7r1pzyH8kU2G02DD8hyhbzYMYgoLpjPw6HdFzhk7x4+8sD/Q7BeYBH6A+qI/Ljrc6elUPwvvAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oF8NCpyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oF8NCpyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4471F000FF;
	Thu, 17 Sep 2026 07:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630674;
	bh=mKospiVc/iKQdx+wgaDwt2SiZwPBH7/oRZNR/URy6Is=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oF8NCpyEF90QAco2wmTknaM/0Z9IO3HGEFB+7nfdU0n4YOEy2eI1FsjwTbhdxmUK7
	 UU1M0Z4l+4Wz+wJJlNq94FWoXSobXM4iDxGgY4EH3bYoJ3vU5vz1jKXtSGBHtPTGTm
	 7N1HfH4vKr8/EQOora7mSa1B/QUzFwBb1N/TKi9taHega4Of55Ye6+MviP9tO5mDdK
	 6ZwzCzcwkVstDWpPn5a5tD8VjpDvcRv291/ARIKIVF40DEBGIL8eJe0Ufpx7nMy13G
	 HKm8nUlu3dgH2h0+81iZgU8ekB2s791BH+npeoB/0IcxmR6AR/vR1/w2utnoI75pBV
	 hipvawQfYGDqA==
Message-ID: <9283f0fddfc18003aeddfd6521a84631a27df74f.camel@kernel.org>
Subject: Re: [PATCH net v2] net: rds: fix uninitialized trans dereference in
 CM event handler
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>, ljp1205831794@gmail.com, 
	henrymei@tencent.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, 
	kerneljasonxing@gmail.com, henrymei@tencent.com, corvus@tencent.com, 
	stable@vger.kernel.org
Date: Thu, 17 Sep 2026 00:37:53 -0700
In-Reply-To: <f61be21da825131657194f9fec83a77d7a92fe8a.camel@kernel.org>
References: <20260825021223.3483044-1-ljp1205831794@gmail.com>
	 <20260827161820.3867858-1-kuba@kernel.org>
	 <f61be21da825131657194f9fec83a77d7a92fe8a.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-27 at 20:55 -0700, Allison Henderson wrote:
> On Thu, 2026-08-27 at 09:18 -0700, Jakub Kicinski wrote:
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
> > ---
> > net: rds: fix uninitialized trans dereference in CM event handler
> >=20
> > This initializes trans to &rds_ib_transport at declaration in
> > rds_rdma_cm_event_handler_cmn(), drops the conditional assignment based=
 on
> > cm_id->device->node_type, and adds an early bail-out that returns 1 for=
 any
> > event arriving on a device that is not RDMA_NODE_IB_CA.
> >=20
> > > diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> > > index b15cf316b23a2..2c5481f1fcb4f 100644
> > > --- a/net/rds/rdma_transport.c
> > > +++ b/net/rds/rdma_transport.c
> >=20
> > [ ... ]
> >=20
> > > @@ -80,6 +77,12 @@ static int rds_rdma_cm_event_handler_cmn(struct rd=
ma_cm_id *cm_id,
> > >  		}
> > >  	}
> > > =20
> > > +	/* Only the IB transport is supported. */
> > > +	if (cm_id->device->node_type !=3D RDMA_NODE_IB_CA) {
> > > +		ret =3D 1;
> > > +		goto out;
> > > +	}
> > > +
> >=20
> > [Severity: High]
> > Should this non-zero return be limited to RDMA_CM_EVENT_CONNECT_REQUEST=
?
> > As written it applies to every event type.
> >=20
> > include/rdma/rdma_cm.h documents what a non-zero return means:
> >=20
> > /**
> >  * rdma_cm_event_handler - Callback used to report user events.
> >  *
> >  * Notes: Users may not call rdma_destroy_id from this callback to dest=
roy
> >  *   the passed in id, or a corresponding listen id.  Returning a
> >  *   non-zero value from the callback will destroy the passed in id.
> >  */
> >=20
> > The cma dispatchers implement exactly that, for example addr_handler() =
and
> > cma_work_handler() in drivers/infiniband/core/cma.c:
> >=20
> > 	if (cma_cm_event_handler(id_priv, &event)) {
> > 		destroy_id_handler_unlock(id_priv);
> > 		return;
> > 	}
> >=20
> > But RDS keeps ownership of connection cm_ids.  rds_ib_conn_path_connect=
()
> > stores it:
> >=20
> > 	ic->i_cm_id =3D rdma_create_id(&init_net, handler, conn,
> > 				     RDMA_PS_TCP, IB_QPT_RC);
> >=20
> > and rds_ib_conn_path_shutdown() later dereferences and destroys the sam=
e
> > pointer, clearing it only afterwards:
> >=20
> > 	if (ic->i_cm_id) {
> > 		rdsdebug("disconnecting cm %p\n", ic->i_cm_id);
> > 		err =3D rdma_disconnect(ic->i_cm_id);
> > 	...
> > 		rdma_destroy_id(ic->i_cm_id);
> > 	...
> > 		ic->i_cm_id =3D NULL;
> >=20
> > So if any event other than CONNECT_REQUEST is delivered with conn !=3D =
NULL on
> > a cm_id whose device node_type is not RDMA_NODE_IB_CA, does the core fr=
ee the
> > cm_id while ic->i_cm_id still points at it?  Can the following conn dro=
p,
> > socket close or module unload then hit freed memory in
> > rds_ib_conn_path_shutdown(), including a second rdma_destroy_id() on th=
e same
> > id?
> >=20
> > A reachable path without any race: rds_ib_laddr_check() short-circuits =
via
> > rds_ib_get_device(), which only walks the ipaddr_list of RDS's own IB
> > devices:
> >=20
> > net/rds/ib_rdma.c:rds_ib_get_device() {
> > 	list_for_each_entry_rcu(rds_ibdev, &rds_ib_devices, list) {
> > 		list_for_each_entry_rcu(i_ipaddr, &rds_ibdev->ipaddr_list, list) {
> > 			if (i_ipaddr->ipaddr =3D=3D ipaddr) {
> > 	...
> > }
> >=20
> > while the device actually bound for the outgoing connection is picked l=
ater
> > by cma_acquire_dev_by_src_ip(), which walks the global cma dev_list and=
 can
> > match a siw device on the same address.  siw_device_create() sets:
> >=20
> > 	base_dev->node_type =3D RDMA_NODE_RNIC;
> >=20
> > In that configuration, rdma_resolve_addr() from rds_ib_conn_path_connec=
t()
> > binds a RDMA_NODE_RNIC device, and the resulting RDMA_CM_EVENT_ADDR_RES=
OLVED
> > with conn !=3D NULL now returns 1, so addr_handler() destroys the id wh=
ile RDS
> > still tracks it.
> >=20
> > The same function a few lines above already documents the opposite
> > convention:
> >=20
> > 		/* If the connection is being shut down, bail out
> > 		 * right away. We return 0 so cm_id doesn't get
> > 		 * destroyed prematurely */
> > 		if (rds_conn_state(conn) =3D=3D RDS_CONN_DISCONNECTING) {
> > 			/* Reject incoming connections while we're tearing
> > 			 * down an existing one. */
> > 			if (event->event =3D=3D RDMA_CM_EVENT_CONNECT_REQUEST)
> > 				ret =3D 1;
> > 			goto out;
> > 		}
> >=20
> > Separately, does the unconditional goto out also skip the rds_conn_drop=
()
> > that the ADDR_ERROR, ROUTE_ERROR, CONNECT_ERROR, UNREACHABLE,
> > DEVICE_REMOVAL, ADDR_CHANGE, DISCONNECTED and TIMEWAIT_EXIT cases perfo=
rm,
> > leaving the RDS connection stuck in CONNECTING or UP with no error
> > propagated?
> >=20
> > Would something along these lines match the existing convention, while =
still
> > dropping the conn for the remaining events:
> >=20
> > 	ret =3D (event->event =3D=3D RDMA_CM_EVENT_CONNECT_REQUEST) ? 1 : 0;
> >=20
> > or moving the node_type test into the RDMA_CM_EVENT_CONNECT_REQUEST cas=
e?
>=20
> I think the cleaner solution here would be to hoist the check into the ca=
lling function.  So in
> rds_rdma_cm_event_handler_cmn():
>=20
>         case RDMA_CM_EVENT_CONNECT_REQUEST:
> 		/* Only the IB transport is supported. */
>                 if (cm_id->device->node_type =3D=3D RDMA_NODE_IB_CA)
>                         ret =3D trans->cm_handle_connect(cm_id, event, is=
v6);
>                 else
>                 	ret =3D 1;
>                 break;
>=20
> Thanks for working on this!
> Allison
>=20
Hi Aohan,

I know this thread is a bit old, but this bug popped up as a pre-existing b=
ug for another set review.  Did you have an
interest in sending a v3?  I am fine to carry it forward if you're on to ot=
her things, but I wanted to check with you
first.  I'd preserve all your tags, sob, and reported-by.  Just let me know=
, I'm fine either way.

Thanks!
Allison
