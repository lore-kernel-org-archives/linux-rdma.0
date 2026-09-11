Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC5744A409;
	Fri, 11 Sep 2026 08:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789114803; cv=none; b=S+oYV3/6+Co8w3UY38lEnZXLqGdatsMtlgI4QFcqgsOvRE7dNFqxjnbqLtG7fqogo6PxUmtT/TYH0Yr1UiQOWTQErc9BsHwxdfnQ5QESZsV16qFarhbQT9E2IY2UPEwornnOGFuqxh4qaYTQmQqhs4hAnWoB+t2BXYKGByhnz48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789114803; c=relaxed/simple;
	bh=C6hfFzDo7v5BZEU+HG6NPZGEiawNsijk2RzbuWxQO9E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZCblvyzv4FcCLsdlQblLn+TXfZjVUlKhOsb2kTAYFFRROGlRACCJFWDfwSh2PEgH8TAnpuIHLRjN2ijZoFgbodh67KY39zr4X9yyH0EgLQMJu2MPl+dbWwZR1CKTsf5L70lPYCJHKnbK0Xkflc3sg+Y1QWvlDMSjeeDMWBao3Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AM42Spyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AM42Spyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750CB1F000FF;
	Fri, 11 Sep 2026 08:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789114801;
	bh=dRVhQp/xD9OTeZ4zbSnkVknALx+sVGqIgTWDZdOIgaw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AM42Spyjrk19X96bBWk6Rv3VjehZkQgxvH3cojNaZ7DHNTh/KMSuYVY+a7ZL2idmb
	 rW+zzEzGpWlddyzxQI658hYN6aOMQVUK54BRymHX4yiXPkYaX36PJPlEZtOH3pLs2q
	 +YrLWDY8kRbILfWXVd9ypkqicDOYxMDaC7OYnN+ptIQBNTRTuWzaAVvY7lxUf3T4ez
	 rRJp4iGh68t0K7T7v0ANiiRjYuriJVdxUzze2H6OjNwS0mvF+HXfOw7OQYQrxXf5+l
	 vNDHq4Wsvl1bvG/gMiY7+em0GEfHoWKBh7+ve+7MsSt0j6ZEodfA986w9LCUdIjsVo
	 mv/1tB3dHVGaw==
Message-ID: <71f12722dde5d7fc8e8507173016fa4f7681995b.camel@kernel.org>
Subject: Re: [rds-devel] [External] : Re: [PATCH net] rds: ib: use
 rds_conn_drop() on protocol version mismatch
From: Allison Henderson <achender@kernel.org>
To: Gerd Rausch <gerd.rausch@oracle.com>, henrymei
 <ljp1205831794@gmail.com>,  netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	santosh.shilimkar@oracle.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, Aohan Mei
	 <henrymei@tencent.com>, TencentOS Corvus AI <corvus@tencent.com>, 
	stable@vger.kernel.org
Date: Fri, 11 Sep 2026 01:19:59 -0700
In-Reply-To: <22d59d86-91a6-4df5-8502-0885b25c4761@oracle.com>
References: <20260908123356.1163970-1-henrymei@tencent.com>
	 <4fda023c1e7152aee2d5f977f5045dcddcd08d8d.camel@kernel.org>
	 <10cf2701-211a-42fe-bb1b-c218d718ed2b@oracle.com>
	 <2338b4729960abdf0c753d39cb3b7056421bac18.camel@kernel.org>
	 <a4b5d873-4746-4e36-ae15-c45957459fb4@oracle.com>
	 <06792614227360acd42d62693d0af78d0f9e947e.camel@kernel.org>
	 <22d59d86-91a6-4df5-8502-0885b25c4761@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-09-10 at 16:56 -0700, Gerd Rausch wrote:
> Hi Allison,
>=20
> On 2026-09-10 15:58, Allison Henderson wrote:
> > On Thu, 2026-09-10 at 10:08 -0700, Gerd Rausch wrote:
> > > Before this patch, a version 3.1 connection is expected to be establi=
shed.
> > > After this patch, there's an infinite connection retry attempt every =
second,
> > > that'll never succeed.
> >=20
> > I think we might be talking about different branches of code?  It
> > looks like the downgrade you're describing is in the REJECTED case of
> > rds_rdma_cm_event_handler_cmn().  But this patch doesn't touch that.
>=20
> Of course, it doesn't.
>=20
> But rds_ib_cm_handle_connect() issues a rdma_reject(IB_CM_REJ_CONSUMER_DE=
FINED) with payload
> err =3D 1 (aka RDS_RDMA_REJ_INCOMPAT) not only if rds_ib_protocol_compati=
ble()
> returns zero, but all sorts of other scenarios also.

Yes, err starts as 1 and the conn-create failure and connect-race exits
go to the reject without changing it.  So you are correct that the peer can=
't tell
"incompatible" from "you raced me".  That's a wart, and worth a patch of it=
s
own to give those exits their own code.  But I still think it's separate fr=
om this
fix, since it doesn't touch the reject side in either direction.

>=20
> And when that rdma_reject(IB_CM_REJ_CONSUMER_DEFINED, 1) is issued,
> then received by the peer, it lands in rds_rdma_cm_event_handler_cmn(), w=
here this:
> --------%<--------%<--------%<--------%<--------%<--------
>      conn->c_proposed_version =3D RDS_PROTOCOL_COMPAT_VERSION;
> --------%<--------%<--------%<--------%<--------%<--------
> version downgrade is expected to happen.
>=20
> Subsequently it should be the node that did the downgrade to COMPAT_VERSI=
ON
> that tries again.
>=20
> Not the peer. The peer should back off, as it didn't go to COMPAT_VERSION=
.
>=20
> Looking at rds_ib_protocol_compatible(), it seems terribly broken,
> and AFAICT, none of this stuff works intuitively or even correctly.
>=20
> But one thing is very clear to me:
> We should never let the side that has an incompatible / wrong
> "conn->c_version" value continue to attempt to connect.
>=20
> That side never downgraded the "c_proposed_version" and will
> just keep on repeating what didn't work before.
>=20
> And yet, that is exactly what this patch proposed:
> Don't destroy the connection, but keep on trying with
> the wrong "conn->c_version" / "conn->c_proposed_version".
>=20
> > The 3.1 exemption in rds_ib_cm_connect_complete() is a few lines above
> > the one being changed, and it isn't touched either.  So a 3.1 connectio=
n
> > should proceed exactly as before.
> >=20
>=20
> I don't understand.
>=20
> Why would the connection proceed exactly as before,
> when "before" only one side retried with a downgraded 3.1 version,
> but "after" both sides retry with a mix of 3.1 and and whatever incompati=
ble
> version the other node had?
> It'll be a game of "who's fastest".
>=20
> > The changes here are only reached in the RDMA_CM_EVENT_ESTABLISHED case=
,
> > after the peer has already accepted, and only when the version it accep=
ted
> > with is below 3.1. IOW: that is specifically a peer that answered our
> > 3.1 proposal with 3.0.  Or an accept that carried no (or truncated)
> > private data, which leaves c_version at 0 on a fresh conn.
> >=20
>=20
> What you described as "carried no (or truncated) private data"
> is the normal case for IB_CM_RTU_RECEIVED:
>=20
> The RDS/client issues an rdma_connect() (REQ) with user specified payload=
.
> That arrives at RDS/server inside rds_ib_cm_handle_connect(),
> which inspects protocol-version etc.
>=20
> Then the RDS/server issues an rdma_accept() (REP) again with user specifi=
ed payload.
> That arrives at the RDS/client as RDMA_CM_EVENT_ESTABLISHED *with* payloa=
d
> and inside RDS' function rds_ib_cm_connect_complete().
>=20
> And then the RDS/client (actually the CM layer) sends out an RTU, that ma=
kes the RDS/server
> land inside rds_ib_cm_connect_complete() too, but with "private_data_len=
=3D=3D0".
>=20
> So a "major =3D=3D 0" doesn't imply something being truncated nor it bein=
g
> a fresh conn, but simply is the last step you see on an RDS/server
> during connection establishment.

Also right, and I should have specified "on the active side".  On the
passive side the version was already set from the REQ in
rds_ib_cm_handle_connect(), and it is always 3.1 or newer there
because anything else was rejected before the accept.  So the RTU
arriving with no payload leaves a valid c_version in place and the
branch can't fire.  That also means the changed line only runs
on the active side, and only when the REP says 3.0 or says nothing.

>=20
> It is rather curious that RDS performs a compatibility check inside
> rds_ib_cm_connect_complete(), i.e. after a RDMA_CM_EVENT_ESTABLISHED
> was received.
>=20
> IMHO the compatibility ought to be checked prior to issuing an "rdma_acce=
pt()",
> proposing common denominator version(s) that are appropriate for both sid=
es.
>=20
> Not after the connection had already been established.

That would make more sense in principle. That's what rds_ib_protocol_compat=
ible()
already does before the accept on the passive side.  On the active
side there isn't an earlier hook. AFAICT, rdma_cm moves the QP to RTS and s=
ends
the RTU inside cma_rep_recv() before it delivers RDMA_CM_EVENT_ESTABLISHED.
So the first time the active side sees the version the peer picked, the con=
nection
is already up.  That's why the check ended up in rds_ib_cm_connect_complete=
().
Its not pretty, but I think that's really more about following CM API. =20

>=20
> The question if an incompatible connection ought to be destroyed or not
> wouldn't come up, if we didn't allow incompatible connections to be creat=
ed
> in the first place.
>=20
> > There is no fallback for that case before or after the patch. 3.1 is th=
e
> > compat floor, so there's nothing lower to fall back to.  Before
> > the patch, that branch calls rds_conn_destroy() under c_cm_lock and
> > deadlocks against rds_conn_shutdown().  Which then stalls every RDS
> > connection on the node.  After the patch it drops the conn and
> > retries with backoff. =C2=A0Neither case establishes a connection, and =
neither
> > was ever going to.
> >=20
>=20
> The important bit that's missing here is that the side that did the
> "c_proposed_version =3D RDS_PROTOCOL_COMPAT_VERSION" downgrade
> is the one that needs to initiate.
>=20
> Or else, we run the risk of running into endless loops of trying the same
> thing again and again and again.

Well, there is a downgrade in the REJECTED path, and the downgrading side
probably should be the one to retry.  But in the branch this
patch changes, nobody rejected.  The peer accepted, with a version below
the floor, so there's no downgrade available to either side.

So the loop is there either way.  The conn is torn down (via destroy or
by drop), the peer gets a DISCONNECTED, drops, and reconnects to us on
its own timer (IB has no smaller-address rule in rds_queue_reconnect()),
and we reject it in rds_ib_cm_handle_connect() every time.

Destroy doesn't make the peer back off; it just moves the 1 second loop
to their side of the wire.  The next sendmsg() on our side starts it
again from ours. The thing that actually stops the loop is "retry only
when an application sends", which is the follow-up I'd like to see, and
would need to cover the REJECTED path too.


>=20
> But this whole protocol negotation in RDS is rather broken.
> I guess some would call it "organically grown over the years".
>=20

Agreed, I don't think anyone would dispute that RDS has plenty
of things to fix.  But to me that's the reason to shepherd small,
targeted fixes through one at a time rather than gate them on
each other, or on a rework of the negotiation.  This one turns a
node-wide hang into the same retry loop the peer already drives today,
with a one-line change that's easy to revert when we get to larger
changes.

So my suggestion would be: take Aohan's fix as is for net, and treat
the reject-code cleanup, the send-driven retry, and any negotiation
rework as separate net-next patches.  I'd be glad to review any of
them, and happy to help with the send-driven one if you'd like to
take it.

Thanks,
Allison



> Thanks,
>=20
>    Gerd
>=20

