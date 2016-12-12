From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Mon, 12 Dec 2016 14:52:05 +0200
Message-ID: <20161212125205.GB6503@mtr-leonro.local>
References: <20161209092044.GA4640@elgon.mountain>
 <20161211092326.GA4479@mtr-leonro.local>
 <20161212090910.GS8244@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161212090910.GS8244@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 12, 2016 at 12:33:55PM +0300, Dan Carpenter wrote:
> On Sun, Dec 11, 2016 at 11:23:26AM +0200, Leon Romanovsky wrote:
> > >   3624          case IB_SIG_TYPE_T10_DIF:
> > >   3625                  psv_seg->transient_sig = cpu_to_be32(domain->sig.dif.bg << 16 |
> > >   3626                                                       domain->sig.dif.app_tag);
> > >   3627                  psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
> > >   3628                  break;
> > >   3629          default:
> > >   3630                  pr_err("Bad signature type given.\n");
> > >   3631                  return 1;
> > >
> > > Why do we return 1 here instead of a negative error code?
> >
> > Yes, probably better to return something like EINVAL, instead of 1.
> > do you want us to handle it?
> >
>
> Yes, please.

Thanks,
We will send it as part of our fixes series for 4.10.

>
> regards,
> dan carpenter
>

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhOnXUACgkQ5GN7iDZy
WKeKrRAAj8E2NrWtDgCbBWuMdHX8ojaOC6kBpHsTiXd2yzuC6VOpNK2FqzBW3CsE
JngB4QX7tpRT1DF7Uk3ZRKdlbpcFJfDkaUQu8MvF/1uv/VKriMop/MnVLJvvgi9H
1wpFwIyYGANMXP9P2jDBr5vtTBJ+f0LSA86uxTq6j4faexwyIGTdzBetkT6g1ktb
hTBNZJLjdNnbjjceiHD25uwG4vK5nzjpuwD1mBLSgUGHUzRP1fiecCGIDqhFh+aP
howRbALS6ycfQ72RR60iu3woNuqszl5zR5oZY8QNrRwDT8mZNnCYekBNLd4DEjXZ
VSo3PK7oWFJxKLd1Q+744BN8DTMaa5qPDViVO+adqeBQbLSnCZKuGvf/XG6+FCkC
GgSh8qIDGTSMAHpdVAfm5lTeQIqqlSilsZ1GNuxikv28/36ffnzqf5T6eW5dEEaS
RWzOesixRPD1ncS7hP5yF7L79OFO4+qxnzL/csi/ryvesuf7ADZZYi/fsMEoFKHK
BEvsF/GAthHe5DqAQ+pHT8IObByWRcnxJPQbUlxhZeXnIA23WWDZDo5xzqn5nXsf
N4wY2JpUIzpMA0eTlS8IQu2svtGpH0qI+xfgCej1n80K1khtf1pgU3xTOMJHJwbT
RNgYc/vFwZ0HMFrqahWNHitbLJeXA658h/xVcqQALs8+zyHA2fU=
=hb38
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
