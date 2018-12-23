From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 06/20] IB/ipoib: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 11:41:17 +0200
Message-ID: <20181223094117.GQ3940@mtr-leonro.mtl.com>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <1545555435-24576-7-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6eUvXotnMb6+obQB"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1545555435-24576-7-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Doug Ledford <dledford@redhat.com>, kernel-janitors@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--6eUvXotnMb6+obQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 23, 2018 at 09:57:01AM +0100, Julia Lawall wrote:
> Drop LIST_HEAD where the variable it declares is never used.
>
> Commit 31c02e215700 ("IPoIB: Avoid using stale last_send counter
> when reaping AHs") removed the uses, but not the declaration.
>
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier x;
> @@
> - LIST_HEAD(x);
>   ... when != x
> // </smpl>
>
> Fixes: 31c02e215700 ("IPoIB: Avoid using stale last_send counter when reaping AHs")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--6eUvXotnMb6+obQB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcH1g9AAoJEORje4g2clinbiAP/09GK5uVeUsgTo9XjVHeaW++
hsT8BlZjsZp1bLcOXWGNQHqPNtUDdxDiOp5vdnsTN9cayNUmqbWV1+Fd+NIkiXO6
CL308qmZc7Rh+lc9Kzx89P06KQ8naRa98MkC+OK2FwDRCi0iM7kfhhU76SHu5m4a
9Xfrsqq5V5tUdIVIZnaKcKF9cOH9yKQ84GLxhR5KJkTipDvp4rttTTSBDJwr2rGR
vZxME3gSRLN67jpugpYavRNeklUcZ/pVIdlV1PnRhHN1CHAc4oDFj7hCBCJ8eR0D
0kzeTSKOPZn+MpkFZWbM67d3IT8gc2GFML1cdNDCeD8zL0MWW8plkrpojgWlC+re
LAxETG6EdnIV0JFU7X88tK1tcBOHtTixkD1AMONuABATglQoYMAHhZvuhDiVZU4e
3QrkmMjPeWoJW0ZoiGDUcprWJl3qkflHTg3M06q+FuCMOzvvSvJUYEBFd4/Gut+L
S8HUOhcDw/CDHhjorLAwWEkifoSSYEFJvWQEXmn6OjvCd3SLUdjttsZ5ZLVnJlYf
ANM09Uh966ymj3uno+m4qcsFzkX9yYfLFTnhnmPf8ZJoinKdC6ztLd7eo7Aubk1Q
IgkAPX+a0NI0A9urHY1s91AXIcJs9CKQVh5xvemhTTEm4B6yQjJh1jcNRwnZod/x
jSGxgzvyFRWO/kb0vvRa
=hj/d
-----END PGP SIGNATURE-----

--6eUvXotnMb6+obQB--
