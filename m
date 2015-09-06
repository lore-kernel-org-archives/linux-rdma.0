From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Sat, 5 Sep 2015 18:09:53 -0700
Message-ID: <11BD05DC-12E6-47E0-BBBF-71482E503F1D@redhat.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com> <55EA2CA7.8000702@redhat.com> <CAJ3xEMiyZSu4DuNhHtcwJRwTnDXS4+Dw+SXYw=LhhphUMA__Ew@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_89943C7B-E138-4E0B-8A34-BB5675774A1B"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiyZSu4DuNhHtcwJRwTnDXS4+Dw+SXYw=LhhphUMA__Ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_89943C7B-E138-4E0B-8A34-BB5675774A1B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Sep 5, 2015, at 1:27 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Sat, Sep 5, 2015 at 2:43 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> Series applied, thanks.
>=20
> Doug, a user-space related note, in LPC you made a comment that the
> user space RoCE UD patches are broken with libnl3, well, talking to
> Matan, he said this is indeed the case with the RHEL provided libnl3
> but not with the upstream nl3 -- I would not consider this RHEL
> related issue to be a gating factor for picking the patches, thoughts?

It wasn=E2=80=99t going to be a gating factor anyway.  The original =
patches went through a review process already (that=E2=80=99s why libnl3 =
support was added in the first place, a review comment).  I=E2=80=99ve =
already applied those original, reviewed patches.  If it turned out that =
libnl3 in upstream support had been broken, that would have been a fix =
patch.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_89943C7B-E138-4E0B-8A34-BB5675774A1B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJV65JiAAoJELgmozMOVy/dcuYP/iDQFpxhr+3gFRNBVhzUVH2C
cKiwXmsxAWWoScII+J+ssUPi6+lB/CGcet4NcCZO814T68PHdERr9kjG/HtapCJm
MdwooW9aAc47alXiUr2vfU2EvtOUxR2hhTAGuAq33bpVVjXXK+N8rhCKVlN67jka
qez4zFtsK+VLhkgTwW+SoRgATYb4zoEq5bUd7MJLpEf5mjJM1RYLt1h2YgChCJM7
CiBKcgqpG+kRjNePFFCvkLwn8nwh2iUdeEnVfI94huHOVYEaBZ7pOzgz7FNEn5Zg
XiYjx22bn2ynSG2xtgIz80kLTM8hEHqF8UlKxTnoJf9ABs9B28TO1EZlZCQTkOd0
1Bd15rs2Rcl8vEr+WCoArZnYLkBDDOecCn7OranLsAgnKwobQ3YbjAEND54ZCDkw
ytE58EKhR77TaqoUGwFWwF4HCIvI+zUM+tey9bK6xniNOUfv4xCSFLQMFVEvMUr1
Dko/U0rQJM/U8A8i8iNNJo+No6K71pSnhKX+3JbxD9PBf2yyJ+sedLTsXRuyiX7m
NWQLERlAjUM9YFUnFCY9ovOqGSwxm3MeXUqdyO01K3wufrOiTad2hSQdX1VDWaTZ
xdtILwH8TRTZMKqsrz+8ZI7u7NsaIZnwDT+0RH7GXfVIbhGsXOC4ZvfDhB8OW110
TQb7jhiH0Rwu0M+fYy0t
=B3H5
-----END PGP SIGNATURE-----

--Apple-Mail=_89943C7B-E138-4E0B-8A34-BB5675774A1B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
