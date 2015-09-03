From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] staging/hfi1: replace indent spaces with tabs
Date: Thu, 3 Sep 2015 13:43:09 -0400
Message-ID: <55E886AD.5090607@redhat.com>
References: <1440185182-56772-1-git-send-email-Jeffrey.C.Becker@nasa.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wK9ofX8hCv5joAUVvu2AI0x2nX82X1TqS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440185182-56772-1-git-send-email-Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wK9ofX8hCv5joAUVvu2AI0x2nX82X1TqS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/21/2015 03:26 PM, Jeff Becker wrote:
> Running checkpatch.pl on mad.c produces several=20
> "ERROR: code indent should use tabs where possible" messages.
> This patch fixes these.
>=20
> Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

Thanks, applied.

> ---
>  drivers/staging/hfi1/mad.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/staging/hfi1/mad.c b/drivers/staging/hfi1/mad.c
> index 0a18fee..37269eb 100644
> --- a/drivers/staging/hfi1/mad.c
> +++ b/drivers/staging/hfi1/mad.c
> @@ -4075,11 +4075,11 @@ bail:
>  }
> =20
>  static int hfi1_process_opa_mad(struct ib_device *ibdev, int mad_flags=
,
> -			        u8 port, const struct ib_wc *in_wc,
> -			        const struct ib_grh *in_grh,
> -			        const struct opa_mad *in_mad,
> -			        struct opa_mad *out_mad, size_t *out_mad_size,
> -			        u16 *out_mad_pkey_index)
> +				u8 port, const struct ib_wc *in_wc,
> +				const struct ib_grh *in_grh,
> +				const struct opa_mad *in_mad,
> +				struct opa_mad *out_mad, size_t *out_mad_size,
> +				u16 *out_mad_pkey_index)
>  {
>  	int ret;
>  	int pkey_idx;
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wK9ofX8hCv5joAUVvu2AI0x2nX82X1TqS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6IatAAoJELgmozMOVy/dZcwP/1yYh4Up1G/do9/yN34f6CBC
lyM/EOXoMsNofaZinY0a/J5hUDCNG6pdjZIgpHaspkbfMG7ioieN5OLDDdzjWg/K
EcJ8y2MGBVTC0tMQhFGOykHDBqcKQ2Xhtz76LEmkVEc3ca77gMFIoAbLOYmJFY0W
5tAtkhV53V3nsS8igRATQdgJeTJ+hIZjoRUsLEyOvvXkpcKqCNSrXMimRfRkuTNi
6ZKGwbE/TVRlJQZNGHRxk1Z/4IuY35G+WzQTPyliWcQaySK19JOMHvU5YjrQ1wLE
o7SYcPfEBqIHc6NA0pD+FEHMXUBGyFeqACshyJXfSkphC+apJ1l1hAELKDJV9EEJ
G6WMTi3FB1uhjzRroQqK6dKJSRNtXBJz1HTHb+H5UvxGFaPE1JMQwgUIHSbSRXbG
N/5WRAgofTNdegV8eSCFoZ+tc0ZR9gIhFvygEG4tUYGMnBgkP4V/7Fug1CPXhKFN
x6Lu5OtT0RUXDOvstp3u94bn1KY9bCgOQ+DP5jVDIJdu7cr7CaOo5araAB+zvf/p
24v/2JKyfm1xSpz1Jtkg/yc+sajMPxGHdxBC9btEk/qZGPjrgtARHjoAdf2TPpNt
wDFvgqVqO8QlF6mJy2deT8A/lYH3E5D6oJaBs/mubVy+lA3HInN2E/g4jyqcdVfI
gywAdrB3KPjwdAlHfTOW
=wfVO
-----END PGP SIGNATURE-----

--wK9ofX8hCv5joAUVvu2AI0x2nX82X1TqS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
