From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] mlx5: Use NULL instead of 0 to represent a pointer
Date: Wed, 7 Dec 2016 10:21:10 +0200
Message-ID: <20161207082110.GA11857@mtr-leonro.local>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <16dc2a07-86f7-ce47-7b0c-1da03e58d99f@sandisk.com>
 <20161206135917.GC2437@mtr-leonro.local>
 <a8d3dbb7-aafa-c5af-5d06-78d1f4914c5d@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a8d3dbb7-aafa-c5af-5d06-78d1f4914c5d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2016 at 08:29:56AM -0800, Bart Van Assche wrote:
> On 12/06/2016 05:59 AM, Leon Romanovsky wrote:
> > On Mon, Dec 05, 2016 at 05:18:08PM -0800, Bart Van Assche wrote:
> > > Detected by sparse.
> > >=20
> > > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/mlx5/main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/h=
w/mlx5/main.c
> > > index 32b09f059c84..abd200e3e299 100644
> > > --- a/drivers/infiniband/hw/mlx5/main.c
> > > +++ b/drivers/infiniband/hw/mlx5/main.c
> > > @@ -127,7 +127,7 @@ static int mlx5_netdev_event(struct notifier_bloc=
k *this,
> > >=20
> > >  		if ((upper =3D=3D ndev || (!upper && ndev =3D=3D ibdev->roce.netde=
v))
> > >  		    && ibdev->ib_active) {
> > > -			struct ib_event ibev =3D {0};
> > > +			struct ib_event ibev =3D { NULL };
> >=20
> > I afraid that it is sparse anomality and because NULL=3D=3D0, the ibev.=
event
> > will be initialized to zero, but it is a matter of time when the sparse
> > will complain about wrong initialization again.
>=20
> Hello Leon,
>=20
> The first member of struct ib_event is a pointer so I think the sparse
> complaint is correct.=20

Yes, sparse didn't iterate all fields of this struct. This is why I
called it "sparse anomality".

> Anyway, how about one of the following two
> alternatives:
> * Change {0} into { }.

Yes, please.
Thanks

> * Use memset() instead of an initializer.
>=20
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhHxmQACgkQ5GN7iDZy
WKf4CQ//cH8W7gKSgjnsajziFpAgT1D5H0ykdFByibBQ4brslLyVvbrK3osI2opy
TF3tZMmVTE0m/dNPlYyrShtFTlgLz4iwpFW2Sz+4pc33+YPeXB8VUcTEGVH9kL90
DyWDFBvosFQCr9BW//S82NrrlS1mdaNjutfJE2K+hpTFCpeBcLgFN3EqfNweKACV
Al4jrF95qGWPO+YK0KC23bJl5iBPaj+Tj1j5qvTLWdxvUlmlOFnhr4B/YupCSCh0
Wnfej/cP5MvUCQHZCE9Vm3lLEVs4gvWcao2FtM9r8MN0lNXheAM3fxEPX/TUlxHM
ZooIH/5bY3cYKUbDrxyc7R+xJRP7xaOOc8eQVSTTcjAQKotDcfcJ5yGEYaXHS4xO
8sxrlzxAPhranvX3zcg3hsadIZJJJpPKHkZqJJS32CpK9gCLVmVGPyNMlth7Jqrp
rKfFm/A5GSV57kxzaCigLC6CfPN1FE8TMzofrKaOa/WX60ueQNDyZ7HbRgg9dkch
XFO7cMACxlY1OUEv0A6Qdc+eviey7DIlkE/QBailY2clygpa7vRlQajCr+QDVMNk
jqEX1Tlo3585UBHGG/CkNeFJCq4XxRQnzh31qUNvFiWf7471wnCcfYgehrOtiQng
+eZvl339ix1jpbr3uxWmxaEc9gWUYOg0YZg5oKUz5lzFLfLfysc=
=bKox
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
