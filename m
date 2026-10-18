Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3021348C6D;
	Sun, 18 Oct 2026 05:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792301892; cv=none; b=CucdcSAf0f/vzCrArnhv4LDnE+lx+xzkl1qiB3KDbj2oRXsXgBc1EU6r0SueuMxZetTHcGRa7OIaqmkJGmlQuOhAcjr2BAcTlFrJ54WyiZsF01V283K+nLPg2j7n8gXdooIXkWW9F/P/o9iPBDYuRyR8C7KU3N0Cbg+PMNE7PU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792301892; c=relaxed/simple;
	bh=lpYfcbbp/dqOjzrL/y9t5SP6QJzos/hzcl6m09z3C0A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N59bn/rXky5JHcbOjIuR6kn+juD4cZO5JN4POC1f5vVMQNfxo1E2LXDPMPoZRxJD5KeIvZuN3WVZf0MzC/YwFignbQaYuognXqWojflY1Z+9aVEuAS8n3jgfqMM8P1azqIonn9mvPqQHGLv3wnFXWFjiL4xiTpnAx9U0PeIzBlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VATH8ohg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VATH8ohg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E501F000C4;
	Sun, 18 Oct 2026 05:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792301890;
	bh=Vtx062sMT267uR+1dahU2irvboi7cB2dSCiWZpp1Ywk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VATH8ohgIu8qqwvA8JX2vSZyjpWv2YecLAyICL7soR5e0gFRAGG5j86lrVfbu5Tje
	 cKkxlezUn4iyYGUspZ81W8jUmha7yrX5g33HHIQBjSeqkf1pWsZuFWiicFHfgfOMmq
	 yodAcsh/FCukeCXLlw+GJqY69YQrH+7CI3Yqr7z2soaE1erqokxS1A/okOgXTdZ9Eu
	 EceqhVjW1Sd9FzslpDYJyH59BgHtSQrDSqWNfmM9qTkODQ9eYZbZlga6nN1BuX5N+X
	 +tbelCAV04Be9Iwx+qeNKg3W4cLfPJ24RRC5ShsyOJPUAu5KNeYfEUJnQRWNy5aPJw
	 sYxAyw/1vqTkQ==
Message-ID: <f1504e3ae8da8789bcd6cd474ce51fec7dd15555.camel@kernel.org>
Subject: Re: [rds-devel] [External] : Re: [PATCH net] RDS/IB: validate
 receive completion payload length
From: Allison Henderson <achender@kernel.org>
To: Gerd Rausch <gerd.rausch@oracle.com>, sungbyeongchan
 <tjdqudcks0424@naver.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>, Andy Grover
 <andy.grover@oracle.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Sat, 17 Oct 2026 22:38:09 -0700
In-Reply-To: <7e69b862-7cad-443f-912b-ce2db7854d60@oracle.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
	 <c1efb25a93739dfe2c16828bbcdc9bd7535850c1.camel@kernel.org>
	 <7e69b862-7cad-443f-912b-ce2db7854d60@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-16 at 13:18 -0700, Gerd Rausch wrote:
> Hi,
>=20
> On 2026-10-06 18:13, Allison Henderson via rds-devel wrote:
> > > --- a/net/rds/ib_recv.c
> > > +++ b/net/rds/ib_recv.c
> > > @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_conne=
ction *conn,
> > >  		}
> > >  	}
> > > =20
> > > +	if (data_len !=3D min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
> > > +		rds_ib_conn_error(conn,
> > > +				  "incoming fragment payload length %u, expected %u; "
> > > +				  "disconnecting and reconnecting\n",
> > > +				  data_len,
> > > +				  min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE));
> > > +		goto done;
> > > +	}
> > > +
> > >  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
> > >  	recv->r_frag =3D NULL;
> > > =20
> How does forcing a reconnect help this situation?
>=20
> After the reconnect, the sender submits the exact same (incorrect) messag=
e again,
> which it kept in "cp_retrans".
>=20
> Therefore, the exact same conditional triggers again.
>=20
> All but the last fragment of an RDS/IB message are expected to be of RDS_=
FRAG_SIZE.
>=20
> While there's no good protocol specification (to the best of my knowledge=
),
> posting an insufficiently large message can be seen as protocol violation=
.
>=20

Hi Gerd,

First, some bookkeeping to catch up with: this patch was submitted
slightly after Shubham's "RDS/IB: validate receive fragment completions",
which effectively the same patch.  Shubham's variant went through a few
revisions on netdev and is now in the net tree as 65cf6863606b.  It
varies only slightly, so your questions still apply, but to a different
patch and one that's already merged:

https://lore.kernel.org/netdev/20261013025729.40815-1-shubham@octane.securi=
ty/

On the retransmit loop: cp_retrans only matters if the sender is our
own RDS stack, and our stack can't produce the fragment this check
rejects.  rds_ib_xmit() posts every fragment but the last at
RDS_FRAG_SIZE, because the scatterlist entries it works from are full
pages except the final one.  It even BUG_ONs if it's ever asked to
resume a message at an offset that isn't a multiple of RDS_FRAG_SIZE,
which can only hold if everything sent so far went out in full
fragments.
 =20
MSG_ZEROCOPY is the only path that produces odd-sized entries, and
rds_sendmsg() refuses it for anything but TCP.  So a Linux peer never
trips this, before or after a reconnect.  The peer that does trip it
is already off the protocol, as you say, and whatever it retransmits
isn't governed by our cp_retrans.

> Therefore, apart from security concerns, the previous behavior of garbage=
-in / garbage-out
> is IMO better than this behavior of just endlessly forcing a reconnect.

The trouble is that the garbage going out wasn't the sender's.  The
receiver delivered h_len bytes of a page that only had data_len bytes
written into it, so the tail was whatever the page held before: an
earlier message to another socket (the report demonstrated this across
UIDs), or unzeroed memory on a fresh page.  That's the bug. And
refusing to deliver it is the whole fix.

Dropping the connection is also what rds_ib_process_recv() has always
done for the neighbouring case, a fragment whose header doesn't match
the message in progress.  That check has been there since 1e23b3ee0e94
and has the same "a misbehaving peer can keep us reconnecting"
property.  This patch doesn't add a new failure mode, it just closes
the one way a malformed fragment could still get through.
>=20

> If there's a strong desire to address this issue, the sender should be
> told to discard the message. A reconnect doesn't address this issue.
>=20
I don't think there's a way to say that today.  The RDS header flags are
congestion-bitmap, ack-required, retransmitted and the extension-header
bit.  The only error a receiver can signal to its peer is to drop the
connection.

A per-message reject would be a protocol extension that both ends have to
implement.  But that would be net-next material, and it couldn't help
against the only peers that actually send these.  I'd be happy to review it
if someone wants to take it on, but I don't think it should hold up a stabl=
e
fix for a data disclosure.

Hope that helps!
Allison

> Thanks,
>=20
>    Gerd
>=20
