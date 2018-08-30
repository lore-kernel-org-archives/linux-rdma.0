From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 1/2] IB/ipoib: Use dev_port to expose network
 interface port numbers
Date: Thu, 30 Aug 2018 16:17:58 -0400
Message-ID: <075a5d0f9fb9dfc868e82073f930a98bea15e578.camel@redhat.com>
References: <20180830182238.16361-1-ar@cs.msu.ru>
         <20180830182238.16361-2-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cj4tm8z1OSt0q3hIoAeB"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180830182238.16361-2-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>, linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-cj4tm8z1OSt0q3hIoAeB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-08-30 at 21:22 +0300, Arseny Maslennikov wrote:
> Some InfiniBand network devices have multiple ports on the same PCI
> function. This initializes the `dev_port' sysfs field of those
> network interfaces with their port number.
>=20
> Prior to this the kernel erroneously used the `dev_id' sysfs
> field of those network interfaces to convey the port number to userspace.
>=20
> The use of `dev_id' was considered correct until Linux 3.15,
> when another field, `dev_port', was defined for this particular
> purpose and `dev_id' was reserved for distinguishing stacked ifaces
> (e.g: VLANs) with the same hardware address as their parent device.
>=20
> Similar fixes to net/mlx4_en and many other drivers, which started
> exporting this information through `dev_id' before 3.15, were accepted
> into the kernel 4 years ago.
> See 76a066f2a2a0 (`net/mlx4_en: Expose port number through sysfs').
>=20
> Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_main.c
> index e3d28f9ad9c0..ba16a63ee303 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1880,7 +1880,7 @@ static int ipoib_parent_init(struct net_device *nde=
v)
>  	       sizeof(union ib_gid));
> =20
>  	SET_NETDEV_DEV(priv->dev, priv->ca->dev.parent);
> -	priv->dev->dev_id =3D priv->port - 1;
> +	priv->dev->dev_port =3D priv->port - 1;

I don't know that we can't do this.  At least not yet.  Expose the new
item to make us compliant with the new docs, and deprecate the old sysfs
item, but we can't just yank the old item.  Existing tools/scripts might
(probably) rely on it (existing tools already special case IPoIB
interfaces and we'll need to make sure they don't special case this
element too).

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-cj4tm8z1OSt0q3hIoAeB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluIUPYACgkQuCajMw5X
L92hzRAArz/8Wr56LWIcnwVhNGFO+LH97Kbwz13U2/weU0k4M8FE/r8XuSrK88tD
fmrwsJZXW84WoysGuDLKXzgUbq+xW2ylMjQauuywKmfqUD4saahuiWV6u++Xt7ck
sm8XQFzMjx46z1aiDeIvIYVWdVEo3cLHXt+ixuI7eh8WfQM+bFU/IAl/WpJOuhmC
y3+bkYmwzyhKwypGgnj6em1Wg3VI4F4REW5lGNa7x/NSUAZlQNuvGqA9YvTABwM5
OLmtsKFCw7QdRlsMxXWCl888mtEoL690V9PsJKinuqjg4Q97ZOrBggni/eXWqZ0Z
ojWl+jwLDvh5OKnaCHKO3VHaRKJS3hn997w1WQ+Owm0g8m5o79uPY9fDX9eSN/o6
EJBmSwhYXcALmpvph17mmzQHaaRSumnKpcg74CTsZt+Cxxojw5Jmp6PhhQ7mgHn/
bbdHvY5WVja8sfGAjbevGyydhLVFIFzlGETrcupZsv47laxDr+2VJ5JRs6pgfQDP
SmxKW7nNsyyUHmPNlnhtVD+ewHWRoZzYRSTPaAGuqWG+Jaijjt7JmasiBbQkDJu2
OMSn4A2sJ/GQKXANlu/k4XdXrK7W0JF//YLIwxcEFD82j/Xv4aFZRQfnqF8mA3wo
5CSEPcdQ2nZT0WJhZ4rHS++YEwrlSOPH5tKyYkY7pBryg/60h24=
=8+ab
-----END PGP SIGNATURE-----

--=-cj4tm8z1OSt0q3hIoAeB--
