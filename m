From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Date: Sat, 8 Oct 2011 10:28:14 +1100
Message-ID: <20111008102814.ca235496f72423e215cbe8ac@canb.auug.org.au>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
	<4E8F683D.9020604@xenotime.net>
	<CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
	<4E8F77B8.3000805@xenotime.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E8F77B8.3000805-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 07 Oct 2011 15:05:44 -0700 Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org> wrot=
e:
>
> On 10/07/11 14:21, Roland Dreier wrote:
> > On Fri, Oct 7, 2011 at 1:59 PM, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org> wro=
te:
> >> Add <linux/stat.h> to fix build errors:
> >=20
> > When did this break?  I build ipath in my test config all the time...
>=20
> First I saw it was in today's linux-next (20111007).

Its probably associated with the module.h split up.  But see Rule 1 in
Documentation/SubmitChecklist.  Implicit inclusion of files can easily
break when built for a different architecture or config ...

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOj4sOAAoJEECxmPOUX5FE+bEP/05mdE6nFwRFEStsN6b8k8YT
W6DoQptlHRBFjoDjk5KDYwIIWL4lsoG46GEiRO4xoNuZAVGKK8cIr0DuzfHNoNDT
PHf/pcaIril0MZJa9bZ/XrEeEaPU/aLY7Cp90xKsST/b2eejgR4sZhg7YUbx5/6W
xzTxFQbgjHxrtZ+SPQkVVNfX3jGqKkvwldRMY7O/KrZZzkmZcOTQi6Vtf9SJzmDf
eNpdCn1fwwpHaywC/6zC06GUKt+gn491hAm1jMFR8mnPSjEEq43FN3LhapzmTK4x
N/LPTO32rI1wuAyM71qp+g0qsjtlAlupbC92IXjPoGJBW+TCqC4uXRMRBmZTyd2J
ww1B2pT70OKLeVYS8aIuoMLHNaI5JS95dwnEZGy838Hb03rJS8KMpNVxLjQpF22j
lACqbaU/AF65F7U0cZh5eZ97xtnjD0qDvDGbh5OC1YDh4MHOS9DAqCF1n4sqJQ3b
3pLFk9S227StGa0GS4e5gwXlsknVZ7FHMMmltmf7TJ9898BKrXDul8k5VJX70U8s
+DM2C76/TmlaO8QFiloJHGLMabSmRs1rhhZ7MUUEBCCML/Hn4RsfXqmWj8waEcax
Gq4WP5ybNXvY4mTdTZEJOU/8arI9A1hyOdel1w1YfJ0qI5z3zQ2aoe+CZi638/52
NcElVmkX7w7lnCLf0G7t
=80ES
-----END PGP SIGNATURE-----

--Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
