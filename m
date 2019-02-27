From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next] rdma: Add the prefix for driver attributes
Date: Wed, 27 Feb 2019 13:38:07 +0200
Message-ID: <20190227113807.GC15253@mtr-leonro.mtl.com>
References: <20190227064151.25445-1-leon@kernel.org>
 <d6d1bd56-5def-aa25-4845-e41d2ea5d667@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d6d1bd56-5def-aa25-4845-e41d2ea5d667@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: oulijun <oulijun@huawei.com>
Cc: David Ahern <dsahern@gmail.com>, Steve Wise <swise@opengridcomputing.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 27, 2019 at 07:30:34PM +0800, oulijun wrote:
> =E5=9C=A8 2019/2/27 14:41, Leon Romanovsky =E5=86=99=E9=81=93:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > There is a need to distinguish between driver vs. general exposed
> > attributes. The most common use case is to expose some internal
> > garbage under extremely common and sexy name, e.g. pi, ci e.t.c
> >
> > In order to achieve that, we will add "drv_" prefix to all strings
> > which were received through RDMA_NLDEV_ATTR_DRIVER_* attributes.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>a
> > ---
> >  rdma/utils.c | 34 ++++++++++++++++++++++------------
> >  1 file changed, 22 insertions(+), 12 deletions(-)
> >
> > diff --git a/rdma/utils.c b/rdma/utils.c
> > index 6bc14cd5..1f6bf330 100644
> > --- a/rdma/utils.c
> > +++ b/rdma/utils.c
> > @@ -829,27 +829,37 @@ static int print_driver_entry(struct rd *rd, stru=
ct nlattr *key_attr,
> >  				struct nlattr *val_attr,
> >  				enum rdma_nldev_print_type print_type)
> >  {
> > -	const char *key_str =3D mnl_attr_get_str(key_attr);
> >  	int attr_type =3D nla_type(val_attr);
> > +	int ret =3D -EINVAL;
> > +	char *key_str;
> > +
> > +	if (asprintf(&key_str, "drv_%s", mnl_attr_get_str(key_attr)) =3D=3D -=
1)
> > +		return -ENOMEM;
> >
> >  	switch (attr_type) {
> >  	case RDMA_NLDEV_ATTR_DRIVER_STRING:
> > -		return print_driver_string(rd, key_str,
> > -				mnl_attr_get_str(val_attr));
> > +		ret =3D print_driver_string(rd, key_str,
> > +					  mnl_attr_get_str(val_attr));
> > +		break;
> >  	case RDMA_NLDEV_ATTR_DRIVER_S32:
> > -		return print_driver_s32(rd, key_str,
> > -				mnl_attr_get_u32(val_attr), print_type);
> > +		ret =3D print_driver_s32(rd, key_str, mnl_attr_get_u32(val_attr),
> > +				       print_type);
> > +		break;
> >  	case RDMA_NLDEV_ATTR_DRIVER_U32:
> > -		return print_driver_u32(rd, key_str,
> > -				mnl_attr_get_u32(val_attr), print_type);
> > +		ret =3D print_driver_u32(rd, key_str, mnl_attr_get_u32(val_attr),
> > +				       print_type);
> > +		break;
> >  	case RDMA_NLDEV_ATTR_DRIVER_S64:
> > -		return print_driver_s64(rd, key_str,
> > -				mnl_attr_get_u64(val_attr), print_type);
> > +		ret =3D print_driver_s64(rd, key_str, mnl_attr_get_u64(val_attr),
> > +				       print_type);
> > +		break;
> >  	case RDMA_NLDEV_ATTR_DRIVER_U64:
> > -		return print_driver_u64(rd, key_str,
> > -				mnl_attr_get_u64(val_attr), print_type);
> > +		ret =3D print_driver_u64(rd, key_str, mnl_attr_get_u64(val_attr),
> > +				       print_type);
> > +		break;
> >  	}
> > -	return -EINVAL;
> > +	free(key_str);
> > +	return ret;
> >  }
> >
> >  void print_driver_table(struct rd *rd, struct nlattr *tb)
> > --
> > 2.19.1
> >
> >
> > .
> >
> This is fine to me  and the implementation is more simple.
>
> Tested-by: Lijun Ou <oulijun@huawei.com>

Thanks a lot.

>
> thanks.
>

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcdnafAAoJEORje4g2clinI6cQAMlj5B6UA9lKwZ83jjt/AelN
D+xTO0lmXiIV3HWbz0dguKL/7fj/GpTh+YfD+rYqJ3VmhU56BL3tUXqthXmQREkB
wv/lhjJeLpqb/a75VDdmeE99S0YQkK1tDJFYvfNRsAaK3sVW/i5kjNHbwcTfDkGu
pYoPWWmclwSGZnNsHjwa2LzZ1d32TgtYYoXbxS1Maqq1RW9uxKejSp0icHqVM3Cn
vOUFlBWoGSvQcMbOMuClM+9g6O8DOhiCyIaCZPS2nIJFN/Z2iOBMHI2M0goN8plB
b7Z8i5q9cwk0hvN9RTxNIVN1MQkpdeIXmTb81BmP+AuHRWsLZ+No3MepDUrq0zeM
YFITD7AeAbIwgl61kfUBeEuSK3Tdbu39bXzz+JYs9nfaougWyWhbdnEzJCtzKCHj
uS6Z4ICFvrckNybBs4GA7jrlW5hbJ5K5/rVu3i6qk3C8rLM1XWR2AyEPbX5vrwIa
cfWU2dTfwK67AzcQ/GJGKkG8oEAZEreXEaezPDQozq3N62eSt0p35O6BOfdbrq3g
PBWJVoTrus1XYDo/uqt1y48u9NM1yLqu1+rJ/1nCqD434yc8bVkpke/0KL01FP7C
NiNB0glc/wZCkbxX60rwaN+L+tc/Zx/wtOzKvZ3jAnjJhS0KTaySRQz3z/TkxkLt
NTuP5aTxGEg5ivCzn71i
=pbwK
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
