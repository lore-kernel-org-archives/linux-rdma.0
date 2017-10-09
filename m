From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] providers/i40iw: Do not generate CQE for RTR
 on QP flush
Date: Mon, 9 Oct 2017 10:26:50 +0300
Message-ID: <20171009072650.GJ25829@mtr-leonro.local>
References: <20171008233741.9168-1-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6nIn9DQvaie41cmo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171008233741.9168-1-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--6nIn9DQvaie41cmo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 08, 2017 at 06:37:41PM -0500, Tatyana Nikolova wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> If RTR WQE is posted and QP is flushed, a CQE is
> incorrectly generated for the RTR WQE. Add code
> to look for the RTR and not generate a CQE when
> QP is flushed.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  providers/i40iw/i40iw_uk.c   | 12 ++++++++++++
>  providers/i40iw/i40iw_user.h |  1 +
>  2 files changed, 13 insertions(+)
>

Thanks, applied.

--6nIn9DQvaie41cmo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnbJLoACgkQ5GN7iDZy
WKdxcg/9EObBus7kJeF3zasLIze0qmJJoZiV4VzSGGrN373LTnWdNGmndeoYxoL3
e3NLfyef2U+p/GzdZHInj+7LCunlskrTZ3GvY451B+4b8KvDm4BtxF8gnFuklSKC
Pt8TUTlbmcRnhi1dlP7NGI9n8W37Y2GN+3B0xfor1Ia6JOqpxbWtOBsCx5V6mNwH
dfwrLognLmqcFa27fOZevFRMwKxxv55m+AqCPDgBZHLZFwd2nef+9D0TUQBAnFhb
UZyFZHcu5evNr0AFjEvvsG+go/VFpPZdVdfev5x/VUW1UD6ivqjbBAMRn6jjodgZ
BUFOGQ166+H9hWg+TBZMWvRrtRNfAW/van7ShgWemyGbaH3SsoT0EEiygfW83Uyu
iD5K+bdq6vkSGe+JvOgcho0VwA9AoT4gp+dFA0xZ3VkvfIjsUw/wZ8b8z9k0U+Oy
QbQr973WQUkSZPCHK1mZJl6T8epAmDFR5ffXuK7k6CH14YXxuQSxj/by1qzqVq87
zhj66RqByk5wqjAVrweVGzzfD/T5FjTwl1Hk39sguZSHAsh3+vIIjr1916TMSEWU
Tu0AYci912musuZGU2XWL2Onh3Dm6zanVX6K26d1CTvzmg66sLykMCp4TYw3HVEF
OH6UxiVnWg2/HHE5L5a5IsgGoDwNbaWPX6BLFqPfYm14hBfEhn8=
=ehxI
-----END PGP SIGNATURE-----

--6nIn9DQvaie41cmo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
