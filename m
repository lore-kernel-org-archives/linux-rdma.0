From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 05/12] net/mlx5: Rate limit errors in command
 interface
Date: Wed, 27 Jun 2018 08:48:11 +0300
Message-ID: <20180627054811.GH30877@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180624082353.16138-6-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 24, 2018 at 11:23:46AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Any error status returned by FW will trigger similar
> to the following error message in the dmesg.
>
> [   55.884355] mlx5_core 0000:00:04.0: mlx5_cmd_check:712:(pid 555):
> ALLOC_UAR(0x802) op_mod(0x0) failed, status limits exceeded(0x8),
> syndrome (0x0)
>
> Those prints are extremely valuable to diagnose issues with running
> system and it is important to keep them. However, not-so-careful user
> can trigger endless number of such prints by depleting HW resources
> and will spam dmesg.
>
> Rate limiting of such messages solves this issue.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c       | 11 ++++-------
>  drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  6 ++++++
>  2 files changed, 10 insertions(+), 7 deletions(-)
>

Thanks, applied to mlx5-next.

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbMyUbAAoJEORje4g2clinQcgP/RoSsUOiquE+IANLX0I9N8MF
RrJQwZwn9MQA3G+AiTNuau32oURzK9msgETMjgzhgxeVp/+n9DIGpV0q1CMFMdlH
+jtgj/hm5bskgiA81xW6SBAuUO262BNCBaU1Gyu1p2MRhRx4eEjGfWq4VRBu/gpp
tqU1nQC3kcH4/3ubDjeQ2FQBHzJQedJa1IQbhB89NrunSHa6+Ty3AM0g2LmWlZEa
beAFeD3xcPrg+X1iqFO1rcIJR8HnmYKANJWZ1XJ3n/udoEMASZ1QOrtG/rZrOnnJ
QyzZ2bCGOLNLSRtCMbMN7b4ha4+vraJM4BatqJN7frbc+CzftgdxPK892N/njE8n
qwbMtnHq2gDpiL+r+nEw2unJO9AG04Sp0cOchgpyX70L3UDmL6x7vWVhIXQnFM5U
PV8TdmZnK4frpYsW6WAT6dWASXjmWAgIXF3Yu19vD3ZgeA1OMw+tYFrhM1Ofk40S
riZtC0yIyKv4LTsLEwsnBDajRwfD+IKmXdqlTS1ibn4T8WjJP0L9PcMFQdrZhhmP
BR0rHKd7qLDN7fdYHrFnJiE2Efbn4lsA7EXQuuRpVsaw2Xw/LJzvjhrqBVcpXOje
lmyuh5+vLGk0y9yA5bRarqr4Vw4lUsWCtPcfTKkTdjGarkF0H7Z0+tt7PeNdkwhT
+VP58kIp+geMD65Cc+KD
=VfG9
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
