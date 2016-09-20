From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 3/3] Provide remote XRC SRQ number in
 kernel post_send.
Date: Tue, 20 Sep 2016 14:01:15 +0300
Message-ID: <20160920110115.GJ26673@leon.nu>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
 <d57e9dc45f6f4aed9dfb86a498226dab99e530a4.1474063039.git-series.knut.omang@oracle.com>
 <20160919052911.GF3273@leon.nu>
 <1474276356.24045.93.camel@oracle.com>
 <20160920101839.GF26673@leon.nu>
 <1474368210.8837.3.camel@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Do4IU1xF/9sod/r6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474368210.8837.3.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Do4IU1xF/9sod/r6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2016 at 12:43:30PM +0200, Knut Omang wrote:
> On Tue, 2016-09-20 at 13:18 +0300, Leon Romanovsky wrote:
> > On Mon, Sep 19, 2016 at 11:12:36AM +0200, Knut Omang wrote:
> > >
> > > On Mon, 2016-09-19 at 08:29 +0300, Leon Romanovsky wrote:
> > > >
> > > > On Sat, Sep 17, 2016 at 05:59:13AM +0200, Knut Omang wrote:
> > > > >
> > > > >
> > > > > Also proper end align the ibv_kern_send_wr struct.
> > > > >
> > > > > Requires a corresponding kernel change.
> > > > >
> > > > > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > > ---
> > > > > =A0include/infiniband/kern-abi.h | 1 +
> > > > > =A0src/cmd.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0| 2 ++
> > > > > =A02 files changed, 3 insertions(+), 0 deletions(-)
> > > > >
> > > > > diff --git a/include/infiniband/kern-abi.h b/include/infiniband/k=
ern-abi.h
> > > > > index 8bdeef5..7b1d310 100644
> > > > > --- a/include/infiniband/kern-abi.h
> > > > > +++ b/include/infiniband/kern-abi.h
> > > > > @@ -800,6 +800,7 @@ struct ibv_kern_send_wr {
> > > > > =A0	union {
> > > > > =A0		struct {
> > > > > =A0			__u32 remote_srqn;
> > > > > +			__u32 reserved;
> > > > > =A0		} xrc;
> > > > > =A0	} qp_type;
> > > > > =A0};
> > > > > diff --git a/src/cmd.c b/src/cmd.c
> > > > > index a418ee1..a4e2f75 100644
> > > > > --- a/src/cmd.c
> > > > > +++ b/src/cmd.c
> > > > > @@ -1293,6 +1293,8 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, =
struct ibv_send_wr *wr,
> > > > > =A0			tmp->wr.ud.remote_qpn=A0=A0=3D i->wr.ud.remote_qpn;
> > > > > =A0			tmp->wr.ud.remote_qkey =3D i->wr.ud.remote_qkey;
> > > > > =A0		} else {
> > > > > +			if (ibqp->qp_type =3D=3D IBV_QPT_XRC_SEND)
> > > > > +				tmp->qp_type.xrc.remote_srqn =3D i->qp_type.xrc.remote_srqn;
> > > > It will be checked for all QPTs and for all consumers. Any chances =
to
> > > > optimize it?
> > > All QPTs except UD, yes.
> > >
> > > The easiest is perhaps just to remove the test (and set the attribute=
 in all cases), which will work fine
> > > as long as the qp_type union is not used for anything else, but is it=
 worth=A0
> > > the loss of intuitiveness/future potential correctness of the code?
> > Let's concentrate on the present and as far as I see there are no kerne=
l users who
> > need this field xrc.remote_srqn field.
>
> So I assume then that you are ok with this code, given my explanation?

Partially,

I'm fine with the claim about readability and the fact that
this code is not in data-path relaxed me a little bit.

I'm not fine with the part that this code doesn't do anything in kernel.

>
> Thanks,
> Knut
>
> > >
> > >
> > > Note that this is for user mode post_send implemented by the kernel, =
not the "fast path"
> > > pure user mode.
> > >
> > > Knut
> > >
> > > >
> > > > >
> > > > >
> > > > > =A0			switch (i->opcode) {
> > > > > =A0			case IBV_WR_RDMA_WRITE:
> > > > > =A0			case IBV_WR_RDMA_WRITE_WITH_IMM:
> > > > > --
> > > > > git-series 0.8.10
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-r=
dma" in
> > > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > More majordomo info at=A0=A0http://vger.kernel.org/majordomo-info=
=2Ehtml

--Do4IU1xF/9sod/r6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4Rb7AAoJEORje4g2clinyzgP/Asd3QZrK29kvyvdPLb/5LHT
UpeIcYLdLAB4SExoEnANvCGOv+ut1InNTVy//jswviSlO0mx8Bx7uUpYlmXjXvT0
TAvWi0eyb/dP1epHIECA1w6Lhk2U95SXRey6zL7IGYJmKjVwjYqoiojIMFfdQXhi
twRN6j8i/Yjwbd44ecIVd8neMZaIERXZncSbggFYn0S3sm0YzmbHoly4V3uas8jq
IA83qCzpYzWhP+0l8JNuhO4RDWnl9ZMIJtUCmdf6G2YX+u2QJD8J/JjtVgtnz8lD
BjP7xDquv8mOqOGXI1XxmPrSDbNIveNB0PZaB26/QCQS8FFB880pleBBZkib29Oc
SpTdEBfGLG4gdO38AbbkwsHKB0kHkTcr3SUH77o9Jrb43k2eTKccbrIZ2cKeKmuI
TzwGEj5ZpbN0EjPGCJBOKwd2pnKSdgDy8c6K2UXPVWO2yrzGns4r0SqeFgicyKln
6pRNtAomSo6cvHlZW/FylB44e4fgS7M9MT6NnmsmlpqmLlvbwDgMeCAn9FLvdH5c
lY9zgLz2dy8cseDI28g4zJRb8qUhpDMVuoIhTSlqaK11e88YIN16n9dvlWxek2+4
6ztB4hXjJa/3yjwVnFkzSZtAXpXJFJwJ0L+Ki7hHDn8E42AOw5hBaEMR0ogbm0Om
9cnW7ozwclqfaTTvNJJ1
=Mfi3
-----END PGP SIGNATURE-----

--Do4IU1xF/9sod/r6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
