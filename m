From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/4] mlx5 vport loopback
Date: Fri, 21 Sep 2018 22:33:35 +0300
Message-ID: <20180921193335.GV3519@mtr-leonro.mtl.com>
References: <20180917103049.18235-1-leon@kernel.org>
 <4d9969b9424642dc4c50ca698c57c41654f7006a.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oiL9LJXJsdjS5rzq"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4d9969b9424642dc4c50ca698c57c41654f7006a.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--oiL9LJXJsdjS5rzq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 21, 2018 at 03:14:36PM -0400, Doug Ledford wrote:
> On Mon, 2018-09-17 at 13:30 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This is short series from Mark which extends handling of loopback
> > traffic. Originally mlx5 IB dynamically enabled/disabled both unicast
> > and multicast based on number of users. However RAW ethernet QPs need
> > more granular access.
> >
> > Thanks
> >
> > Mark Bloch (4):
> >   net/mlx5: Rename incorrect naming in IFC file
> >   RDMA/mlx5: Refactor transport domain bookkeeping logic
> >   RDMA/mlx5: Allow creating RAW ethernet QP with loopback support
> >   RDMA/mlx5: Enable vport loopback when user context or QP mandate
>
> I've reviewed this series and I'm OK with it, but the first patch is for
> net/mlx5.  How are you expecting the series to be applied?  Are you
> wanting me or Jason to take the entire series, or does the first patch
> need to go through the mlx5 tree and get picked up by Dave and us, and
> then we take the rest?  This is unclear to me...

Thanks Doug,

The preferable flow for such patches is that I or Saeed will apply
net/mlx5 patch (mlx5-next) on top of our shared branch after you or Jason
or Dave ack on whole series.

The shared branch is located in:
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next
As you can see, it is clear branch of our shared commits and it is based
on -rc1 to be sure no pollution of both subsystems will be done.

It ensures that netdev won't get RDMA patches and vice versa.

For RDMA, once we apply such mlx5-next patch, Jason usually merges of
this branch into his rdma-next and applies on top of it extra non
mlx5-next patches.
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=for-next&id=af68ccbc1131ddd8dcda65b015cd9919b352485a

For netdev, it is a little bit different, because Saeed works with pull
requests and he creates merge commit before sending his pull request.

This model allows us to ensure that changes are pulled only when it is
really needed and there is a chance that Dave won't ever pull this
mlx5-next branch in this cycle because Saeed won't have any patches
depend on it.

Hope it makes it clear now.

Are you ok with me/Saeed taking first patch to our branch so you will be
able to take the rest?

Thanks

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--oiL9LJXJsdjS5rzq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbpUePAAoJEORje4g2clinD6EP/0zcin/thi2bG2vSNH5pYmU8
snl2yb3nCHvXXDJB7uBWHZXEocI4lzRz6sqGPMylNamxegPYfeaRAFfkPWyWoq8H
cGPB2QlgV28k/DPsSuu08nBauK5Mx5TTGF9yGZUaoBkr+akTpbKfYbR3lYFZr0F2
O2PVldf/pB0YDa2451DMQOBHd3uxc6XZzZJBJlNwrJ2P+JDkJhlmsfsA7KpBJ9No
7LBp6WU4FmAg5+YcR1wvo4ztokWLeX+V9wfLcLZM85Jz4VfbjK5FoMXcpE5NZUhX
JujvCJ7MTH1fPrK/f4rZa8hLbmxqJsHpyoot3fleQHwUp/TqlNbp2Iam86+ADAez
B7eiiJEljXJkEB7D/67PN6UQ9lJLD3INQiJc17Shs4UGz1lhQedYdIoKWggpJzDf
wD8SThyK8ijXjh7rWe4tcfpqirb5CJyAcJJ6TFxEpzh92RUoBUU2XK4K+x3reFQb
RGYrmlAd4AKhaRwukWUqiLRJZTH0Nln8Ut+UFbSc4IcQI3GmoEHGdgsZEz3CDkNN
i7CgcgrY+uJ86OTwzuYtsNn1erFT3LMKHJzLoV5UjjPyK4z6/F+HFfv3jd/r6q5+
KKER8lt41Lv/h6LHUL7gK4gNMQ8Wuh1T8ge8YBFI9R2BT672EcglCLUHYheuA2A9
mpm6cOuKVjmYlFsdAsoT
=SftQ
-----END PGP SIGNATURE-----

--oiL9LJXJsdjS5rzq--
