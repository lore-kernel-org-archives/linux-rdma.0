From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/nes: fix nes_netdev_start_xmit()'s return type
Date: Tue, 24 Apr 2018 20:36:12 +0300
Message-ID: <20180424173612.GI24820@mtr-leonro.local>
References: <20180424131545.2810-1-luc.vanoostenryck@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f5QefDQHtn8hx44O"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180424131545.2810-1-luc.vanoostenryck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--f5QefDQHtn8hx44O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 24, 2018 at 03:15:45PM +0200, Luc Van Oostenryck wrote:
> The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> which is a typedef for an enum type, but the implementation in this
> driver returns an 'int'.
>
> Fix this by returning 'netdev_tx_t' in this driver too.
>
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  drivers/infiniband/hw/nes/nes_nic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

ipoib_start_xmit() needs the same fix.

Thanks.

--f5QefDQHtn8hx44O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrfawsACgkQ5GN7iDZy
WKfbUhAAhOvypJ95u/rDjVkRH752kVdNPdDMojU0DjVznGZe5U1tzvAriR5FPSq1
s5O5dCoC9Z4E4Q1/jiG6z1QTX5V9faxdB/F6StUhPjD8dznYplIxWrFv+YqZOyzo
YzMYrQgv+i4Rw8+39BWKVchW8uLz5PxtlOjtzB0JFBLy1BcMG6X1D5r4faI567Qc
moB3aeP4wqFXKX6sI7HfPjjWlyzXrkUQG1s9Yzl5fspQCRnpR6ZcF7UMT7FEqvHp
OChr6Mo/b/LanjYacKgz/oQ2IR7WQe73xRrszHizI0f1nNnJ9GcEsMb/+AHZ3VDO
t107BCDJ5r2GXfTv7OrivKe0GlO7rITFFbfGO/+0TT1Rflg2Xq66g4lBfb2N7dNP
u2R6ti9lDXYy5VdSyeQdkzpdb8L2QKkqLyxK+hFX9S/JH8FAAQYJxeePw710PqgA
/NVo58pcnx1fIVycLuZ4wV1CPOgofn9p3LsLZRl05cGkQu42dU6ScS897WoYuUju
Zv4k90ezHaNX1jsQZhTLB6jzqXDMuFmHpI9TsxsUN/0/P1g5dkxdWGv8YH6kq8ed
w5xMGaDSGHEniuW06LC41wtcgjXH80J5P9zaWJZYHfP2CF+LPI0AWVXRo8UUaaYI
F+hclUwuTHDFkSzhv+tKR4PO1h7Lv6mcXoI1ZfeU8P7a67fmU9k=
=2qAd
-----END PGP SIGNATURE-----

--f5QefDQHtn8hx44O--
