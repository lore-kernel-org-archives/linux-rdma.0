From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 5/9] IB/qib: Remove DMA mapping code
Date: Thu, 12 Jan 2017 15:15:11 +0200
Message-ID: <20170112131511.GJ20392@mtr-leonro.local>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
 <20170111005648.14988-6-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZY5CS28jBCfb727c"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111005648.14988-6-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org


--ZY5CS28jBCfb727c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 04:56:44PM -0800, Bart Van Assche wrote:
> The qib DMA mapping code is no longer built since commit eb636ac0e49e
> ("IB/qib: Remove dma.c and use rdmavt version of dma functions"). Hence
> remove it.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/hw/qib/qib_dma.c  | 169 -----------------------------------
>  drivers/infiniband/hw/qib/qib_keys.c |   5 +-
>  2 files changed, 1 insertion(+), 173 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/qib/qib_dma.c
>

Nice diff stat.

--ZY5CS28jBCfb727c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh3gV8ACgkQ5GN7iDZy
WKeONQ/9GsvHPywVYjx2U0IyXp/3NIJCDsgkuXzYS4uePescgBH3kCAMafcjx14q
B+W/r05qvE3itM8kWEFnHqTwkPraP8UaB5IMIciY2Pu1v4aqRZApBI8Bmo5LKPoy
34qo/1VCLb25ssYsF8WfFqv6vAODQvhr2Yt34p7svB4/jYunlGqzb+ZVCp1p67Gd
W+7Wz/btMP6tJHnmhPPVBbgRdfMMbtpOQh5kDaQaNMREVGpQRUBuFthIaQeHJlz6
Io9KyyIbIQs2jZTGcH0CsIT8KhBqYHro4t4vCIOIZ4hv/vY4sa/2yIoxqaro91ZA
PeuRT5kCP/fPVSG9/Xonc3u3IHvWSKp9vYgfRVTafaJrZmZmsbXWBgouL/el9CWM
iP8+kIPXE2Zwj3mk785833kz9eU2euX7eZWwv/BDhGvN1wp5DTQuiYyOvDJ5aSTh
q8t9DddxZN3XrDSSsr4TVvahoMpA/8nABTo3nsibk1dJ5knzhxsOMXZT9mGOg/8P
qIgAG1fgNdVEhl7+EdaGIB3N1aAbJkKlIFS9/Cw9CgEBRejegqLxhM8HLbEbH8KL
12cqzfmVx33Z5oqZrXsFGbHB3wjkM9QExjrrwOAB9D8CK3O/ovlgMgBhGPVzVtW9
/K2GX94NfrKHqQve0xHTr8/NC0kf4LZK+U6yGcQ3mKXO4UF9BKc=
=Tkyb
-----END PGP SIGNATURE-----

--ZY5CS28jBCfb727c--
