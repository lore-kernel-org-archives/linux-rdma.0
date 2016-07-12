From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Any progress on horrible IPoIB perf with kernel 4.5+?
Date: Tue, 12 Jul 2016 10:25:25 -0400
Message-ID: <447685d8-1380-2a57-dc83-88b3871fee3f@redhat.com>
References: <CAL1RGDXC7JsBN_DS_iqiywKP3GikgAgXm3OK-cZ02tmVctQJQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fExPd6Mra78HM2owwwMskkplf5IVEVf8f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXC7JsBN_DS_iqiywKP3GikgAgXm3OK-cZ02tmVctQJQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fExPd6Mra78HM2owwwMskkplf5IVEVf8f
Content-Type: multipart/mixed; boundary="8rfjGCW0BIripubedboMFc7W59fi80tnr"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <447685d8-1380-2a57-dc83-88b3871fee3f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Any progress on horrible IPoIB perf with kernel 4.5+?
References: <CAL1RGDXC7JsBN_DS_iqiywKP3GikgAgXm3OK-cZ02tmVctQJQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAL1RGDXC7JsBN_DS_iqiywKP3GikgAgXm3OK-cZ02tmVctQJQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--8rfjGCW0BIripubedboMFc7W59fi80tnr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 7/6/2016 1:09 PM, Roland Dreier wrote:
> Hi,
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D111921 describes a
> performance regression introduced by commit 9207f9d45b0a ("net:
> preserve IP control block during GSO segmentation").  I've recently
> run into this when updating my system, since that commit hit stable
> kernel 4.4.y =E2=80=94 in my case I noticed because scp over an IPoIB l=
ink
> went from ~200 MB/sec down to below 1 MB/sec.  I confirmed that
> reverting that change did fix my performance.
>=20
> Obviously just reverting that commit isn't the right answer, since I
> believe the patch description that says the commit fixes a crash.
> However before I start working on this myself, I want to make sure I'm
> not duplicating anyone else's work.  Doug, you mentioned having time
> to work on it back in May =E2=80=94 did you figure anything out?  Or is=
 anyone
> else investigating this?
>=20
> Thanks,
>   Roland
>=20

I *just* came back from PTO.  I'm still working through my email (where
I saw your writeup of this issue).  I didn't get very far with the issue
back in May, but that's because I didn't have a lot of the background
information you supplied in the other thread and didn't have the time to
dig it out on my own.  I could probably make some progress now.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--8rfjGCW0BIripubedboMFc7W59fi80tnr--

--fExPd6Mra78HM2owwwMskkplf5IVEVf8f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhP3VAAoJELgmozMOVy/dBSoP/A6NY8bhE7sjsMLDZgnmZbWf
FW97dUE9mx+U1K1QVDdiEbGyLDUrk31iKwG5fimR+0aXqoqxcHE9ha4Fal1k6J5o
WvVX8e35uykeR6h8oyQ4C9Cum/KWKq1+3hXr34w1xsALmkL0QMfPt8eJFBPvnAD2
a/D7sx+sq+cWu+deDEWvGIWHlaCKYlofl01JhgCTswGeA7DdCKbuDoBsheWCFPjc
ZK9JwFCl/LncW5DoBrvJMynTElfA9yyCesAyQj+h0NDv6zF/lCulC+/hScy2vesS
XTHekIyOQJyf4bnyInF7oSEC0pHLCFp/l634WNPT6KZgFChlYLUytYrteQgyRcwC
/GgZgs5hJtl3ici2ZVeF3K+IAdYNxmx4dWTYUgySBojwWOEYd9IzgSX72zqOsAKp
HM0O1iQgbOusI7ZbJJ5VclTdxRnhUtYCI799Cl6W0QjSl4FnsYAHIxbzvG1OkTj5
q9UmWOkXOScWlS4mG04MEQh+hB+Bk66HNV5hBy6n4tmRRgg690Gsy7RHO9eh6lrt
aB4LWELLavn34ZEn+WYTaQcH534hr1VrSLyT+lIf1lk05ODOJ+Dow4+9Ip9ByX4c
WQMkPyYtnmA9IAvAShSX0cUGaC+sTpvhrEKaPqf0MKbTK4mqLhIOz5c3E+GOIkFj
qZkLHINmV+RJNSNsHMiM
=oaEv
-----END PGP SIGNATURE-----

--fExPd6Mra78HM2owwwMskkplf5IVEVf8f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
