From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Convert UMR CQ to new CQ API
Date: Fri, 4 Mar 2016 11:56:58 -0500
Message-ID: <56D9BE5A.8040305@redhat.com>
References: <1456565984-28998-1-git-send-email-hch@lst.de>
 <1456565984-28998-2-git-send-email-hch@lst.de>
 <56D2D731.5060904@dev.mellanox.co.il> <56D3F1EA.9090800@mellanox.com>
 <20160303083822.GB13828@lst.de> <56D7FE93.9020503@dev.mellanox.co.il>
 <56D865AF.5000507@redhat.com> <20160304165426.GA29122@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rasobBVksxEwBqH67E7WSpFoBuL9PgDnx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160304165426.GA29122-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rasobBVksxEwBqH67E7WSpFoBuL9PgDnx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/04/2016 11:54 AM, Christoph Hellwig wrote:
> On Thu, Mar 03, 2016 at 11:26:23AM -0500, Doug Ledford wrote:
>> I took the later version of the patch, but I had to fix it up due to
>> conflicts with both the rereg_me patchset and the mmkey cleanup
>> patchset.  Please double check this in the mlx5 branch of my github re=
po
>> to make sure it's all good.
>=20
> Looks like we'll need the one liner below to get the manually applied p=
atch
> to compile, but otherwise it looks fine to me.
>=20
>=20
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/ml=
x5/mr.c
> index f1464b8..4d5bff1 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1201,7 +1201,7 @@ static int unreg_umr(struct mlx5_ib_dev *dev, str=
uct mlx5_ib_mr *mr)
> =20
>  	mlx5_ib_init_umr_context(&umr_context);
> =20
> -	umrwr.wr.wr_cqe =3D &umr_context.cqe
> +	umrwr.wr.wr_cqe =3D &umr_context.cqe;
>  	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmkey.key);
> =20
>  	down(&umrc->sem);
>=20

Missing a ;, fun times! ;-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rasobBVksxEwBqH67E7WSpFoBuL9PgDnx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2b5aAAoJELgmozMOVy/dPnEP/jrN32OcFL4C5uK32oK0z8+j
FLBcy7sa4R8aZYvzEjAbbmgCKWDLG7lumR7RyTTf63k+0gDJC78AMqbAVNeeJc/9
YRf8n2XnOZg7FfwoHbOZHR2u6+DO6QpxIwGsa0gOfoJ+TeKHue0XYAS2WvkHL9O+
Evndna4wY6Mf2hiKa772AgCMtyJ9cjug+NusXNzDkkIPVgYfmTibw/XQvygNjqks
ZAGXbaVJkO9L85zi2e3crgVHq9fhSRDISrQhNlWJTh3MIsQ3E96oMgp1m4wGboaI
u4EcLV0AWDsns10000SNrMNEFI3madOXSNkXK/4No2StJhupxc/sfi4nD7AWC9ze
tjf1jdZe+Fd1pKlhqXsY49YzsKE8YMaNq4zqCmj4agkn3tgCo2wS8PGWtC7R4jBt
cX1B5asZD21wFeIpRim1RCvuGKNIrKa72q6VthvBvqVWEo9QN89irDGxK/0OS/gl
yrg995jnE1uWdPoJH2IymnR+EONXNaMRyTgVb9bTJx6HTcFFT+A/DuFaZ6MQCi+3
mG1PNu2vsy6WTUJvYwQfuFmDWkDJzc6TPqGYfmDjo14bvuqY+57ANJaYnPla99D9
ebYO8kms0RrVWqaiXuzAreT0661aNgZgYptIgCA8Oio7Kqi+V4UhxTunlP0YyNFG
TzMDPvGxb6pwgdFTqKJt
=kAfd
-----END PGP SIGNATURE-----

--rasobBVksxEwBqH67E7WSpFoBuL9PgDnx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
