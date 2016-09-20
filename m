From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 3/3] Provide remote XRC SRQ number in
 kernel post_send.
Date: Tue, 20 Sep 2016 15:17:41 +0300
Message-ID: <20160920121741.GL26673@leon.nu>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
 <d57e9dc45f6f4aed9dfb86a498226dab99e530a4.1474063039.git-series.knut.omang@oracle.com>
 <20160919052911.GF3273@leon.nu>
 <1474276356.24045.93.camel@oracle.com>
 <20160920101839.GF26673@leon.nu>
 <1474368210.8837.3.camel@oracle.com>
 <20160920110115.GJ26673@leon.nu>
 <1474369715.8837.19.camel@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/jkxxxtAhYIHVDuh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474369715.8837.19.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/jkxxxtAhYIHVDuh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2016 at 01:08:35PM +0200, Knut Omang wrote:
> On Tue, 2016-09-20 at 14:01 +0300, Leon Romanovsky wrote:
> > On Tue, Sep 20, 2016 at 12:43:30PM +0200, Knut Omang wrote:
> > >
> > > On Tue, 2016-09-20 at 13:18 +0300, Leon Romanovsky wrote:
> > > >
> > > > On Mon, Sep 19, 2016 at 11:12:36AM +0200, Knut Omang wrote:
> > > > >
> > > > >
> > > > > On Mon, 2016-09-19 at 08:29 +0300, Leon Romanovsky wrote:
> > > > > >
> > > > > >
> > > > > > On Sat, Sep 17, 2016 at 05:59:13AM +0200, Knut Omang wrote:
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > Also proper end align the ibv_kern_send_wr struct.
> > > > > > >
> > > > > > > Requires a corresponding kernel change.
> > > > > > >
> > > > > > > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > > > > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > > > > ---
> > > > > > > =A0include/infiniband/kern-abi.h | 1 +
> > > > > > > =A0src/cmd.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0| 2 ++
> > > > > > > =A02 files changed, 3 insertions(+), 0 deletions(-)
> > > > > > >
> > > > > > > diff --git a/include/infiniband/kern-abi.h b/include/infiniba=
nd/kern-abi.h
> > > > > > > index 8bdeef5..7b1d310 100644
> > > > > > > --- a/include/infiniband/kern-abi.h
> > > > > > > +++ b/include/infiniband/kern-abi.h
> > > > > > > @@ -800,6 +800,7 @@ struct ibv_kern_send_wr {
> > > > > > > =A0	union {
> > > > > > > =A0		struct {
> > > > > > > =A0			__u32 remote_srqn;
> > > > > > > +			__u32 reserved;
> > > > > > > =A0		} xrc;
> > > > > > > =A0	} qp_type;
> > > > > > > =A0};
> > > > > > > diff --git a/src/cmd.c b/src/cmd.c
> > > > > > > index a418ee1..a4e2f75 100644
> > > > > > > --- a/src/cmd.c
> > > > > > > +++ b/src/cmd.c
> > > > > > > @@ -1293,6 +1293,8 @@ int ibv_cmd_post_send(struct ibv_qp *ib=
qp, struct ibv_send_wr *wr,
> > > > > > > =A0			tmp->wr.ud.remote_qpn=A0=A0=3D i->wr.ud.remote_qpn;
> > > > > > > =A0			tmp->wr.ud.remote_qkey =3D i->wr.ud.remote_qkey;
> > > > > > > =A0		} else {
> > > > > > > +			if (ibqp->qp_type =3D=3D IBV_QPT_XRC_SEND)
> > > > > > > +				tmp->qp_type.xrc.remote_srqn =3D i->qp_type.xrc.remote_s=
rqn;
> > > > > > It will be checked for all QPTs and for all consumers. Any chan=
ces to
> > > > > > optimize it?
> > > > > All QPTs except UD, yes.
> > > > >
> > > > > The easiest is perhaps just to remove the test (and set the attri=
bute in all cases), which will work fine
> > > > > as long as the qp_type union is not used for anything else, but i=
s it worth=A0
> > > > > the loss of intuitiveness/future potential correctness of the cod=
e?
> > > > Let's concentrate on the present and as far as I see there are no k=
ernel users who
> > > > need this field xrc.remote_srqn field.
> > > So I assume then that you are ok with this code, given my explanation?
> > Partially,
> >
> > I'm fine with the claim about readability and the fact that
> > this code is not in data-path relaxed me a little bit.
>
> Good!
>
> > I'm not fine with the part that this code doesn't do anything in kernel.
>
> I know, I have two big patch sets one kernel and one for the new "rdma co=
nsolidated"=A0
> in the queue that should fix that, just want to save a few versions of th=
ose=A0
> ~32000 lines of code by preparing the baseline :-)

It won't save. We DO believe you that this this new addition to UAPI is rea=
lly
needed, but we NEED to see that it is unavoidable.

The proper flow for submission is driver->kernel_core->libraries and not
kernel_core->libraries->driver.

Thanks

--/jkxxxtAhYIHVDuh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4SjlAAoJEORje4g2clinaHUQAJQ4W3FBCIsw8rVbFHtuJbwA
aEwVbKNBrZz3NcgjtesJR64Gfq0RS8GWIrpwhJH3eVId5wdP9mASSq7+6AK1wdvL
VV5NSUoP+qJ+cP7/N4HimXkPJL0ZKFyTl/AtKuc5GzpkwwsI4GQ48sfJPtT05X9p
ZeYlkbB/pXHkg5HS6kEph+r+ipGjciVRmxXQWzFocMLlpo/E0rKQcxZdChl9ROq9
DB6mXd0FXYjLMn0IyaIu5QptpUNBOVffZ3Kik/QZjtI+9UZwuyw7wMVcIPfAAwlG
aguPLqEZT+rsqwJ6EldmVXC8H1D/6GE0uiBaNCy4vqOFUqHUPg5OyNY4EDnxs5m5
0fu8gL7Y61k5XXyyhT4DZjiTIGamxS5rsh+zxzE1c46rflKj6/2D7cwVFPbNMvd9
Obv7fvaXmi0sp+A9ooDce0OcnXutMDnyOX18OM5wFHDkfERwh0ZayyAP9r1JA0ir
9lJRJ53z7jChHONmVIk7d5Tn0Rcs5D6lumXkMCJ01mmBbNPjasokxkhNsPUi/UEK
926CAjMKZjFvkTa7HGK7XbaA7yo0t8BtV2bfCl/O8/uTIT1Sj3FAutfwsrrRWA28
pgvcGqifNBGLJpUiheTS0QSq3qXUDRN28PO5kvossOfcs8/PWmd4dhXcI693c7Jh
7XHkl765AcxDzknGR+9G
=2hHj
-----END PGP SIGNATURE-----

--/jkxxxtAhYIHVDuh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
