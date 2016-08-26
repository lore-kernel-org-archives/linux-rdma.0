From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/hfi1: Clean up type used and casting
Date: Fri, 26 Aug 2016 10:26:00 -0400
Message-ID: <85f3dd00-e31c-7180-e695-b30872f60dc8@redhat.com>
References: <1472186965-9103-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DBDLL8I9QPDxiNKNnA7KBtKKPPsdR7G5o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472186965-9103-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DBDLL8I9QPDxiNKNnA7KBtKKPPsdR7G5o
Content-Type: multipart/mixed; boundary="jsLekS91JVcXnIfhqjhwjsSiBdI1V60tv"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>,
 mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <85f3dd00-e31c-7180-e695-b30872f60dc8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/hfi1: Clean up type used and casting
References: <1472186965-9103-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
In-Reply-To: <1472186965-9103-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>

--jsLekS91JVcXnIfhqjhwjsSiBdI1V60tv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
> In all other places in this file where 'find_first_bit' is called,
> port_num is defined as a 'u8' and no casting is done.
>=20
> Do the same here in order to be more consistent.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jsLekS91JVcXnIfhqjhwjsSiBdI1V60tv--

--DBDLL8I9QPDxiNKNnA7KBtKKPPsdR7G5o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXwFF4AAoJELgmozMOVy/dFWoP/RbwKAl9qslVI2hvEfXGx6Tp
xWZ67sFPfaFDbSCrwPGRYGHVzF3j0p5y+OaiE+MF5GTAagkmyFG2+tO+dhuHRb3d
cEZOmqS/iQ2S//lABIF8CCmk02mUBHNtBem0SArL/rMbeHjvqYyqgqO2TrPRyUBl
Mfz46dwIjrd5BZyPs7yJ+TCAU+nVC9LFp8TlWjhllW8pWAq5371nIc1yvxiCbeuD
6ffOwo+tqB7iVt9vydkVfqxD/Ii37ukZElVeCB7MQs6YkgKi6Es//QhWEDKvVq13
hbV/NJWU71yOhRdHT0F7gbs8mlYLJiFiJ+jhGnTTpH/o7EBXGfaaq+pDQb8nLWg5
0NTErLTJSAkupVRLrIpo+u8RI9xrXR64NYZSRI8m0pZvb5Vb2kj4VlN3KTZG5+a7
LF6pHWe9oEzUG+Cwjr7A8VviGdxyNYnZ4D6CVn5YXvvLzrhHJgIsXw6m3iA7Wa5B
a2DDQUMfzjHSE1PytgpPz+IhwxkZgrwyRlUDzLlEQlSxk1VTDoFIiIeYcqw+RWed
UgYJhmFGmRW57whk2zg9P4nH0tICaSxb6JLkDfd/218ucQDEVxIK4xhnqDO7iqRM
W81AhoS2dOh9QRC0CeS7Q4vqfHTin+JbtFXi8g6j3X7TGaB3N8uWapobLKraiLXY
07rwMDMuL5bo7CpkLOyv
=pYez
-----END PGP SIGNATURE-----

--DBDLL8I9QPDxiNKNnA7KBtKKPPsdR7G5o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
