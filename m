From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
Date: Thu, 29 Dec 2016 07:29:40 +0200
Message-ID: <20161229052940.GH26885@mtr-leonro.local>
References: <1482978283-201678-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PW0Eas8rCkcu1VkF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482978283-201678-1-git-send-email-liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org, vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--PW0Eas8rCkcu1VkF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 29, 2016 at 10:24:43AM +0800, Kenneth Lee wrote:
> There are two bugfixes in this patch:
>
> 1. When the execution go to the ib_umem_odp_get() path, pid should be put
>    back.
> 2. When the memory allocation fail, the pid also should be put back before
>    exit.
>
> Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>

Hi Kenneth,

Thank you for resubmitting it. This fix is important and no doubts that
it will be accepted, however you need to improve the patch a little bit
more.

CAn you please resubmit it according to Documentation/SubmittingPatches
and reviewers feedback?

Haggai's Reviewed-by tag, Fixes, changelog, version in title and
proper title (see it in git log for this subsystems).

Thanks

--PW0Eas8rCkcu1VkF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhkn0QACgkQ5GN7iDZy
WKc5GRAAr7jPy/wFzS48kwfFUp8aowwA+EKXDu+5d/M3XtRmae1gH8yIU+DCfqAj
wwNYJUDcbr2QVTjaYXxPjWKUnKk6JD9ySC2bswDBzmk+uyihRkg2rT9sVKHyjg4v
ut+vV9QO7d4hJfURoZk6rRBapgYL0oibKYswHYwksar77Te5CYoAmEbfa+WIGFUr
bMtUem0Tc+0Atpv6eUcqTqKsacicMor5t+1DRj4bl/cj/2MStQ82bKz6YsiORI1B
GwuJn21yOjvV4J8SHD4c2upJ90SWxuxi4Tj4vlzfEYjtah6R45wnIBbgrBKjaLIs
pWYMJMfyAM0Uyyfz8Ac5FvT3y2MLCR60kPCVEsSQ8cokPfXDAT1c3pd32rFRFUxj
/e/a/88ZcUGZxF6fBalTAcYVwUYb+UDLnP8y3aCkgH6lCIQsYSRQzAvtenBoqzK8
StxPEouQ8yZoqEYKYbLe2U0hceQOF5+iHvwK/ngpIn/nHLhogk7dQUqJ+v4c9QeO
se6dQnHpN+vEZPBifaF+KcaC4W1+mwgRKaEd4EEHjI7bMzFWKTuqqCR67Z8ntD4/
R1bGtWXDtTh8rAZrC2r1HJwwlyMLdo1aFTLbtm6GNYzdjcZRswIm0nG9o50OVQUv
YWY1orNcIAM3FIRV89YE/5Uadn4W5/EQUqohXE7kNZOKRppK6W4=
=AHoF
-----END PGP SIGNATURE-----

--PW0Eas8rCkcu1VkF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
