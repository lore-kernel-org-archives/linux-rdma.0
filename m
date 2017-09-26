From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] IB/ocrdma: pr_err() strings should end with newlines
Date: Tue, 26 Sep 2017 11:44:35 +0300
Message-ID: <20170926084435.GC6816@mtr-leonro.local>
References: <48e72f72b25c067588b3da9142c7849636615df9.1506410780.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48e72f72b25c067588b3da9142c7849636615df9.1506410780.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: devesh.sharma@broadcom.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, yuval.shaia@oracle.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 12:59:51PM +0530, Arvind Yadav wrote:
> pr_err() messages should end with a new-line to avoid other messages
> being concatenated.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
> changes in v2 :
>                Add same changes for 'ocrdma_hw.c'
>

Two notes,
1. Please send similar changes as a patchset and not as a standalone patches.
2. These patches "\n" are not needed, see my response to mlx5 patch.

Thanks,

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKE3IACgkQ5GN7iDZy
WKedsxAAnYqXs9a+khR8lWGNJrHZlfcDRo5B5EOrk9KjUfXG9AZCGXdEk3zZdajO
WplRPEOrKQclmtMN0zo0mePgPng8qYl3V37LbDgm1bs4S/zjwUwxUIklOdblKFaK
WPlKSwtKakDNw9vZkSxkUzCOaD/bts38P+6vCqFI/0oqGT40C9dshxnG8NzEWxHh
K96WnRT/QHXJcoqPtzFMzFkcQgSADOhKcQ9SI9YMA2Td1eqZzCwFODcublteUh/G
d7SRtmfVgII8TDoZuool/4IlhFlAONRFg/pQAJOAGsiAqoXvIaMETPlwESDJ3mu2
pWCBlFsox9vr4f8lINuQFK3z3BDeM5XGKatf9+N7Iw+xxHw9JQheBxlHxD43d2jl
bO7LMCt7fzzr75BWciQXVCbzMKGuz1pfJgNHp4g7Fk2jF1l5+TzH/MB1X7j7ma4k
xHYQl1HBkLEtDoeeMTNHXtOniNRY++V8NNhCuFStA15DbI/0P9jkV37nsDOBbF32
cbVU4rmU4LOq32+Xt6KC9QPfj8hdiI+kCJKY+4Wh82PaRNhIo5QNuf/0XZMO9UG3
fnwR5YCX+XCox+ViNxoz8Da26E4VSU97ifwCtlCw3AT62WlFdtH7Obsy0stVgRkQ
dxjH+2ZcwAdM6CEfnh2jCCs5rmBhMOHUSUvVZneyEwQ+qe61wtM=
=3t+i
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
