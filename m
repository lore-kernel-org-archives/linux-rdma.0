From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH, RFC] mlx4_ib: Make steering support independent of
 MLX4_BMME_FLAG_TYPE_2_WIN
Date: Fri, 3 Jun 2016 16:10:13 +0300
Message-ID: <20160603131013.GM7477@leon.nu>
References: <2a929a48-559e-41ad-c42e-a722801c11d0@sandisk.com>
 <20160602081819.GJ7477@leon.nu>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BHMq0+oGliEfCAkH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602081819.GJ7477-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BHMq0+oGliEfCAkH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2016 at 11:18:19AM +0300, Leon Romanovsky wrote:
> On Wed, Jun 01, 2016 at 05:07:17PM -0700, Bart Van Assche wrote:
> > Hello,
> >=20
> > Can anyone who is familiar with the mlx4 driver tell me whether or not
> > the patch below makes sense? I ran into this code by analyzing the mlx4
> > source code with smatch.
>=20
> Hi Bart,
> Thank you bringing it to our attention. I had a fast chit-chat with
> Matan who was the last person who touched that area. It looks like an
> unharmful issue with the code, because we had support for memory window
> feature literally forever.

hi Bart,
Do you want us to handle this fix (improve title, fill commit message)?
Or maybe you prefer to submit it by yourself?

Thanks.

>=20
> Thanks.
>=20
> >=20
> > Thanks,
> >=20
> > Bart.
> >=20
> > ---
> >  drivers/infiniband/hw/mlx4/main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
> > index b01ef6e..db7d0bc 100644
> > --- a/drivers/infiniband/hw/mlx4/main.c
> > +++ b/drivers/infiniband/hw/mlx4/main.c
> > @@ -505,9 +505,9 @@ static int mlx4_ib_query_device(struct ib_device *i=
bdev,
> >  			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2B;
> >  		else
> >  			props->device_cap_flags |=3D IB_DEVICE_MEM_WINDOW_TYPE_2A;
> > +	}
> >  	if (dev->steering_support =3D=3D  MLX4_STEERING_MODE_DEVICE_MANAGED)
> >  		props->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STEERING;
> > -	}
> > =20
> >  	props->device_cap_flags |=3D IB_DEVICE_RAW_IP_CSUM;
> > =20
> > --=20
> > 2.8.3
> >=20



--BHMq0+oGliEfCAkH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXUYG1AAoJEORje4g2clinYTYP/R+bUuo377BR2DHMPqb2poOA
83kOtCS8yBn7Kh9WbY+0/FW5zk4jYBiasp/izV7TI1kIJn28NmwPqxpKF2nY2RFX
cvYk5CkR7Ytyfuac0/kZj/fLvxr6joioaOQYJTAdF5dfM7JWPELjPLLg2dZ+8+T7
xHAJRC3gdMjuF2dHAzYSqNyn//qGDyxYwdgpZDgdUsxhUhm4mdGh9cikPru5fQiV
JRDk4EFMoVl4m08sV5kw9cdGJZavu4N40tBu3fzbFwhOdaPNdyRAjfQuOK9n80gt
s3mfBllRJPtGxL3OFNHFUqSN1VMGap1J6GoAqEFRU7mYeGmIba6TzKt+woR0ZObI
H5E72hG5np8qU//Q6FUP9HMbeSXYpxaY8PGPvxYM5sZmM3ikbUV2G6WqrwBQhMuK
roe4DULF4E/z1lcm5xTtpxRHZuhR+eONSvHJXCYXwL0coZENG34H82zKclptIxVQ
noLlS9TUSl8Y6lgsYM8RT5+0t6R3Ea0oyTAR8FDq6eVZlPDvWNrm29aAkfZjalkP
+iiDqK5C73+ZQOmOSmAILy3CPZeRFb9S8YFHrdGkJW7I9JXqR3MxBHAbodfmNBXk
vMuLvTM0dpDOy+HNNbn1N/z2OuqRgl3f4CmBNU/Mj4+8soXftO0tXn/IQpOCc/4G
qYZ+2fbbrKdEOMlqGapJ
=nco1
-----END PGP SIGNATURE-----

--BHMq0+oGliEfCAkH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
