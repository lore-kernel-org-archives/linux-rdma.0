From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Tue, 27 Jan 2015 12:02:10 -0500
Message-ID: <1422378130.2854.119.camel@redhat.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
		 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
		 <1422301106.2854.41.camel@redhat.com>
		 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
	 <1422309605.2854.62.camel@redhat.com> <54C74D49.3080201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-l7ZFSHCyCHQwCc1aJWNm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C74D49.3080201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-l7ZFSHCyCHQwCc1aJWNm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-01-27 at 10:33 +0200, Erez Shitrit wrote:
> The patch I sent, only claims to fix the regression in multicast and=20
> sendonly issues, it can replace the first 3 patches and the one you sent=
=20
> me off list from your last patchset.

OK.  But my patchset resolve those issues too, and as you point out,
it's not really my entire patchset that resolves just this regression.
It would be easy enough to squash just those patches in my patchset
required to solve just this regression down to just one patch if patch
count bothers people (I find that to be a silly thing to be concerned
with, but oh well).

> (probably there are more bugs, that the rest of your patchset solved,=20
> hence it should be tested with the rest of your patchset)

Yes, there are.  But Or has been arguing that we should take your patch
to resolve the regression and leave the rest out.  So, testing that
specific situation seemed to make sense in terms of finding out if that
left us with a kernel that was in reasonable shape.

If we want to look at your patch combined with my patchset in lieu of
the individual patches in mine that perform the same fix, then it would
take some work to merge them as there are differences in assumptions
made and they would not simply work together.

> And probably there are more bugs that your patcheset didn't fix yet -:)
> For example, I run your last patchset+ the last fix you sent me with:
> modprobe -r ib_ipoib; modprobe  ib_ipoib;
> ping6
> some adding/deleting  one child interface and got the next panic:
>=20
> [81209.348259] ib0: join completion for=20
> ff12:601b:ffff:0000:0000:0001:ff43:3bf1 (status -102)
> [81209.408787] BUG: unable to handle kernel NULL pointer dereference at=
=20
> 0000000000000020
> [81209.416750] IP: [<ffffffffa096b399>] ipoib_mcast_join+0xa9/0x1b0=20
> [ib_ipoib]

This looks exactly like the issue solved by 3ee9876fbdb (IB/ipoib: fix
race between mcast_dev_flush and mcast_join).  But without the full logs
I wouldn't know.  However, if it happened while creating/deleting
children then there might be something lurking in the child delete logic
that is not properly locked.

> Doug, there are bugs that probably will be found all the time with any=
=20
> patchset, my point was only according to the way sendonly need to be=20
> handled.

And I proved with my final patchset that sendonly does *not* have to be
handled that way.  I proved that the regression could be solved without
basically reverting the logic to the old split way of handling multicast
joins.

So you've argued several times that "sendonly conceptually should be in
the tx path because at the Ethernet layer we are emulating there is no
join for sendonly traffic, it just goes straight out".  To whit, your
patch restores that behavior.

My argument against is that:

1) We are emulating Ethernet, we are not Ethernet, and we have to have a
sendonly join that Ethernet does not.  Emulating Ethernet does not mean
we should do conceptually silly things in our lower layer driver.  We
must do a sendonly join, which is still a join, and splitting it off
from other joins makes no sense for us at the InfiniBand layer.  And in
fact, once it leaves the ipoib layer and enters the ib_sa layer, the two
code paths completely merge and are absolutely no different.  And at
that layer, they *always* get queued to a work queue and handled later.
So there really is no advantage to doing the send directly in the tx
path once you look beyond the ipoib_multicast.c file itself.

2) Having two code paths that only vary in 2 simple ways
  a) one path uses 1 for the membership type, one uses 4
  b) one attaches a QP at the end, the other does not
but which are otherwise almost identical (and could probably be joined
into a single code path, which is something I'm planning for 3.20) does
not make sense.

3) Fixing oopses and races and other issues with (needlessly) multiple
racing code paths is considerably harder than with fewer code paths.
For the sake of hardening the IPoIB driver against various situations, a
single code path is preferable to multiple code paths.

I haven't heard an argument from you yet that I believe beats the points
I've made above.  So I believe a solution that does not revert back to
having two separate code paths to be maintained is preferable to your
patch.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-l7ZFSHCyCHQwCc1aJWNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUx8SSAAoJELgmozMOVy/dvkwP/jvdNyr/3qKYolpjoRcocgEt
axjDfmutXsgOK5N4c9e8bbybw43lxQ8+uWqrVGCmYxMgy1PbaDbUwwjvIVj08JCo
X+Vln/ZTIIcvypQZ2ExKsjJJAqYkuRXv9JQ0j311SOGccMuVR5kScUDBxxrVbded
eJAJdNJV/p8ybDjeXDKyKyAvYb8UcxOgDFHqL2hlxr1KU3IoYhf8Urh0gR8XEXtb
chCpNPbu1lYxnWQlLS1fjSWeUlPVE63SoP9NKoh5jo2y3szrwZXWNgsx95ydc0fh
uNpHB5XeUnulFblH+5h96paSIOBP4wXmogSUJ4q9B8wtbRuof0Y+GpPzpdvrQ2ea
Nq1R5N/MZQmA6y72jwXFRUEXnH7Nv4S8avjXnWPRtXoEuahOBLrGBv27AyOkgqSn
3e3rbOVzktKZktWjt1IuHO0KlZ8fjAyQofXLxkbfrA1Mf7SugYY3jVP4PKs422IN
0nNiqK8fA77ow0rL1nrug2bh8NBQVNXD6/42FwLcdh4TpyC5lKHdgxBMnV6Wfdr4
MEuQJrLnMeHVCpNDj2DJIFtCt6bChxrNlvufFiVo/9ONfC6lEOVqmAmgZfdgoAyQ
VM2oUMzU3VFgFlSqKj2X9+Nv2uSbTAgd9FI/0pjucKUGocpsxvmUqe6/tOh9ZcA+
SU/QX27C/TjO82u574jT
=ZsTA
-----END PGP SIGNATURE-----

--=-l7ZFSHCyCHQwCc1aJWNm--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
