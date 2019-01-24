From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 0/4] mlx5 next misc updates
Date: Thu, 24 Jan 2019 12:30:43 +0000
Message-ID: <20190124123041.GS3604@mtr-leonro.mtl.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9JSHP372f+2dzJ8X"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190119003313.16711-1-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 18, 2019 at 04:33:09PM -0800, Saeed Mahameed wrote:
> Hi all,
>
> This series includes updates to mlx5-next shared branch.
>
> 1) from Jason, improve mlx5_cmd_exec_cb async API to be safer
> 2) from Maxim Mikityanskiy, cleanups for mlx5_write64 doorbell API
> 3) from Michael Guralnik, Add pci AtomicOps request
>
> Thanks,
> Saeed.
>
> ---
>
> Jason Gunthorpe (1):
>   net/mlx5: Make mlx5_cmd_exec_cb() a safe API
>
> Michael Guralnik (1):
>   net/mlx5: Add pci AtomicOps request

Those two were applied to mlx5-next branch.

ce4eee5340a9 (mlx5-next) net/mlx5: Add pci AtomicOps request
e355477ed9e4 net/mlx5: Make mlx5_cmd_exec_cb() a safe API

> Maxim Mikityanskiy (2):
>   net/mlx5: Remove unused MLX5_*_DOORBELL_LOCK macros
>   net/mlx5: Remove spinlock support from mlx5_write64

Those two needs extra work,

Thanks

>
> --
> 2.20.1
>

--9JSHP372f+2dzJ8X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcSa/wAAoJEORje4g2clin71wP/2uC/dRvKbZLlT+1a1W1wfJt
w/IMoDx5sX87o2fm0K+4/J5bfLBOkZjcOW9Tg9qVlqUspu3W20lc1o572BImy6hU
CfglTy7CPKxZq+AThozzoqlTMzPvlh6Ce/FT3FsV8Z/Rt4O8l8wRUA5z5TmJ7iG3
ayH9NfJ1sodIXK6SaAg9i7yUwF3NADD6oDVL+m021sHXWtxz+rD8+FgOFIfh3hyw
5B0TpRLyuTxhMdqijuVmzMbbxNMkojY5v6s8cLFjBy3rqBvaXgn81jZchAn33Ey6
CzpnM4dcm9kLVa34iqXXkviWlGn3eDKBcjrcxUwxO5lk5zAVeQV2rN3Gjc8+2+PA
PYz/JEcP9QuAe+MTeGoKwQ9ujxNzaEYdPXVGOKumubhI4oQh5rZbkmUAhljvIED3
NL7/2M24w8NEsAa3Zm59HE1aMS+RhML7vowiHWF60laQAivhCO5XbWvqbuSt15iL
uUx+ijlP76FUiH9EthJHpLX8Tm7zP2jbjZw5tfSDOenKX4WULDsmXOlYxxHmLea9
YLzWwG24jIKOAoPjoGtwNL+634IKo5fIwejfJrcvVXfYgWJy4r5nUmv6MzAGQFPB
6aKUcCrkxrGAmNdk/GekJ8wLVyNqwjeSJuagzFuyRKj8camUhVRV9V400yizCs9g
7CDYISVfvkjiVj/Gq2zh
=DdaC
-----END PGP SIGNATURE-----

--9JSHP372f+2dzJ8X--
