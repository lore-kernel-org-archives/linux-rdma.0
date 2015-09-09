From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 8 Sep 2015 23:19:25 -0400
Message-ID: <55EFA53D.6040509@redhat.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
 <55EF9E82.70405@redhat.com>
 <CA+55aFytfSV5YqzUrZxBjAgnUn72WoJVHnaB14k5MKLkw-YnLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AtPk1LtHNwtkb2c1FFSVKuVJGoC9hoLqu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFytfSV5YqzUrZxBjAgnUn72WoJVHnaB14k5MKLkw-YnLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AtPk1LtHNwtkb2c1FFSVKuVJGoC9hoLqu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/08/2015 11:08 PM, Linus Torvalds wrote:
> On Tue, Sep 8, 2015 at 7:50 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>>
>> Because the tree isn't buildable, let alone testable, without it.
>=20
> You're missing the ENTIRE POINT.
>=20
>> Well, I expected it to be handled without much effort on your part and=

>> the existing network infrastructure to be the final version.
>=20
> There is indeed not much effort - I'd be throwing that commit away
> entirely in favor of the right one.
>=20
>> Is further explanation necessary, or have I answered your questions?
>=20
> Further explanation is necessary.
>=20
> Why did you rebase this thing?

As mentioned in my other email, Stephen is pointing at my github repo.
I had topic branches and a merge branch.  There were various fixups that
happened during the devel window, and multiple times I rebased the merge
branch when topic branches had fixes.  I made it very clear to people
when I set up the two repos that one was for official use, and one is a
WIP development repo that grants people early access but not a picture
of the final product.  I was not aware that Stephen was pointing at my
github repo until this.

> And since you *did* rebase it, why did you still take the broken versio=
n?

As I mentioned in my other email, I could have replaced it and I didn't.
 I didn't think it mattered, so I didn't.

> Why did you take a different commit than the networking people did in
> the first place?

I wasn't aware of the other one until Stephen notified me.

> Why did two different people at Mellanox write clearly different
> versions of the exact same thing? Don't tell me they didn't talk to
> each other - it's the exact same thing done at around the same time,
> and for the same reasons, just done with entirely different structure
> names and structure contents.

I can't speak to Mellanox's actions.

> Why did you make networking changes without talking to the networking p=
eople?

I had no intention of doing so.  I had it in my tree, but I wouldn't
have pushed it without the networking people's approval.  The
notification from Stephen rendered that approval moot so I didn't pursue
it further.

> The whole thing is one big mystery. And the problem is not how to
> merge this, but why this kind of crap happened, and why something as
> simple as "talk to the networking maintainer" didn't happen.
>=20
>                     Linus
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--AtPk1LtHNwtkb2c1FFSVKuVJGoC9hoLqu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV76U9AAoJELgmozMOVy/d5KQP/1ZRSULo1ZUFe9GUHicKLE2e
Rugkn8FY6qnXhzfTkGfgRv8kYRDSLUzr356i0XqAKTdJvZ7YMOGdAo18oh6X1HrU
UDknKI2cUOYd5C+VC0tbGzwmbDB5P3WuvEjyqUZ2nWyV8ZDezVVzzfwIFkKiUdaJ
1j6hyXfmIY3rMcig32/su7UUaTlzVmMBy7vMY4tCv/7WEtpAM3ntW3duz97MC0B4
J3nrgsBdPQvZbujJ0+Fo5KolMwetSKW8aK4sF7uLS46eoan4w+405wktfAvgMy8m
VVDgEzzuqb0i40xZiL+DM4opn7dDEmCEaRhF/oGGwjfFvREjosmCwpiwM36/60yF
umWy+tn7jgTasoy289QVK3O9HxzM2AMpkqA7ftcrFcLyQY59GxOlXLMJPDU0xMmP
muRV1n1zj10thP7S3drNCTnqiMhxHmKgzYjOXQdFick1Jw6b0l+Pw0E+BbLdbiwp
ZXx98Uep3n4OneZm48NLA7xlze2UuGua0Qt+t9LSwFOa4/fpodwHzkUOuNwJlG7C
eRlffnUl4Aw0+SezosOz6+flHDo1EYDCTXM1NL6X6Om2rR+AEoaml+7aqpJccm2y
nYYtdW16UyEkFQ/uUCjIiYwDZ7d9zrFDW7hcXkl4IR6pSsOqXhLD1MaqvGiF2Iya
3mIQhXJMxsW8dTkEdgSb
=qrmr
-----END PGP SIGNATURE-----

--AtPk1LtHNwtkb2c1FFSVKuVJGoC9hoLqu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
