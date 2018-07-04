From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/3] Dump and fill MKEY
Date: Wed, 4 Jul 2018 21:54:59 +0300
Message-ID: <20180704185459.GQ3014@mtr-leonro.mtl.com>
References: <20180619054724.32677-1-leon@kernel.org>
 <20180704174739.GA9317@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OxDG9cJJSSQMUzGF"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180704174739.GA9317@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--OxDG9cJJSSQMUzGF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 04, 2018 at 11:47:39AM -0600, Jason Gunthorpe wrote:
> On Tue, Jun 19, 2018 at 08:47:21AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > MLX5 IB HCA offers the memory key, dump_fill_mkey to increase
> > performance, when used in a send or receive operations.
> >
> > It is used to force local HCA operations to skip the PCI bus access,
> > while keeping track of the processed length in the ibv_sge handling.
> >
> > In this three patch series, we expose various bits in our HW
> > spec file (mlx5_ifc.h), move unneeded for mlx5_core FW command and
> > export such memory key to user space thought our mlx5-abi header file.
> >
> > Thanks
>
> This looks fine, can you send a pull request off the mlx5 branch
> please?

Updated mlx5-next with first two commits,
b183ee27f5fb net/mlx5: Add hardware definitions for dump_fill_mkey
4d4fb5dc988a net/mlx5: Limit scope of dump_fill_mkey function

Thanks

>
> Thanks,
> Jason

--OxDG9cJJSSQMUzGF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbPRgDAAoJEORje4g2clinJfYQANMLj5LzpRoehBbFsKZL+ZVx
K6lrGOarP8n0TjZk2XjZslaKt6sMjK+TFqnv89kvqx/b2fMkLZurcb8Ftr9iWYQA
u6JbMKNwuPJ4d1a+qBYu4cd3FA5evqbnaUuqKjF+VcOfZxidqsQ2hWByKcHkOLym
1DG4ezFWrulzUpIFOzi8OJRK+SMLnAboKU5jfV38dvXYqZTTnbgQ7xuSw/IeluiD
tEdr48p1F5X+rjI0jg7jJ/eGRZmevrQi/84vLZKD7M9VJANkSWk4b88oDMDNej8n
0Q1TFUN3XJWIYW8hPE2cGLCaACltJH5rjG656CSRAgoZJl8S7tzvvGBeBWODvqDb
6J3IrUspOFgcN4802ESEfC3qCepUBp8W1CY0V0Nt4AGGiDNSOXVe+3SvvEvE4dNh
WX+BpbJGrRrDxqxuIzyoekq5/aYweeDTOQR9lpxjk1ioofLCRfjRnfaI/WV6RKGf
3ZVgqRviu3alusR4hRFzi5QO9VRpaNStsCBbCMFbiJLTJsD0DEcrXk9cwG5sQpLk
8diHmhkC9mnNPDCEl9IOL34HFiBjMiau0KJ50NzxjaFxqWYR641dnSBuQyvmD5Bj
oinejcDurX4UpfWP/Hn0sL86xBpZi4C+Imur53uYlMXc4CDk2YNMNvVgDZzHU6ri
NjUbsovzIgl8r8ArE1z4
=gMgw
-----END PGP SIGNATURE-----

--OxDG9cJJSSQMUzGF--
