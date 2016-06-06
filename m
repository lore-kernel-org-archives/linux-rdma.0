From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 2/2] IB/sysfs: fix memory leak
Date: Mon, 6 Jun 2016 15:17:47 +0300
Message-ID: <20160606121747.GA3663@leon.nu>
References: <1465157636-10120-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1465157636-10120-2-git-send-email-sudipm.mukherjee@gmail.com>
 <20160606063454.GP7477@leon.nu>
Reply-To: leon@kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160606063454.GP7477@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2016 at 09:34:54AM +0300, Leon Romanovsky wrote:
> On Sun, Jun 05, 2016 at 09:13:56PM +0100, Sudip Mukherjee wrote:
> > If the allocation of hsag fails we were just returning but stats was
> > not released.
> >=20
> > Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

It looks the same as Colin's patch which was sent a week ago.
http://marc.info/?l=3Dlinux-kernel&m=3D146480441931189&w=3D2

>=20
> > ---
> >  drivers/infiniband/core/sysfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/=
sysfs.c
> > index fcf6f9c..8d8732c 100644
> > --- a/drivers/infiniband/core/sysfs.c
> > +++ b/drivers/infiniband/core/sysfs.c
> > @@ -906,7 +906,7 @@ static void setup_hw_stats(struct ib_device *device=
, struct ib_port *port,
> >  		       sizeof(void *) * (stats->num_counters + 1),
> >  		       GFP_KERNEL);
> >  	if (!hsag)
> > -		return;
> > +		goto err;
> > =20
> >  	ret =3D device->get_hw_stats(device, stats, port_num,
> >  				   stats->num_counters);
> > --=20
> > 1.9.1
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVWnrAAoJEORje4g2clinDu0P/0V4zCce/FVK3JS34stnySNZ
JmeVR3mJOXkKo1BfKuSNiFo0Mc2oQHmSkDo1ALYdzy5z2dFpCF5E0mRg4SlG89fT
FKXd1pgEF9gRrqo3ArmlRSF7jUcVWCJNU970/MS2UoFF5NBkGZPYibmLMdgqPThB
dzhpcD4Fz86U1UtbzolMv4bCQCuZZXiV5p3LS3NpUfX+XhUTLZpdg5CP0n4Yh4xn
rzsTriUrHfbiyDtfJo+HWR0MIoAUO8WE3Pkl77w4wfvaFsv24Cdees+eYeS/bvGD
NPUPuSm968jRWmQAtKmd5zEAYh213UgwxZJJnqOR61QVbwQEP9fVHcGA0JLyuOIB
R1b5Mx/P2i/4DYWGD3ADMBFLdxtH9jD6bhg++3dgYShoR+vL7+MOD71aKkDjRN0g
GCQU9txYNs3yvWxGDksnwW5yxknKCCez4UkZTy3lMSfktPs2fwrpDQpIwi82dr/j
QVYAtGb0F5pFXW0biBctq9eEbc7LTx/si199lJAxGghh9tmaeKGW/BIzm/kqvI30
d5ansMOKkpJC5HKutzuBrt4wEu7xz2l6EcuoYvtoPEDRunxAMDbB4/gkYNpdQGvV
CL/lrmAimoOB6mB1d+f4FGUhqQYlqGOgwimPfggLZexybbxkb3kmlQewQhz5VDHL
5bkRCJjBHOFo4bX6Urq9
=Zg1m
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
