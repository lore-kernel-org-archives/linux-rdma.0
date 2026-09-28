Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24931AABC;
	Mon, 28 Sep 2026 04:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790570330; cv=none; b=CdwZfSkcSMMe+mUhNbZfqyIJubUb8FZ+77VrJ+h9GJT1YqRYfP4jUaiENMR15LwPLdsNywuYOBiv2MaPPbSyBzqCBvG0Hkkl4DiB/A7UolfyJbKRxM1patsXyK4PmrY5NNJSFFOTwo9b4BOm/j1gUSkbpBxldmNMNX1qgsr4q8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790570330; c=relaxed/simple;
	bh=ue0QM7Mir8rWRlAnTERaHNVkm+eOQtmICrgNWfSx1Qw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=paFUze5SEjqPuYXfpy/EopQ+etvHtHigSd4YLoV9vp4wJhJqCroGleRl4hVT2c/iRRtHlesGi2OLRGWiqNldRPTUVqC1w8J9PhAyhhS0xpKeAT/siWyasqrq2nWxs3kqibKGT8QMMNSXzG+8WONHDaGol1g7YHfPoMDqDuiYyoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lpvYD6vF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpvYD6vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856291F000FF;
	Mon, 28 Sep 2026 04:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790570328;
	bh=0cZrUf/IBYobzQta0cxvzQfyvQ8ia5XyPfmH82QNxSQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lpvYD6vFj3kn4Pj0+vkUWuxMhPCQAMDljmKRtREkb4kJaz+ELrM9NGS0gv6JUDSKx
	 zTrT7uA6N1CmAsNrTif5R+LDQ1msu1I/hYxXVk37bmbPZx+PxQSqqSCzTdEc5myNmk
	 D007X+hV4maS+W6l81tCs6YKQwqdnX23kKe8V7qrY7I57iMWKcb6UtZ+Z46ZDdfr54
	 UJTuwdNanOHhcFzTvfmzs0aMYUTkjZprFlER6NLzzwKx/qNZtmi/jlQ+z1bNbU9Xn8
	 +FFIX+xAnVZbzIuASTXjQt+ZFTx0A7MRIqJg2Ew3b3D+/bOWTRE2LhvOCB4FPP0Ttf
	 jFgbuBaFWZ+XA==
Message-ID: <5ee7e43c998eaaa75d630b077a77aef3721298c9.camel@kernel.org>
Subject: Re: [PATCH net-next v3] net/rds: restrict the rdma_cm ids to IB
 devices
From: Allison Henderson <achender@kernel.org>
To: Simon Horman <horms@kernel.org>, netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org
Date: Sun, 27 Sep 2026 21:38:47 -0700
In-Reply-To: <20260927111140.GG13925@horms.kernel.org>
References: <20260922084837.390414-1-achender@kernel.org>
	 <179033694505.2160803.10055619633105856141@kernel.org>
	 <20260927111140.GG13925@horms.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2026-09-27 at 12:11 +0100, Simon Horman wrote:
> On Fri, Sep 25, 2026 at 11:49:05AM +0000, netdev-bot+sashiko@kernel.org w=
rote:
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue(s) to consider.
> >=20
> > Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0 (1)
> >=20
> > If you believe none of the issues are legitimate, please reply to each
> > issue of Medium severity or higher and explain why the AI is wrong.
> > If any of them are legitimate and you plan to respin, please let patchw=
ork
> > know by including "pw-bot: cr" as a separate line at the end of your re=
ply
> > (one such reply per series is enough).
> >=20
> > - [Medium] Commit-message misclassification: the changelog declares thi=
s
> >   change "hardening on top of it, not a fix in its own right, hence no=
=E2=80=A6
> >=20
> > Pre-existing issues:
> > - [Low] rds_rdma_listen_init_common() (net/rds/rdma_transport.c) logs t=
he
> >   listening port as the compile-time constant RDS_PORT (18634) at line=
=E2=80=A6
> >=20
> > --
> >=20
> > net/rds: restrict the rdma_cm ids to IB devices
> >=20
> > This restricts the three rdma_cm ids RDS creates - the listener, the
> > per-connection id in rds_ib_conn_path_connect() and the probe id in
> > rds_ib_laddr_check_cm() - to RDMA_NODE_IB_CA with
> > rdma_restrict_node_type() before they are bound.  The explicit node_typ=
e
> > test in rds_ib_laddr_check_cm() is dropped as redundant.
> >=20
> > > From the changelog:
> >=20
> > > With that, no rdma_cm event reaches RDS's handler from a device it
> > > has no transport for.  The handler itself still assumes IB: it assign=
s
> > > its transport pointer only for RDMA_NODE_IB_CA and dereferences it
> > > regardless, which is the crash that first surfaced this.  The fix for
> > > that is a separate net patch, Aohan Mei's "net: rds: fix uninitialize=
d
> > > trans dereference in CM event handler", and is what stable kernels
> > > without rdma_restrict_node_type() - which arrived in commit
> > > a760e80e90f5 ("RDMA/core: introduce rdma_restrict_node_type()") - hav=
e
> > > to take; this patch is hardening on top of it, not a fix in its own
> > > right, hence no Fixes tag.
> >=20
> > [Severity: Medium]
> > Is the "not a fix in its own right, hence no Fixes tag" classification
> > accurate for the tree this applies to?
> >=20
> > The referenced companion patch ("net: rds: fix uninitialized trans
> > dereference in CM event handler") is not present here.  In
> > rds_rdma_cm_event_handler_cmn() the transport pointer is still
> > uninitialized on entry:
>=20
> I find this to be a specious argument.
> Of course a kernel without a fix applied is not fixed.
>=20
> I believe the appropriate question, regarding fixing the Kernel, is if th=
e
> cited fixed actually fixes the problem.  That question is not addressed
> here.  And indeed it's not a question to be answered here as it's a quest=
ion
> to be answered in the context of reviewing the cited fix.

Agreed, I had sent out a v4 last night just before this response. The code =
change
is the same, but I did add the Fixes tag for the listeners the review talke=
d about.
As well a comment stating the patches are independent.

The companion patch is Aohan's, and his v2 thread has been quiet since late
August, so I'll carry it forward as a v3 to net with the review comments
on v2 addressed.

>=20
> >=20
> > net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
> > 	struct rds_connection *conn =3D cm_id->context;
> > 	struct rds_transport *trans;
> > 	...
> > 	if (cm_id->device->node_type =3D=3D RDMA_NODE_IB_CA)
> > 		trans =3D &rds_ib_transport;
> > 	...
> > 	case RDMA_CM_EVENT_CONNECT_REQUEST:
> > 		ret =3D trans->cm_handle_connect(cm_id, event, isv6);
> > 	...
> > 	case RDMA_CM_EVENT_ESTABLISHED:
> > 		if (conn)
> > 			trans->cm_connect_complete(conn, event);
> > }
> >=20
> > So for any event arriving from a device whose node_type is not
> > RDMA_NODE_IB_CA, trans is dereferenced as stack garbage, and the
> > CONNECT_REQUEST case is reachable from an inbound connection on the RDS
> > port.
> >=20
> > Before this patch cma_listen_on_dev() installed the RDS listener on eve=
ry
> > RDMA device, and cma_acquire_dev_by_src_ip() could pick a software iWAR=
P
> > device for the same netdev, which is what made that path reachable.  Wi=
th
> > the listener restriction added below, cma_listen_on_dev() honours
> > restricted_node_type and no longer installs the listener on such a devi=
ce.
> >=20
> > That makes this patch the change that removes the remotely reachable ro=
ute
> > to that indirect call in this tree.  Should it then carry a Fixes tag a=
nd
> > state the ordering dependency on the companion handler patch, rather th=
an
> > being described as hardening only?
> >=20
> > > diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> > > index b15cf316b23a2..91ff1dde26af0 100644
> > > --- a/net/rds/rdma_transport.c
> > > +++ b/net/rds/rdma_transport.c
> > > @@ -210,6 +210,14 @@ static int rds_rdma_listen_init_common(rdma_cm_e=
vent_handler handler,
> > >  		return ret;
> > >  	}
> > > =20
> > > +	/* Only the IB transport is left, so only listen on IB devices */
> > > +	ret =3D rdma_restrict_node_type(cm_id, RDMA_NODE_IB_CA);
> > > +	if (ret) {
> > > +		pr_err("RDS/RDMA: failed to setup listener, rdma_restrict_node_typ=
e() returned %d\n",
> > > +		       ret);
> > > +		goto out;
> > > +	}
> > > +
> > >  	/*
> > >  	 * XXX I bet this binds the cm_id to a device.  If we want to suppo=
rt
> > >  	 * fail-over we'll have to take this into consideration.
> >=20
> > [Severity: Low]
> > This isn't a bug introduced by this patch, but since the patch touches
> > rds_rdma_listen_init_common() anyway: the debug line further down in th=
e
> > same function hard-codes the port,
> >=20
> > 	rdsdebug("cm %p listening on port %u\n", cm_id, RDS_PORT);
> >=20
> > while the helper has two callers with different ports.
> > rds_rdma_listen_init() binds the IPv4 listener with
> > sin.sin_port =3D htons(RDS_PORT) and the IPv6 listener with
> > sin6.sin6_port =3D htons(RDS_CM_PORT), as the comment above it describe=
s.
> >=20
> > For the IPv6 listener the message therefore prints 18634 rather than th=
e
> > 16385 that was bound.  Would it make sense to print the port from the s=
a
> > argument that was just bound instead?
>=20
> If this is a problem it is separate to this patch,
> and should be addressed separately.

Yes, v4 has that as a separate second patch to address this part

>=20
> In all, this patch looks good to me.
>=20
> Reviewed-by: Simon Horman <horms@kernel.org>
>=20
Thank you!  I'll carry your rvb on patch 1 of v4 unless you'd
rather look at it again.

Allison

