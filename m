From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/15] IB/rxe: Remove a pointless indirection layer
Date: Mon, 9 Jan 2017 14:35:09 +0200
Message-ID: <20170109123509.GA15685@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353755.3592.40.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l4GQ7sizse6iPvDe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353755.3592.40.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--l4GQ7sizse6iPvDe
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2017 at 10:43:57AM +0000, Bart Van Assche wrote:
> Neither rxe->ifc_ops nor any of the function pointers in struct
> struct rxe_ifc_ops ever change. Hence remove the rxe->ifc_ops
> indirection mechanism.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
> =A0drivers/infiniband/sw/rxe/rxe.c=A0=A0=A0=A0=A0=A0=A0|=A0=A02 +-
> =A0drivers/infiniband/sw/rxe/rxe_loc.h=A0=A0=A0| 20 ++++++++++++++--
> =A0drivers/infiniband/sw/rxe/rxe_mcast.c |=A0=A04 ++--
> =A0drivers/infiniband/sw/rxe/rxe_net.c=A0=A0=A0| 43 +++++++++++----------=
--------------
> =A0drivers/infiniband/sw/rxe/rxe_req.c=A0=A0=A0|=A0=A04 ++--
> =A0drivers/infiniband/sw/rxe/rxe_resp.c=A0=A0|=A0=A04 ++--
> =A0drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++----
> =A0drivers/infiniband/sw/rxe/rxe_verbs.h | 22 ------------------
> =A08 files changed, 42 insertions(+), 67 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--l4GQ7sizse6iPvDe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhzg30ACgkQ5GN7iDZy
WKfElhAAghHS67D0/5IJuzvDB+v6XxYEOwnhk/pMiyeug3nkO55yeCZsSE+dC5+J
cwWwB6gMJWR4DtUe94FR1T+0IcRn+awCKia4iEEpQJAX+VaxBEGzniCr4Q/rDJo+
ZYaaRdKCIf7Scp965Wc9arIH/pgUcOxdaaA8WPsUm6AZbq1XGimDZp81s5UUajeL
ocQGhYRjvhvkh42my/gJvcWeUcjbddGzyH7v+Sc96zlfeE5I2lAcc7xtHF2xoqNe
Rq4p++AnDM6YegTHtREWdOQCNeae+NVQ4TrbHaD0GxitGLPVtTdlNWFdx557Bwy6
OeasJtzr5Jjzem/lb31yOkHfVHaaso6nyZm7OxevNPq+S87zqZb9gBl51eWn1Elj
rOB+1Lk6XTXbYkAiMvaCl1VChrPChBiTneXdKDVfuclE73B5rNAZDEEXyU9G6BOX
jRQ04oWuMWtW1S20qRLh+yUTjKD3XtyJ2nI+xdqmXgeWjifOrLyvqXJ9tJayKyIE
C03lOSSXb/SoDqDaII6bxTB8+QBNjC2Xnt7vSxP41KaMYcBtln9FVimYVC3rXZal
jUTwU+5p3T/Ih+C+RHLto6RicBvgjLLhcSuRsACssKfme4+2X0vqwlfN6zETwHDN
GY2idMNquwnhFus+bheDUiuQiTfGceihijxiqlWnsS/TQUxFWrU=
=9Wif
-----END PGP SIGNATURE-----

--l4GQ7sizse6iPvDe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
