From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 5/8] infiniband: mlx5: no need to check return value of
 debugfs_create functions
Date: Tue, 22 Jan 2019 19:42:54 +0200
Message-ID: <20190122174254.GE3604@mtr-leonro.mtl.com>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
 <20190122151800.15092-6-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122151800.15092-6-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2019 at 04:17:57PM +0100, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/infiniband/hw/mlx5/cong.c    | 15 +++-----
>  drivers/infiniband/hw/mlx5/main.c    |  8 ++---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  8 +----
>  drivers/infiniband/hw/mlx5/mr.c      | 51 +++++-----------------------
>  4 files changed, 18 insertions(+), 64 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcR1YeAAoJEORje4g2clinHPAP/A7jQ7mZ7g718Tan+qeF6TDu
s9RE2ISUf3M4c9GDplyR2dB4vSRQYc0HT2uYCEXfBQlLGlwR+Twxgq8SMU9tggXX
rFsvYGAwjEu0AUBWFl3xDht4oeo+yGYeDRKmP7Hn/U4S3VwCBPSUpiHhnQ0Fe+Mt
IvZZMLf1VSHJvqat+xGtGujZ6HbMHWoNCSFUJaR0vtsIONd7zL5vj+39gLwWNc/q
TleLp19nEDTefnrmL4eMAqXcQ7xX789P2SLDPMg3msrQimE1yi65vVPCtzTEiIfK
pH1LAgD1nL/N0YQG2cXAU0ekhh8pIbvWEDVdrFeAwMFfURXiY5JWevxB2vlv9Aei
ErelGBMHYBvA+dc306tqi96rYuLZe7tvNQg9XGpKMv70Mcn8F07jCb8i5C4sOfET
C4VFhivP3imDilBkBOYSlKpnGkwqaFA8nBxCe4Acy2KqX+tuWLGJLKqmrK026rIU
xRCU9mit4mvXss4QscQs3Uhp9XDwe+e0eZMmQkjW4Tn+nX311Zt1CJDrr/sodBR+
s24TPVxqYOXo/eqzTuc3tlVJvap2RLC65uajcS8EWu6+Bge33ea+hqsjfVLTIDG1
nbDYniuZURoIe6oKmblJTwB3YXGfthhk4MtcEUQGMRucEE7vxQbHX/3F6QiYwQIl
6Jq/Eqw2PMqrHVbpS6zL
=cVsM
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
