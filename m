From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 12/18] IB/mlx5: Rename to_ib_ah_attr to
 to_rdma_ah_attr
Date: Wed, 19 Apr 2017 19:42:05 +0300
Message-ID: <20170419164205.GL14088@mtr-leonro.local>
References: <1492212538-32459-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1492212538-32459-13-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJAclU0AInkryoed"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492212538-32459-13-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--IJAclU0AInkryoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 14, 2017 at 07:28:52PM -0400, Dasaratharaman Chandramouli wrote:
> local function  to_ib_ah_attr is renamed so it in
> sync with the rename of the ib_ah_attr structure
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--IJAclU0AInkryoed
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj3k1wACgkQ5GN7iDZy
WKfr5RAAzWNavjqyE2mHg2z0347gqLNHe6q9hXyDMRYFfnu90/Mtdl3Rb1KSLEvL
9lnNKNZlVGDKfglyYEwsTEAbnnM9+/tnXb/cfFIqzcN24gmDlJ2aK+eNeqvCLxx5
JMmRq6HosTzxpnDnJNxLZPT64HAzK+hy6E/iNZmuxu1a6TL0cbuxhJ1aVt8GvtCI
+eVvgYOZilS3JMPyiKniHE8qHCV5/Vgb6Yg3BAeBQynJeHrll2IGIlW2zra0FS5d
00qkOmGAfLsmT8sU6EAVINA5NqnB5B53pdgHZmb07ecufpdY062I1LMOlyiwCrnl
uIpdrvz1Ij9PPYr31ap0esvXpa228L1yqP7dND+y+ZR2QijFx1aE10k2bjuTWy9T
0hBJc4LeiuQRdkx07lklA+tPhEzbygqOQS0TfHz6R1PBw9xoF2PHPgKhSslUIQYG
zvAbZGQsYcjltGaJmnAXDY1Cf4X+Mm7mG6X1l9MSXQ1vZXpF2EOG/TERDsUz0fsN
3WhOeJ2KtrEuNiBEL8rcoPMSmBvWlr3QLLkGYZPEdp5IPWZ+wHJDBjTSEtAwAPQ0
icXeC1Wm+MF1POHvKUPcfWeImvubBMlJ1cStW2eJd6f1jPmyMFbrGU9XlaRzxX8w
ZxIX1C27iL1kRCBcfpbMzgZs0ngwys5tTAS7W8hgSt1FaA1kq0Y=
=aGS1
-----END PGP SIGNATURE-----

--IJAclU0AInkryoed--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
