From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] libbnxt_re: Critical bug fix series
Date: Sat, 13 May 2017 13:49:15 +0300
Message-ID: <20170513104915.GI3616@mtr-leonro.local>
References: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NyChO5MpGs3JHJbz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494584666-11064-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--NyChO5MpGs3JHJbz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 12, 2017 at 06:24:21AM -0400, Devesh Sharma wrote:
> These are set of bug fix patches for the libbnxt_re user
> space RDMA provider library. This patch series goes
> hand-in-hand with recent bnxt_re kernel driver bug fixes.
>
> Devesh Sharma (2):
>   libbnxt_re: unmap DB page during uninit ucontext
>   libbnxt_re: reset head and tail when moving to RST
>
> Somnath Kotur (3):
>   libbnxt_re: sq needs to be augmented by 128B
>   libbnxt_re: fix wqe size for the 0-len posting
>   libbnxt_re: move rts to rts after a threshold
>
>  providers/bnxt_re/bnxt_re-abi.h |  2 +
>  providers/bnxt_re/main.c        |  9 +++++
>  providers/bnxt_re/main.h        |  3 ++
>  providers/bnxt_re/memory.h      | 10 ++++-
>  providers/bnxt_re/verbs.c       | 81 +++++++++++++++++++++++++++++++----------
>  5 files changed, 84 insertions(+), 21 deletions(-)

Hi Davesh,

Please use "[PATCH rdma-core ..] ..." in your submissions for rdma-core
library.

This series applied.

Thanks

>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NyChO5MpGs3JHJbz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkW5KsACgkQ5GN7iDZy
WKfnQg//blBBkFOfUVGQ+FDP/vyAYMJY56QmmqcDMqyzCI7Z/sLutv1Jy3v575Fu
O1s9TWP8z3o1Qls3heOkY6AlwarlgmTO9HTFgNr/LPX1Kz+4a0CFcP2KPZf3hi8h
usC7xGTCF3vis50qJK+YXoDxIV9+iBCGCVD3aD+T1ZruS6wDqtF4P784zYjoDMa3
uzg6ciof9MojWhF1RSCxiM3BC5Ho3DH5i4UqI96fMwk8CyUSYFFGXONqYAp49rUD
gWjyLFi+H0yFmTmtP82LvOJI57silx0zCqpl5iAg0QCJkY3DH7W7IMeX6fOa6hxy
EZppr93n/7DAleVHXc0W2Ka+BufZyZlvgY8QGqRbCssnNjzBIjw8vtrVZoG9UcgP
/y2pCDHB3s7xOpfUCUsBSKh9dc6QDOUr4dBPHUdf/KVYbwg/50/G7DFmaVH3ogrc
JNjk64eGS9gD/J6YRtWO9MtXUjP7wqKGinrOQHoMdPyvEVL2fCdwIfQOCUIIPIw2
0tnlr6S0ArQG3+9lBJ6Xa0vJ06Pcq1D/FS07eqW0bkfhVUJFG3IYr5GKdHQdtZHd
gLxcPlUuwHpor0RRdTfrpAYBG8APLDdPmmIHNr8OFdpWVDu5xTnDEz5TXfUzXUd9
5qfvVkcjAYtK+RIkrNFoMNuX8IrJHXw0N/uQb48SOAcbLZ9HvPw=
=t/UQ
-----END PGP SIGNATURE-----

--NyChO5MpGs3JHJbz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
