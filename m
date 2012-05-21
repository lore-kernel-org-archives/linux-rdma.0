From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Mon, 21 May 2012 12:05:26 +1000
Message-ID: <20120521120526.fcd34b38fa4d21fdfd28728b@canb.auug.org.au>
References: <1337562868-9887-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_12_05_26_+1000_UCXOZhjpRRIOIcLv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337562868-9887-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--Signature=_Mon__21_May_2012_12_05_26_+1000_UCXOZhjpRRIOIcLv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

On Sun, 20 May 2012 18:14:28 -0700 Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Vipul Pandya (10):
>       cxgb4: Detect DB FULL events and notify RDMA ULD
>       cxgb4: Common platform specific changes for DB Drop Recovery
>       cxgb4: DB Drop Recovery for RDMA and LLD queues
>       RDMA/cxgb4: Add debugfs RDMA memory stats
>       RDMA/cxgb4: Add DB Overflow Avoidance
>       RDMA/cxgb4: Disable interrupts in c4iw_ev_dispatch()
>       RDMA/cxgb4: DB Drop Recovery for RDMA and LLD queues
>       RDMA/cxgb4: Use vmalloc() for debugfs QP dump

This commit breaks (at least) powerpc builds and has not bee in linux-next
before today.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_May_2012_12_05_26_+1000_UCXOZhjpRRIOIcLv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuaLmAAoJEECxmPOUX5FEq8wQAJH1x+jSI+YzUzNui/T8LYPx
EOETQGAtauFbCIaaPc/BZYWwXmdjbtQlYblaqsQhmvxU6JryJIkPP2Q5XORbrW9y
sHEQ+5Mga5RGXMh2Cm8u3uRGC123SSjMe3QxZt3Hm+sHcUk/0Knne7t3TuRyhTK6
vGYz9Nna4Tlpd41L153VhLx6LJ6m+QzTYR3ayKiDPzjTbGiLJ3cmzWg5KwTIQxqI
ourzs5yQ28jDR1Up02AKkhLRxovBoildYx/IPSwyVEg+8MElYzCx8DpxjDfgFH/F
6HP5yonln/DtdAzELRgehQFL1xwhF897hgJV7L2B0kuKoulOxcYXI8FC0WrU034R
yjT2cG/iIbuBJF2KLTWqLiunUl9PyXX75CitqTEo5Svvpo+E0jnW3/Qsziv3Glqa
x6DauGkJM93vJJ1MwUcRH0JZ/k8JpkUprf2r4cQRiQrEnQOgJ+q6RMCqcvM90o+t
nPxZaJ4R5rPQYSlxrdvIoVq+XGjNNtBhu2tLTs3xBQceDcGuPMIxrQaVvzLoVSQG
PU6NGLo0wDyUHEINRItY1rbWRkPa0H8Vp/wtuPkuoBV5YUq4hMMLZVzJDRrLUjyH
nJlaDyAYkO4/wMQKC4ouI6/EbZAnc95pSVOj4Rj5PjuXPmjVxgC8GSOPbYLSSOu/
shulFjU2K7wYsAB9fWHX
=wH7E
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_12_05_26_+1000_UCXOZhjpRRIOIcLv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
