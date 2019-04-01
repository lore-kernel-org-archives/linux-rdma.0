From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 3/4] rdma: add 'link add/delete' commands
Date: Mon, 1 Apr 2019 09:31:21 +0300
Message-ID: <20190401063121.GF8348@mtr-leonro.mtl.com>
References: <cover.1553627811.git.larrystevenwise@gmail.com>
 <a1b4b7640efb89346c45db060e88bb66103b4f50.1553627811.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a1b4b7640efb89346c45db060e88bb66103b4f50.1553627811.git.larrystevenwise@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <larrystevenwise@gmail.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 26, 2019 at 02:18:29PM -0500, Steve Wise wrote:
> Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
> device to a netdev interface.
>
> EG:
>
> rdma link add rxe_eth0 type rxe netdev eth0
> rdma link delete rxe_eth0
>
> Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
> ---
>  rdma/link.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  rdma/rdma.h |  2 ++
>  2 files changed, 85 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcobA5AAoJEORje4g2clin1dQP/2AvKpcYXH+2mrkWZ9ZcbFqM
EGXHnw0J7Ceads6PsxKsyUGRM5GWbwGVV0UrqFoqOlsVO/4v0naFLUARBqXi9ygf
QzFrIdgaQdrbT38ifUMAt2LwmS4On3RCrh9b/wEFrttZ7RpxqYKqgv7tHy6zri91
dqT2ZW6WooHR0BD475A+r7H1AmjKsqjVVcdxctTKlhLBODN17ExYyeplKqC006mW
vNr7fEfHr0cyM+1A7d/DMWPT35GLggbET1PYXUopiMWCHQEn+xfHSjbe48PjaxGi
Y2y9AAj9tuYCKRJPovVIh21FrP2eT+2Uj2KeBFBz/tRtlaMBcjFxCFKRFrLvM08x
8bbGSV0VRrl6qUtNN1gXGX56VEL2giq3NBQ8tPa5ujU3HG1ZCqcnhQkNlHkErnvJ
KLaTLxRtjMvtm26l9LbZfhPX133WDFQEBGy+JLLbbUeeKy+2pYm4qddO81Bb/KEw
KU10SIfuiQOgO0klD4utYvpp1OF/sgt/fIR/R3PxRqHqtsg8IYUCstfUdk8x3MmH
0qmxFBrpQEHkRFGLaYFqVkA08RnlAAOcei8Pm/wUJ4ccboPVGvwNlNsMhgtIdN3/
ahh3c3vyy0VXeTBsbS8MhvRiNiZwVYpuRjFvBoO9ray0WFrubdrqdQ/gm7FdouTP
HwXpxsiYNmXvpJfQq2WJ
=NzKT
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--
