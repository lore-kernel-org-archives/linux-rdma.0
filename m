From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Problem running rping over Intel adapters
Date: Wed, 03 Oct 2012 18:05:47 -0400
Message-ID: <506CB6BB.10102@redhat.com>
References: <506CB0E9.90201@redhat.com> <1828884A29C6694DAF28B7E6B8A8237346A98E58@FMSMSX151.amr.corp.intel.com> <506CB4D8.4010604@redhat.com> <1828884A29C6694DAF28B7E6B8A8237346A98E8E@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig189EB79AD9146C7E6AEF70F0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A98E8E-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig189EB79AD9146C7E6AEF70F0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/3/2012 6:02 PM, Hefty, Sean wrote:
>>>> 1) rping, on the client side, clears the conn_params for the=20
>>>> newly to be attempted connection, then sets:
>>>>=20
>>>> conn_param.responder_resources =3D 1; conn_param.initiator_depth=20
>>>> =3D 1; conn_param.retry_count =3D 10;
>>>=20
>>>=20
>>>> 2) the qib driver enforces a maximum of 7 for retry_count.  I=20
>>>> don't see anything in the spec that specifies a maximum for=20
>>>> this entry, and in particular I know it doesn't call out for 7=20
>>>> to mean infinite retries like it does for rnr_retry_count.
>>>=20
>>> On IB, retry count is a 3-bit value.  See the CM REQ message.
>>>=20
>>> The kernel rdma cm should probably check for a valid value and=20
>>> reduce it
>> accordingly.
>>=20
>> Then it's also fair to say that right now rping passes a known=20
>> invalid value and needs fixed ;-)
>=20
> For IB, but I wasn't sure about iWarp.  It doesn't look like it's=20
> used there though.

I would hope it's not used on iWARP....it's running over it's
own link layer where this is neither defined nor applicable.

> If not, I'll apply a patch to rping, plus submit a fix for the
> kernel to validate the value.




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig189EB79AD9146C7E6AEF70F0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQbLa7AAoJELgmozMOVy/dPxkP/RQdHjUjOubuYltXUMBRy48u
cXMRoSic8swe0mXmklRvDF3J934u3J5dMkGRkazHbH/D9+iaiNbq9ovjaQU8fqMl
eAXVy4iAnzXh9pQkee3aN5XVcJKXYJ0He2OQSPLN9g028J7E4gqcA95hS+iRbO47
ZX2MYrhKwL1xHhFKoZ45qCibQIG6UP07IJwAmG7R9sCOktC+Y8j7u9T8OEyHbJf5
iYqd5LI8WgXnwHZ9pzm2FUaS1PKYFD0/AwvUxPJIY2mD7s6EtQRaAosYQuWgWcZF
jcq5KhQ00MEpphAFlqS1v2YZC9YgZkChkNsOT1rh9x7fxDNo2/PMioEr7nMh377Z
Ndm4FNiuKjMmmQuNo8ng2xSGg2RK5e95y9VpQKEzyoxvD56bdfYmr2JB/0jMz5ti
I6Tk5Csbo+wlkX0HQfvzqpo+bQVY33WLaCci9rl6ZZ8Sfda566C6GNZaOF+9StOv
EPZBNShTyxdQa7ZgPDdeWueeGBwqueNzAzRoNxVV3MOYD/fCGPe0Q7BgMeamrbp/
beCbzf50IeMe7CWOEMHaL3ddTJWXYUVt6a1FJiw/+yFgyYlKa6M4gMUO52Wdk3vr
5DxsOaB0dG6mFFaoEsradOKWayPM7L3hgk6B6LIBh210dAmu7jLZC++t429jgxF6
/MTm7Kyh9qZ9H2u2QrYa
=AFNa
-----END PGP SIGNATURE-----

--------------enig189EB79AD9146C7E6AEF70F0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
