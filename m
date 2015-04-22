From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/2] IB/qib: add acounting for MTRR
Date: Wed, 22 Apr 2015 09:44:52 -0400
Message-ID: <1429710292.45956.90.camel@redhat.com>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
	 <1429653035-19424-2-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iyrmDJJjJxcuGNfUbvVl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429653035-19424-2-git-send-email-mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-iyrmDJJjJxcuGNfUbvVl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-04-21 at 14:50 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
>=20
> There is no good reason not to, we eventually delete it as well.
>=20
> Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
> Cc: Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
> Cc: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>
> Cc: Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
> Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_wc_x86_64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infiniba=
nd/hw/qib/qib_wc_x86_64.c
> index 81b225f..fe0850a 100644
> --- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> +++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> @@ -118,7 +118,7 @@ int qib_enable_wc(struct qib_devdata *dd)
>  	if (!ret) {
>  		int cookie;
> =20
> -		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
> +		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
>  		if (cookie < 0) {
>  			{
>  				qib_devinfo(dd->pcidev,

Skip this patch please.  You remove this line entirely in your next
patch, so this becomes a single kernel out of all possible bisectable
kernels with this accounting enabled, and then the very next kernel does
away with it.  It makes no sense to have a single outlying bisectable
kernel like that.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-iyrmDJJjJxcuGNfUbvVl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN6XUAAoJELgmozMOVy/dF50P/3fEarbr3zOYgk2nMDPTjZxD
TJReriROsYgn+qMUSEu6V8R4L6sDYSNSN7oDg/w7CJQ83k1BTRkCTyEYr44VDl7X
Jje3r/KjudEnTiFWHVjTs8of9sJJp9+fUwN5xe+L5aMhHyYb068/TEshCpIJ1dWt
2rdRRziNlwSh/dOvFl+cKG8k7WFTFx8Op0or0mo56fXhRi2HqTqnHWVbNdfJFgk8
DHALk8GHYj1qu92QXgUG1n23OwF418eI9uC9IWRx6DLe1paxT+doFXtHOJM0jwkj
TeRZP2BxurEEJ13GDh02tEPtlSAIqCsC3ZotRubyERrd2vAF663sxM2sZU/TBVM2
UYFldyxqE08eXPT1H/U/6ug8wzwQmTYAAUE6d4RYsIVaNVkDGIJ3/HsRnvRUNt2N
vKU++aNFN8w8l+90PNejAEaOfhSwcJaJ+f43b3EGxHXvyqI2jlSSbnxhUlV0X+Ee
lHKxc3IM6qsyZQGBTf3UsoNywMKq5vBN6nANi7Tcz3GA5qpTnM8w2AKzWAMKNEO7
+MjayrXfOtJfxs7jYQErkSCMw1TfTINCFI1/rhuBIdtFvROwR2Ay/qi3WMtPfd09
YxY/tH95GMQ+u21nazUYQTVQ+VEf6ncFLZMF28+AHMJRrspWHhtSUH01XC7bYa95
tIK3QrjJZFUWuJSa7uo1
=DjtJ
-----END PGP SIGNATURE-----

--=-iyrmDJJjJxcuGNfUbvVl--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
