From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-core 0/4] libqedr: cumulative updates and fixes
Date: Thu, 27 Apr 2017 11:44:51 +0300
Message-ID: <20170427084451.GE14088@mtr-leonro.local>
References: <1493273468-23774-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Fh5LqGQwq8YwuKb/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493273468-23774-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Fh5LqGQwq8YwuKb/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 27, 2017 at 09:11:04AM +0300, Ram Amrani wrote:
> This patch series includes a couple of updates and a couple of fixes.
>
> Ram Amrani (4):
>   libqedr: remove obsolete device IDs
>   libqedr: fail post_send on WR overflow
>   libqedr: fix comments and alignment in verbs file
>   libqedr: prevent EDPM loopback
>
>  providers/qedr/qelr.h       |  1 +
>  providers/qedr/qelr_main.c  | 10 ++-----
>  providers/qedr/qelr_verbs.c | 71 ++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 61 insertions(+), 21 deletions(-)
>

Thanks, applied.

--Fh5LqGQwq8YwuKb/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkBr4MACgkQ5GN7iDZy
WKdqNQ//ed555LQmORoM67SrhhiiirhIkDAaOXnV/6d/JnaR3OEhwC8fsELSnuNG
n8Ltnb1Z6lEInZAeJodO+bcYZ1QrCg8aM2eYHlWl647pO+Tn8zUvER9Iz7BTZhKl
9VkdMQy9wS+XfpkwULZiTbhn+m4Y0oSvGLlXax+V0iLNkqetWIwSRRiyapoCfreQ
f8lZxYlQy1bq7Fqn0SXClIL05U3QkzvOBnPmen0e6JskMW4WMs3eNTdlkP9oOeX2
sUwHbvdncXllI9bzG+WDyCbTqkmGyvanF6Wz+hH59KB7fAyc+mz405kj4HDcvZL4
x4tNfBioOKgppdDdvWmQAlPIKtQcRoy73aq2M5XbQqCpRM2tYRTDLDCVnVleojMS
95GqZPAncpZe3ivOdzmn/2oX+TUW+R23z21HFnCoKVFVSatwH1X6d3EM7vWuy5PI
H1xNuc4pWmdxQL46KQ3Ob4E4sGx+StSsnAlbNTTCOkX2BBsa6J2gOUQyZS+H8OBp
IE70GYlOqazVYNYzqwd2i5sc3A5qn1/dXvEgCKb6Jt8TRfwVQDY3nLX4/CPmoQll
DVRQ4BsnsU6H7N2ig45sazscyUC/LHcB+ywcsPe5tH+UxJ2NhFlKNiDkE2g6ayC+
bIwoSyEWNmjrL/gcjT3igx7KpgtLqZXSbC0+doY+CtqY+7Z25dc=
=Zrim
-----END PGP SIGNATURE-----

--Fh5LqGQwq8YwuKb/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
