From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 09:09:42 -0800
Message-ID: <20091215090942.b33ddc1e.weiny2@llnl.gov>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	<f0e08f230912150716y392cf1f1t4cd640b6663f7fea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230912150716y392cf1f1t4cd640b6663f7fea-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Dec 2009 10:16:42 -0500
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Ira,
>=20
> On Mon, Dec 14, 2009 at 7:43 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> > Sasha, Hal,
> >
> > I have found that the following patch caused our SRP connected stor=
age to
> > break.
>=20
> What is causing the SRP target to fail ? Is it a non zero hop limit
> returned in the SA PathRecord ?

I am not sure exactly because I don't know what the SRP Target is seein=
g.
(pesky firmware...)  :-(

>=20
> > patch: 3d20f82edd3246879063b77721d0bcef927bdc48
> >
> > =A0 =A0opensm/osm_sa_path_record.c: separate router guid resolution=
 code
> >
> > =A0 =A0Move off subnet destination (router address) resolution code=
 to separate
> > =A0 =A0function to improve readability.
> >
> > =A0 =A0Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> >
> > I further traced the problem to pr_rcv_build_pr and the patch below=
 fixes the
> > bug.
>=20
> On quick glance, I'm missing the connection between Sasha's patch and
> this routine setting something bad in the hop limit of the returned
> path record.

It sets p_dgid even when we are not using a router which results in
is_nonzero_gid being true.

>=20
> > 16:03:34 > git diff
> > diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm=
_sa_path_record.c
> > index be0cd71..32c889f 100644
> > --- a/opensm/opensm/osm_sa_path_record.c
> > +++ b/opensm/opensm/osm_sa_path_record.c
> > @@ -800,7 +800,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, I=
N const osm_port_t * p_src_port,
> >
> > =A0 =A0 =A0 =A0/* Only set HopLimit if going through a router */
> > =A0 =A0 =A0 =A0if (is_nonzero_gid)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_pr->hop_flow_raw |=3D cl_hton32(IB_=
HOPLIMIT_MAX);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_pr->hop_flow_raw |=3D IB_HOPLIMIT_M=
AX;
>=20
> This may fix this issue but it doesn't look right to me and I think
> would break router scenarios and corrupts other field(s). Path record
> fields are in network (not host) order.

But HopLimit is an 8bit field?  I might be wrong on this but I was thin=
king
this set RawTraffic and parts of Flow label to 1's.  I should double ch=
eck
that.  Also, I wonder if the FW on the other side is flipping this wron=
g?  :-/
I have not been able to determine this and I still have to test with ou=
r other
vendor's SRP target...

>=20
> > =A0 =A0 =A0 =A0p_pr->pkey =3D p_parms->pkey;
> > =A0 =A0 =A0 =A0ib_path_rec_set_sl(p_pr, p_parms->sl);
> >
> >
> > "hop_flow_raw" is not really a 32bit value but rather 4 fields:
> > Component =A0 =A0 Length(bits) =A0 Offset(bits)
> > RawTraffic =A0 =A01 =A0 =A0 =A0 =A0 =A0 =A0 =A0352
> > Reserved =A0 =A0 =A03 =A0 =A0 =A0 =A0 =A0 =A0 =A0353
> > FlowLabel =A0 =A0 20 =A0 =A0 =A0 =A0 =A0 =A0 356
> > HopLimit =A0 =A0 =A08 =A0 =A0 =A0 =A0 =A0 =A0 =A0384
> >
> >
> > However, I don't understand the comment "Only set HopLimit if going=
 through a
> > router"?
>=20
> Well, in a sense the HopLimit is always set. It's already set to 0
> right above that code snippet in the patch where:
> p_pr->hop_flow_raw &=3D cl_hton32(1 << 31);

True, however, I believe the behavior before was that the entire field =
is 0
so the above statement really does nothing.

> This code is only setting the HopLimit to 255 (as this is very
> primitive so far) when going through a router. Maybe it could be
> stated better.

That is exactly what Sasha's patch changes.  This is not only executed =
when
going through a router but at all times DGID is specified in the CompMa=
sk.  I
am willing to accept the fact that perhaps p_dgid should not be set unl=
ess we
find a router, however, I __don't__ think that is correct.  Searching t=
he spec
I attempted to find where HopLimit was supposed to be 0xFF only when go=
ing
through a router and I could not find it; therefore my email, I'm confu=
sed
again...  :-(

>=20
> > Was the intent to only set p_dgid in pr_rcv_get_end_points if we ar=
e heading
> > through a router? I don't think it matters if we are going through =
a router
> > or not does it?
>=20
> It's used when DGID is selected in the SA PR query via the comp mask
> and in that instance is used for both the router and non router DGID
> cases.

So we agree that Sasha's patch is correct?

>=20
> > If not, I think the comment needs to be removed in the patch above.
>=20
> I'm not following why you say this.

Well, if HopLimit must only be set to 0xff when going through a router =
and
Sasha's patch is correct, then I think we need another way to determine=
 if
this path is going through a router.  In that case the comment is corre=
ct but
the logic is wrong.

Ira

>=20
> -- Hal
>=20
> > Thanks,
> > Ira
> >
> > --
> > Ira Weiny
> > Math Programmer/Computer Scientist
> > Lawrence Livermore National Lab
> > 925-423-8008
> > weiny2-i2BcT+NCU+M@public.gmane.org
> >


--=20
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
