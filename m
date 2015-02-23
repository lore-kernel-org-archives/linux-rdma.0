From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 9/9] IB/ipoib: drop mcast_mutex usage
Date: Mon, 23 Feb 2015 12:41:13 -0500
Message-ID: <1424713273.4847.9.camel@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
	 <767f4c41779db63ce8c6dbba04b21959aba70ef9.1424562072.git.dledford@redhat.com>
	 <CAJ3xEMgLPF9pCwQDy9QyL9fAERJXJRXN2gBj3nhuXUCcbfCMPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-r7ohWzbHge+DehKDT0S/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgLPF9pCwQDy9QyL9fAERJXJRXN2gBj3nhuXUCcbfCMPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-r7ohWzbHge+DehKDT0S/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-02-23 at 18:56 +0200, Or Gerlitz wrote:
> On Sun, Feb 22, 2015 at 2:27 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > We needed the mcast_mutex when we had to prevent the join completion
> > callback from having the value it stored in mcast->mc overwritten
>=20
> downstream patches of this series (7/9 and 8/9) make pretty much heavy
> usage of the mcast_mutex (e.g add/delete lines that use it), and patch
> 9/9 removes it altogether.. which would be very confusing for
> maintaining purposes. Is there a sane way to avoid that?!

No.  The changes that make dropping the mutex possible are part of patch
7.  Patch 7 changes the semantics of the MCAST_FLAG_BUSY usage, and
fixes some locking bugs, but that's different than wholesale changing of
the locking type.  If you want to preserve bisecability and be able to
test the semantic changes to the FLAG_BUSY usage separate from the
changes to the locking type, then they have to be separated.  So, for
the sake of good engineering practices and separation of distinctly
different types of changes, that locking change should not be folded
into patch 7.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-r7ohWzbHge+DehKDT0S/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU62Y5AAoJELgmozMOVy/dTZ8P/1ydgovqiaMEeaQK9+75AmR5
EVWbxiiwwxgU48gaFouJb4kvRj2jy8Wf6fvtOWqXTv/9QsK1LeI4X0JT9AROmHLn
88ZhgkFwGtgwtveSkvF4Z8h3ZNMHgGyz4HoZrRPJ7inm/F25f80d1zAjJXE0hIXv
XggW0Z+khUUdhMj7e0exPuoLDXECeVnIN4uTleNskKc9sndDQxsYurvAalqI8z5R
Y7mK0lN2VQBjUNGV5TQ/bHg/6c7QnC4PqDuMIgbbo6n2ycGbtcJFBNfFr2wBrQq2
vrDvjdiQziOk7rSfRcD76QB4gu/fS6k//fAV2ZliwVtrVuBOD0e31I17nMsoRVRc
cwPqoC00eGNQ51U0Gb2FXlAiQFa8mB3u9geCoc+3anJ7GAjZGB4rJqjVxR9gqX52
SIVGbG5DCAb/Ddp4BnoeS9gZBBTV4ZcHC3m5Qq2jVLOqYlDECD9uENgFndIjhK2O
0RqbIYnJi/q201J72yQKGhVcyQXwnv6eHfFng37+788FQvnu4LPsxPgMnlokHWx9
aPx34psbWPHn1F0MKJPdpRN1C5vcYLyKN2Vxj5LMo6cY2M+jzhiPjkJNYnzYpg/8
cN53wjbEVHN+qD1UrDShmSkA/5uQv8vXgfjWZA5ula/j1XuSLCUPGDpEwvwj5wiw
7Leqp5EIml3NtbSowaGT
=0eap
-----END PGP SIGNATURE-----

--=-r7ohWzbHge+DehKDT0S/--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
