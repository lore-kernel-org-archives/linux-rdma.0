From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Sun, 13 May 2018 16:10:04 +0300
Message-ID: <20180513131004.GD10381@mtr-leonro.mtl.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
 <06375fd7-f241-74ad-70ce-a670100bf060@gmail.com>
 <e94d0444-fcda-3a62-3b12-3b9e6ff23119@opengridcomputing.com>
 <06d8cb88-21e0-b7cc-10e2-efa453d9adc9@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <06d8cb88-21e0-b7cc-10e2-efa453d9adc9@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Steve Wise <swise@opengridcomputing.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 10, 2018 at 08:20:51AM -0600, David Ahern wrote:
> On 5/10/18 8:19 AM, Steve Wise wrote:
> >
> > On 5/9/2018 11:08 PM, David Ahern wrote:
> >> On 5/7/18 9:53 AM, Steve Wise wrote:
> >>> @@ -152,7 +153,10 @@ int main(int argc, char **argv)
> >>>  			pretty_output =3D true;
> >>>  			break;
> >>>  		case 'd':
> >>> -			show_details =3D true;
> >>> +			if (show_details)
> >>> +				show_driver_details =3D true;
> >>> +			else
> >>> +				show_details =3D true;
> >>>  			break;
> >>>  		case 'j':
> >>>  			json_output =3D true;
> >> The above change should be reflected in the man page.
> >
> > I did mention it in the man page:
> >
> > =A0=A0=A0=A0=A0=A0 -d, --details
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Output detailed information.=A0=
 Adding a second -d includes
> > driver-specific details.
> >
> > But I wasn't sure how to show it in the syntax.=A0 Maybe this?
> >
> > =A0OPTIONS :=3D { -V[ersion] | -d[etails] [-d[etails]] } -j[son] } -p[r=
etty] }
>
> I should have read the second patch before commenting. Didn't it have
> first -d =3D details, a second -d =3D driver details? That should be fine.

Yes, our idea is to require "-dd" to print such driver specific
information. The level of nesting is:
 * No arguments -> info usable for most of the users
 * -d - pre-parsed flags and rarely used information.
 * -dd - very detailed output, can be very specific to device.

Thanks

>
> >
> >
> >> Also, the set needs to be respun after I merged master where Stephen
> >> brought in updates to the uapi files.
> >
> > Will do.=A0 Thanks for reviewing.
> >
> > Steve.
> >
>

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJa+DksAAoJEORje4g2clinKXYQAIWuKaPakq0E8SHa/YkWLhNp
CVEEw9uWvd0X6tDRb5H5a/Le9W5UX46HsyQwX9RK0C+DtFcp4VQJ4aXhrU+qnBk/
5aJowT5m6fzwvoE/rEtHdvVvQ1TQ4s/5F3bpFX0OyhRO0/u+sQSzLftNEndJ1w13
sVGYfc4UzzawH6pa1pAIxiSGdTVBuD+eCLq/NOYspvSfS3ARY3ZnXO0g8jCMsNdT
JTDa6VBIVEzclwt5HDf0UDfLp2w0qldjlInvAsno+uIXKC0+TKPBpBnPEOvSbi9D
LxKyPy7ClG84eeZLkOY950rTQ4/FYAti4KMoMFUNQHGTaIutFCwIntnSX7j6YyCS
79smxarq9+YZY7T5ilW4dlWmDpunEmVemosCaAKtP5TkerR6uLRrG0lV7bR/Edz7
cDdwrng0Id/y91gXYX87Zc8ds6q1S8x96GJzpHuJ3rr7AxcUgUeozzRw+3kpcfaa
vWkqEWSZUhTcHP/xaR2vf+2S5PJKWfpYfYOTWX4RH7XUUEEWsIaeTaA96XrVhl6D
jlj981vNj/gJOof6rOMrU+fPPrsEHC6xbJJ/D8kHqRqlX3tTOrZ+Y28Ws53lbCDA
JrB/dr97qKI4eLumfBRtjr4CIzcK+2QiMffYcXksHvw4tpOec8hzD6QgWGf/fzBf
9InghZ487HGLapJZyE9w
=HrWr
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
