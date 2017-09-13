From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/core: fix incorrect fall-through on switch statement
Date: Wed, 13 Sep 2017 19:49:17 +0300
Message-ID: <20170913164917.GU3405@mtr-leonro.local>
References: <20170911160313.28240-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dwWFXG4JqVa0wfCP"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170911160313.28240-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--dwWFXG4JqVa0wfCP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 11, 2017 at 05:03:13PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> In the case where mbox_status is OCRDMA_MBX_STATUS_FAILED and
> add_status is OCRDMA_MBX_STATUS_FAILED err_num is assigned -EAGAIN
> however the case OCRDMA_MBX_STATUS_FAILED is missing a break and
> falls through to the default case which then re-assigns err_num
> to -EFAULT.   Fix this so that err_num is assigned to -EAGAIN
> for the add_status OCRDMA_MBX_STATUS_FAILED case and -EFAULT
> otherwise.
>
> Detected by CoverityScan CID#703125 ("Missing break in switch")
>
> Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Except the wrong title: IB/core -> IB/ocrdma

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Thanks

--dwWFXG4JqVa0wfCP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm5YY0ACgkQ5GN7iDZy
WKeMGA/8CzgkGeeSwh93C/BEupiN7XzgxRFt59cqn81jwFl3jB0EDR6xmKRC2Uyp
0aXa3lWyV2XPsQYnJBY4wW/U39cDDUfNqE3ngIc+GRFfY7+A5jSm+6KYmIVc3j0A
8pzlpibyyoc1Skg/l/GFAP+2Nn5J5Xebnos77wtVsqPImrcX8TUBxjYr1hTKJiZ+
ptVSEQp/61gN3/pWeD5x+SXvjhiUq/fKSfDoD3NW8UzjM4Ih4AYn8nGiO1ngQqFm
ZbIk2AUWCRi7ndqE9rp5nVsQcVyfc38yRdiek4uT4DjXdUf3ul+kW5NpdmfHWOT3
b1r4x0U7yGezhTGvwx66Y4C5ygdbiiXsRuxbyebBlkPHst4zmpIN/VqTJlN+h7H+
fBy+F91O4FMEnB5jw8ARWilX9D8t4yotEVLv5Lv1OA+IT7DCH0m475ZdETzX5A6t
MIAtsPbUN0sMPbRSjKM2dFxgyt8ATG1zG0CqdUBiMamrLRBCdNUlrBlXcM/hmsgJ
/KgIAOoHHDtW4I9E3JWdFKhIhXMJu8Zqu5FLyTiSTEPj9j4d82uPn1Oy5HddFUpK
lRnutGeIb770455YVRyJecd91NLaG507ftIX1zsv295pZ7j94Dp/eAwEIQvG8D22
D9uMw3M0G4rTbU/ePS3saE0ekdvNahj4dtv0n9+4yrCiXigLtiY=
=VPRF
-----END PGP SIGNATURE-----

--dwWFXG4JqVa0wfCP--
