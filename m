From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Thu, 28 Apr 2016 22:09:15 -0400
Message-ID: <5722C24B.6020108@redhat.com>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me> <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X9oxUBsHDjf15hnCTLVLqAw5nC8A0b5jH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X9oxUBsHDjf15hnCTLVLqAw5nC8A0b5jH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/28/2016 10:01 AM, Or Gerlitz wrote:
> On Thu, Apr 28, 2016 at 2:56 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
>> On Thu, Apr 28, 2016 at 02:17:29PM +0300, Sagi Grimberg wrote:
>=20
>>> FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
>>> some patches to contribute for it.
>>
>> We are planning on submitting it in very near future.
>=20
> So.. lets get this going, Linus made a comment [1] that we might not
> go up even till rc7, which means there very little time left, Moni?
>=20
> On a related note, is there ANY patch merged for 4.7? Doug, are we
> again going to have have it in
> all-patches-merged-on-the-same-night-10-days-after-the-merge-window-ope=
ned
> manner?

I have topic branches started.  The generic RDMA READ/WRITE API is
almost ready to go once Christoph answers the last few things.  That's
really the only one in queue right now that's big in terms of core
changes, most of the rest of the stuff is all driver or ULP specific.
The RSS patches haven't got much review yet.  The SELinux patches are in
RFC stage, and IMO should be shelved until verbs 2.0 API is settled so
we only have one API to apply it too,  There doesn't appear to be too
much else on the list that would likely effect anyone's patch submissions=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--X9oxUBsHDjf15hnCTLVLqAw5nC8A0b5jH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIsJLAAoJELgmozMOVy/dujIP/iTiW2+j76+TulmrfYeEV/7w
U1/91p2VoYk5MjAdgR0mbqA7wK+N9XeNNuQfn42QjILf/cv6YlV6nlKZ7hpPBzkx
/xtyYP+MQX38s1vCDQrG3xGzsk+ufkHbzxW0HWE/+rGz7GWKW4owCrzF1SQM10Sd
RsKrOjNPjdyDFXjSuOQvFFnXJvXPR67huLLOzE3rd7VbdQeaX+Y/zDLFIq2C393a
mc8ZOf/FHlb51rAkExCYuNsg4xQSm4TscAlwgSZAcQsGl7AEXc/Xv2iqqlUzE8Db
VpOEhR0XUhYCixgtCp2nGVOSvoRg7oiczpyNd7kMLLJe64jXgBjRNPIzvsNota4a
DVh5UvUuac7DdZNlRRsGTJjuscWtENC4hltjCYD+DKuscrfxIknhVgA7OdI6W7mN
z3HedvYopxU20B2N2ijGYv9XJ7ioX/i5YYAKwNX5X+LXOdUU0p+0l/foNzzhZkq4
wUS5CQdj5l1WgtDv0lmgjhGGukgWZN43I/NOKdTgLzccBSzIsLka76FiBrReVztQ
CQ5u7Bs58mphiw3WsAJu920JUm2EBwgNbgDB9W8b74LpemS1hg24cAIZldyuikMq
PPXX5gTOpXAr6pgbnaJ0UPHrrVKZKAUcHovr1R5TAVBfCIKzt+aZaHKX2uD3Z9XW
fwnLIJYUTB1L9TrLyVX0
=lJ/H
-----END PGP SIGNATURE-----

--X9oxUBsHDjf15hnCTLVLqAw5nC8A0b5jH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
