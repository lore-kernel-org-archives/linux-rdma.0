Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449845;
	b=qUO8WLGWxmaGfBv+CA0nU7KrvayRs8BhrIe2u72+x3o93ruOVD40E0DWIYnkX+4YDd2s
	 dd0cYrONu2xvTOPHMCwfrMG4cjOVqqTSJnRpEJUe7OHXHtydFHajje9MpxbSpIQoK5XXx
	 j0ZEOHnynz+j0c+t6NkPnX4gyIZM6ZrnB2cOPbWMtbPZO71nqEOosWD1Zpu24c1U942t2
	 4wV6seOzczJjG0aiL7dbKjbzHvSQ4X2X5Biv921jV/AeP1VdFjfuLod/Ehnw0R2/nD3sT
	 gLTfVj/AWpij81YxCh/IbPHa9n45omj+FtMlWMsbRHrd0fAvFgTQ6NmatRvZJblTSBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449845;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=+dNjgBC2+QzhU+cjcTNlNzFVT+rLL5KRnH7o4DHsvCk=;
	b=HzSwkntTqFigLgzQcCMkm+C9aK+ZmwpzeQnqSaiYLLNXrva7DUpQcEkBPq+ezI7OBWob
	 j8O/19MoAdCAzg6ew6lBydJnyBxq9fVLR4+4dBY1JYlxcEErionMc7YhLi+U6Lmty36u+
	 nFAZ/lBhYSAZY5njgUTQNYc/MKM1monE5NSFYID3UIfA18FJsbRvEHEg5jJU31vVy/v/v
	 OTzQauh2rbWGi/rqQm38Kg22jute3uguMJ5U9dUvk5lKUoAv6/JbuR3KPYdiKZZk43IBX
	 zF8H5erIu0WyavPXemmP2HeXDRgebiIoWCgbB8bcu+Ah4uAbyWuVAPYbpxho4C4I+0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iKISpuaY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD466606A319;
	Mon, 19 Oct 2026 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iKISpuaY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F4A1F000C4;
	Mon, 19 Oct 2026 22:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792449844;
	bh=+dNjgBC2+QzhU+cjcTNlNzFVT+rLL5KRnH7o4DHsvCk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iKISpuaYGy1oGof2BsP8zRzRcOoi/dmugJgX16sfDIJg+7RGTWP0FfD1a+Hz04R4r
	 AG9aNlCv1S6mMdKFOIUC+v38IDqdU0NkbnUxsPaPXfXjerslcrSZEITvBDg7KBVdhO
	 N4h2PFrB//KC1nmOWmU67cnK68RqZ2lbf4+97rEoVFMCPeCBAM76dlcbgupE1PrFWh
	 gF6SbG9H+j65iH7nUpOid2FBblp8mX1aOdH53jnf5q4/dhp9X5hP9NSHk9PKlVfVru
	 pvCIgmn7XmHr/iy5MSghhm3HJrjWHTivGPY3ih6NjyppK8keBU+sbkIzsT+lmSYpmU
	 /8LRYHriQsu4w==
Message-ID: <b5ed40d362375f5e93669a974b1ca03b716afa2a.camel@kernel.org>
Subject: Re: [rds-devel] [External] : Re: [PATCH net] RDS/IB: validate
 receive completion payload length
From: Allison Henderson <achender@kernel.org>
To: Gerd Rausch <gerd.rausch@oracle.com>
Cc: sungbyeongchan <tjdqudcks0424@naver.com>, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>, Andy Grover <andy.grover@oracle.com>, 
 "netdev@vger.kernel.org"
	 <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	 <linux-rdma@vger.kernel.org>, "rds-devel@oss.oracle.com"
	 <rds-devel@oss.oracle.com>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Mon, 19 Oct 2026 15:44:03 -0700
In-Reply-To: <30C797F2-FB1B-494D-8E36-B50C58BB8A03@oracle.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
	 <c1efb25a93739dfe2c16828bbcdc9bd7535850c1.camel@kernel.org>
	 <7e69b862-7cad-443f-912b-ce2db7854d60@oracle.com>
	 <f1504e3ae8da8789bcd6cd474ce51fec7dd15555.camel@kernel.org>
	 <30C797F2-FB1B-494D-8E36-B50C58BB8A03@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, 2026-10-18 at 18:32 +0000, Gerd Rausch wrote:
> Hi Allison,
>=20
> > On Oct 17, 2026, at 22:38, Allison Henderson <achender@kernel.org> wrot=
e:
> > On Fri, 2026-10-16 at 13:18 -0700, Gerd Rausch wrote:
> > >=20
> > > On 2026-10-06 18:13, Allison Henderson via rds-devel wrote:
> > > > > --- a/net/rds/ib_recv.c
> > > > > +++ b/net/rds/ib_recv.c
> > > > > @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_c=
onnection *conn,
> > > > > }
> > > > > }
> > > > >=20
> > > > > + if (data_len !=3D min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE=
)) {
> > > > > + rds_ib_conn_error(conn,
> > > > > +  "incoming fragment payload length %u, expected %u; "
> > > > > +  "disconnecting and reconnecting\n",
> > > > > +  data_len,
> > > > > +  min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE));
> > > > > + goto done;
> > > > > + }
> > > > > +
> > > > > list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
> > > > > recv->r_frag =3D NULL;
> > > > >=20
> > > How does forcing a reconnect help this situation?
> > >=20
>=20
> [...]
>=20
> >=20
> > On the retransmit loop: cp_retrans only matters if the sender is our
> > own RDS stack, and our stack can't produce the fragment this check
> > rejects.
>=20
> Correct. But this check was presumably added for a reason.
>=20
> 1) An incorrect implementation of RDS (other than the one we're looking a=
t)
> 2) A bad actor, intentionally crafting such messages.
>=20
> > > Therefore, apart from security concerns, the previous behavior of gar=
bage-in / garbage-out
> > > is IMO better than this behavior of just endlessly forcing a reconnec=
t.
> >=20
> > The trouble is that the garbage going out wasn't the sender's.  The
> > receiver delivered h_len bytes of a page that only had data_len bytes
> > written into it, so the tail was whatever the page held before: an
> > earlier message to another socket (the report demonstrated this across
> > UIDs), or unzeroed memory on a fresh page.  That's the bug. And
> > refusing to deliver it is the whole fix.
>=20
> Wait. This patch was created for a hypothetical case, no?
> Based on analysis of "Assisted-by: LLM".
Per Documents/process/coding-assistants.rst it means an LLM contributed in
some way, but sungbyeongchan patch had a reproducer and Shubham validated
it under KMSAN

>=20
> This patch does *not* refuse to deliver the bogus message.
> That would have been a fine choice.
>=20
> This patch just drops the underlying connection, in the hopes
> that when this message gets sent again, it'll somehow be different.
The short fragment is never linked, and the half-built inc is freed when th=
e
connection shuts down, so it doesn't reach the socket.

>=20
> What would make it different?
> Some unknown and non-deterministic sender?
>=20
> >=20
> > Dropping the connection is also what rds_ib_process_recv() has always
> > done for the neighbouring case, a fragment whose header doesn't match
> > the message in progress.  That check has been there since 1e23b3ee0e94
> > and has the same "a misbehaving peer can keep us reconnecting"
> > property.  This patch doesn't add a new failure mode, it just closes
> > the one way a malformed fragment could still get through.
>=20
> How much benefit a 16bit IPv4 checksum calculation adds on top of
> the underlying InifiniBand CRC-32 protection is debatable.
>=20
> But let's just say somehow (I don't know how) the CRC-32 check missed
> a header corruption that ip_fast_csum() catches:
> You're correct, the connection would be dropped.
> So the assumption here is that this is a transport error,
> that fixes itself with a retransmit, and not that it's a bogus
> or malicious sender.
>=20
> Does this patch also assume we're looking at a transport
> error, that the CRC-32 didn't catch, and consider that more likely
> than a bad or malicious sender?
>=20
> I suggest that just dropping this message, not tearing down the connectio=
n,
> would have been a much better choice here.
>=20
> > >=20
> >=20
> > > If there's a strong desire to address this issue, the sender should b=
e
> > > told to discard the message. A reconnect doesn't address this issue.
> > >=20
> > I don't think there's a way to say that today.  The RDS header flags ar=
e
> > congestion-bitmap, ack-required, retransmitted and the extension-header
> > bit.  The only error a receiver can signal to its peer is to drop the
> > connection.
> >=20
>=20
> Not exactly true.
> There's already code for the RDMA_CM_EVENT_REJECTED case to downgrade
> protocol version.
>=20
> The RDS code can be changed. The RDS protocol can be extended.
> A receiver could be made to tell a sender to drop a message,
> if we'd consider that beneficial.
>=20
> But in this case, since the message itself violates the "unwritten rules"
> of the RDS protocol, I'd say just dropping the message would be been
> a fine choice.
>=20
> Dropping the connection however, doesn't do anything.
> It just asks the sender to send the same bogus message again.
>=20
> > A per-message reject would be a protocol extension that both ends have =
to
> > implement.  But that would be net-next material, and it couldn't help
> > against the only peers that actually send these.  I'd be happy to revie=
w it
> > if someone wants to take it on, but I don't think it should hold up a s=
table
> > fix for a data disclosure.
> >=20
>=20
> Again, we don't need to do that.
> Dropping the message would have been a fine choice here.

I think dropping just the offending message, and skipping the rest
of its fragments by sequence, would be a reasonable refinement for
net-next.  And it would make sense to treat the header-mismatch exit
the same way at the same time.  I'd be happy to review patches for those.

The landed fix does refuse to deliver the message though. The conn drop is
the same policy the other exits in that function use too, so it's the right
solution for stable.  Patches welcome on the other points though.

Thanks!
Allison

>=20
> Thanks,
>=20
>   Gerd
>=20

