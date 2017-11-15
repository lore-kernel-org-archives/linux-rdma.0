From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] buildlib: run ABI check in travis-build
Date: Wed, 15 Nov 2017 19:34:53 +0200
Message-ID: <20171115173453.GB18825@mtr-leonro.local>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <866df5d4-2a54-2014-a180-1fd0dc43d0fa@suse.de>
 <20171115055825.GS18825@mtr-leonro.local>
 <a6eadf81-1557-bf9c-c163-61461bc5c271@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ekqtLoxs2mG9vme/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a6eadf81-1557-bf9c-c163-61461bc5c271-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ekqtLoxs2mG9vme/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 15, 2017 at 06:24:32PM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 15/11/2017 =E0 06:58, Leon Romanovsky a =E9crit=A0:
> > On Tue, Nov 14, 2017 at 07:58:06PM +0100, Nicolas Morey-Chaisemartin wr=
ote:
> >> Run travis-checkabi during travis build
> >>
> >> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
> >> Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
> >> ---
> >>  buildlib/travis-build | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/buildlib/travis-build b/buildlib/travis-build
> >> index bf86baa7..f8e5ee05 100755
> >> --- a/buildlib/travis-build
> >> +++ b/buildlib/travis-build
> >> @@ -5,6 +5,10 @@ set -e
> >>  # Echo all commands to Travis log
> >>  set -x
> >>
> >> +
> >> +# Build in debug mode and check the ABI against the ref
> >> +./buildlib/travis-checkabi
> > Will it run for all commits, including master?
>
> Yes and no.
> The script is called for all commits. But one of the first thing it does =
is checking that reference file exists and ignore if they don't (see Patch =
3):
>
> +# No reference ABI to match against.
> +if [ ! -d $REF_DIR ]; then
> +	echo "INFO: Skipping ABI check. No reference available"
> +	exit 0
> +fi
> +
>
> It might be worth doing this test first in the script to avoid the debug =
build / abi-dumper calls.

Yes, please.

Thanks

>
>

--ekqtLoxs2mG9vme/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloMer0ACgkQ5GN7iDZy
WKfLrg/+JvJ3jHXvwvSe9qswSLba0U3rUja3FTYKO8fximQzmR6WvDg6DhOQrFbq
IYW3YWnngZxwPgyDW1gmRy526p+48cwWzhyBX2iIw4NkkjOjm8Vajuv2E3REjWSP
OPECmmT8rd5TL4BTCJuKzjQs5JSpVB8oyC4yl1/T9N82Bkg75Jjn+96+Rrsz6xYU
3bqgFnkBtLGu7ZDv68Cy4tEOLhupJAVPPHlQECAaNA25+q3BBpRMlwHwGrVr3YEw
McLt4l8exTyhqld5v3BHObi9gv71x/ZKHvpeyEnZfkChim/6tOuDuUtCwc5kO9zU
O3o9rpb0rG9D7PwvC2Z7rsH/etjiPd7SCjYRR0nqor3hcOW7V1jdy0O+R879dvLo
kSOj9kHs16kc8nbvHO4XU1O+8IPvrdgMacNAbH2AMWFhq0xRyNAPvE7Svuvf77BN
aPtnNlFdnl/1oSEGupdp/r8ckFvVSrwyS7zJtCRoR2JfTPmwIAqL8V5tTwYj1+aR
VpQtYW+UrYdVakr+xx7+b4HgY3qH8KCYiYqsc+fjauknTemtxa0JaXAh1yZq5KyF
Qtd1cp4OuO+LPHg85lZWYlf8MdfKabm1hHpBGqKqQ7ChWFy72mP9CHdKzdChYHoW
plkyMukWwazEKpODGKjrlSiilZ2SeRluyuRlLZZMV6eyrZcN0mA=
=gY56
-----END PGP SIGNATURE-----

--ekqtLoxs2mG9vme/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
