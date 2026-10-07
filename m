Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2D83DC4B6;
	Wed,  7 Oct 2026 06:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791353188; cv=none; b=aQHxWwzos1wKDKPE9pjdgxAHyL5gXlcvAjsar1gmMvWd5bT837qn0opKw6lDJUTgxySpCycaScH/kaSmGyARcGj5ej2FLt+OdWVfG+o6Smz6KcWy6vD4RJQIX4+OMcF2PtOY9S6CtMNwJjGmTwMPdlcGpcVIu9Bx5dD9ZPBWyhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791353188; c=relaxed/simple;
	bh=Y8hgSlKcZdst4akLUIhYEfpydL2AlM7dh1YB5EurAhw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EeHJENM9QrqJ97R0gHDRlRbpDlN5i5bgGDstsAjAu8hDEuNz80hLVLS5SMjtTLr0yMFz0GXR26UWtqv9kLzVWUVE++Itl/zDQ9D44I+OIktpwSu9jqcaZTcSmyoq0IKK86q+9tUq9ZS7mDmKxK+8rP/h87Gt4fDMBbWrBRIGpAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jptXhDFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jptXhDFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77CB1F0089D;
	Wed,  7 Oct 2026 06:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791353187;
	bh=30i1+/6CEnTdtu6RDIJk92KycF7EWDwxoP3fTD81ago=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jptXhDFiBOA9qc+bjMA1h6vQ7HXMkmsEPzhghR1pnbeyi6BQ5yPwJV4S+kfeiHNyK
	 T3lXuFSDzAGSWFHECC/aUiObjtVLGgwd2VacQZLTKDczw89QVZOgYBDrJXztR0ymku
	 6a/py1jtaiQK9DnroKpnU2STTmGtGYmMzNpFGj773B9EmB2eVYF0qfhyhfRwe8GSiY
	 RL/qsoNEL+sm3vC/qSOOMipUvriWDMfx/aP/uh0CfObGYTFor6urfII47bTjJBMW2b
	 X/jelbB5Ge1v7R1DXtQKzsktUt0Fz2xC6kHUKp14xrtevrobL+7oo1hSxB4DlD1Nc2
	 Hc7XON4chCeEw==
Message-ID: <8a6ee1d5336ae65b8ffdc8c40a1135657207e204.camel@kernel.org>
Subject: Re: [PATCH net] net/rds: ib: drop fragments shorter than the
 header-declared length
From: Allison Henderson <achender@kernel.org>
To: Shubham Antil <shubham@octane.security>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>, linux-kernel@vger.kernel.org, Giovanni Vignone
	 <gio@octane.security>
Date: Tue, 06 Oct 2026 23:06:26 -0700
In-Reply-To: <CAEBzjKEFZdKWHa5puYH6dKvaesCf-KGmZ+Z=fFECRi_0PhiY_A@mail.gmail.com>
References: <20261006125720.81227-1-shubham@octane.security>
	 <661e8b900c97d701382af26462bead7277eaa41f.camel@kernel.org>
	 <CAEBzjKEFZdKWHa5puYH6dKvaesCf-KGmZ+Z=fFECRi_0PhiY_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-10-07 at 07:13 +0530, Shubham Antil wrote:
> Hi Allison,
>=20
> Thanks very much =E2=80=94 I'll carry your Reviewed-by on the next revisi=
on:
>=20
> Reviewed-by: Allison Henderson <achender@kernel.org>
>=20
> And no objection at all to crediting the earlier private report:
>=20
> Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>
>=20
> This bug was found and reported by our team at Octane Security. Would
> it be okay if we add Reported-by tags for the people on our side who
> reported it along with the first reporter in the V2 patch?
>=20
> Reported-by: Shubham Antil <shubham@octane.security>
> Reported-by: Giovanni Vignone <gio@octane.security>
> Reported-by: Robert van Eijk <robert@octane.security>
> Reported-by: Paolo Gentry <paolo@octane.security>

Sure, that's fine.  Thank you!
Allison

>=20
> I'm happy to send a v2 with everything folded in - your Reviewed-by,
> sungbyeongchan's Reported-by and ours. Just let me know which you
> prefer.
>=20
> Thanks again,
> Shubham Antil
>=20
> On Wed, Oct 7, 2026 at 6:43=E2=80=AFAM Allison Henderson <achender@kernel=
.org> wrote:
> >=20
> > On Tue, 2026-10-06 at 18:27 +0530, Shubham Antil wrote:
> > > rds_ib_process_recv() accepts an incoming RDS/IB fragment once the
> > > receive completion reports at least an RDS header
> > > (data_len >=3D sizeof(struct rds_header)).  It then trusts the
> > > header-declared total message length h_len: for the first fragment of
> > > a message it stores be32_to_cpu(hdr->h_len) in ic->i_recv_data_rem,
> > > and rds_ib_inc_copy_to_user() later copies up to h_len bytes from the
> > > fragment pages to userspace on recvmsg().
> > >=20
> > > The number of payload bytes actually received into the fragment page =
is
> > > data_len (after subtracting the header), but it is never checked agai=
nst
> > > the amount the fragment is accounted to contribute to the message,
> > > min(i_recv_data_rem, RDS_FRAG_SIZE).  A fragment whose header adverti=
ses
> > > a larger h_len than the payload it delivers is still linked onto the
> > > reassembly list.  The fragment page comes from the per-CPU receive ca=
che
> > > and is not zeroed, so rds_ib_inc_copy_to_user() then copies up to h_l=
en
> > > bytes to the PF_RDS reader, including the uninitialized tail the rece=
ive
> > > never wrote.
> > >=20
> > > Reject a fragment that carries fewer payload bytes than it is account=
ed
> > > to contribute before linking it onto the reassembly list.
> > >=20
> > > The issue is reproducible under KMSAN with two hosts over rdma_rxe
> > > (Soft-RoCE); the same reproducer confirms the fix stops it.
> > >=20
> > > Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> > > Assisted-by: Claude:claude-opus-4-8
> > > Signed-off-by: Shubham Antil <shubham@octane.security>
> >=20
> > Hi Shubham,
> >=20
> > Thanks for working on this.  This patch looks good to me, you can add m=
y rvb:
> > Reviewed-by: Allison Henderson <achender@kernel.org>
> >=20
> > Also, this bug was found and reported privately by another contributor,=
 whom I had
> > counseled to send a patch publicly before I had noticed this one.
> > https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks0424@n=
aver.com/
> >=20
> > I find that patches equivalent, and this patch was posted first. But I =
would like to apply
> > the reported by tag since sungbyeongchan was the first to report it.
> > Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>
> >=20
> > Thank you both for working on this bug!
> > Allison
> >=20
> > > ---
> > >  net/rds/ib_recv.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >=20
> > > diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> > > index bd6cb3ffa..fee77b6d7 100644
> > > --- a/net/rds/ib_recv.c
> > > +++ b/net/rds/ib_recv.c
> > > @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_conne=
ction *conn,
> > >               }
> > >       }
> > >=20
> > > +     /* h_len must be backed by the payload actually received (data_=
len),
> > > +      * else the unwritten frag-page tail is copied to userspace.
> > > +      */
> > > +     if (data_len < min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) =
{
> > > +             rds_ib_conn_error(conn,
> > > +                     "fragment shorter than header-declared length; =
forcing reconnect\n");
> > > +             goto done;
> > > +     }
> > > +
> > >       list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
> > >       recv->r_frag =3D NULL;
> > >=20
> >=20

