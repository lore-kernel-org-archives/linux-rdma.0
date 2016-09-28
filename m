From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Towards qedr patch series
Date: Wed, 28 Sep 2016 15:38:46 -0400
Message-ID: <57EC1C46.6070502@redhat.com>
References: <DM3PR07MB2201E202E535C987EEAA3BFDF8CA0@DM3PR07MB2201.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="e8TSD6AQXA9f6BRvtmq4g5BKeGeIA73Xt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DM3PR07MB2201E202E535C987EEAA3BFDF8CA0-jBX7zO+Db/wI9Q/2ysJlLeFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amrani Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Elior Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Kalderon Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Mintz Yuval <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Borundia Rajesh <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e8TSD6AQXA9f6BRvtmq4g5BKeGeIA73Xt
Content-Type: multipart/mixed; boundary="LVImBw7WXfXifeuG9uCSLJTulJsUTu6E0";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Amrani Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Elior Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 Kalderon Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 Mintz Yuval <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 Borundia Rajesh <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <57EC1C46.6070502-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Towards qedr patch series
References: <DM3PR07MB2201E202E535C987EEAA3BFDF8CA0-jBX7zO+Db/wI9Q/2ysJlLeFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <DM3PR07MB2201E202E535C987EEAA3BFDF8CA0-jBX7zO+Db/wI9Q/2ysJlLeFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--LVImBw7WXfXifeuG9uCSLJTulJsUTu6E0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/25/16 1:39 AM, Amrani, Ram wrote:
> Hi Doug,
> We will release qedr RFC v3 this week that will address all of the comm=
ents received on v1 and v2. Following this RFC we would like to generate =
a patch series.
> Note that the RFC contains patches to qed and qede that are maintained =
in netdev so the submission may be affected by netdev activity.
> Currently the RFC is based on netdev's net-next but we can rebase again=
st your git (git://github.com/dledford/linux.git).
>=20
> What guidelines should we follow with this submission?
> What is the time frame to make it into kernel 4.9?

There are currently 5 (5!!!) entirely new drivers that people want to
get merged.  Reviewing those monstrous beasts is a nightmare.  The
chances that I will get to yours for 4.9 are slim at best.

However, on the off chance that I might get to it, base the qed patches
against Dave's net-next (up until the merge window opens, then base it
on his net tree as that's what will get merged).  The qedr patches
should be based on my current k.o/for-4.9 branch off of k.o.  When you
submit any patches, I would suggest doing it in two separate submissions
(if possible).  One that is just the preparatory qed patches.  They
should be sent to netdev@ and linux-rdma@.  The submission should note
that they are intended to be taken with the qedr driver.  If netdev@
reviews/acks the series, then Dave can let me know if he wants me to
take the series and keep with with the remaining qedr series, or if he
wants to take them himself and I just make sure my pull request of the
qedr patches goes to Linus after his.  The second set would obviously be
the new qedr driver.  It need not go to netdev.  Once it's here, then
it's a matter of the netdev@ people signing off on the qed series
changes, me signing off on the qedr changes, then it can go in.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--LVImBw7WXfXifeuG9uCSLJTulJsUTu6E0--

--e8TSD6AQXA9f6BRvtmq4g5BKeGeIA73Xt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7BxGAAoJELgmozMOVy/dLoMP/iIJfXsJOwr3cm9KnelXbyj0
RFULTGB45+3wsRb35K8el542kCglv4uuLlcT402dn4JTUYvBx2/WtaL/kS+hMx7V
H/EcmT4p6tMj9cPAfCUIWTK1V+vMJ9smfbfi25KFX0zKQUiSSQB2zQmpqxctNrkW
DTB5CjvjVhHrb2u2Le323GeI13RQoJyU65TVq/w1aNqZLsXPJxkLnzm9dS0hbiOb
NJnLZiw1Fpjt1icxGGahNxEz3E9aeqhOtDzpeJmzrjAkvj2kCAEkIyu8PJbQqH+L
evryVFX870TYZ6PLaydY12oYGdIqpHx4/66MiDs7KlarNO1G4FnHPTx9Gvx3y07k
MsePP6iwtzV0+1YaH8iNZAhfLAgsnBPTKGEZTDMsJAqLs1gjOwtATQ2KLTyV11s+
SGzQ7nD7N8o19MgvOGT+n3W2vviVpo7LTm76PseRYOArtZ3xJYUtcjU9KuZGNnoV
TyudQEySaDy/WImruOqKD+iBtFunxJ9F7rxohoxqySYc9U9/2orgLTXufrj9+8Qt
x/HJ0ZgJWLaQ6S87L4YbU74mw05ACFD1P+b3pv804iG9Crj/J73FCNYCaCydg279
KAbO65YtGT2hCxd1v6ddT8LI8wXeiOqyYpSOl7Y11gxfjhe3KtO1AXmOD6u6h3gO
QeDrBJ7AVFiCmgqC26CC
=Fmnn
-----END PGP SIGNATURE-----

--e8TSD6AQXA9f6BRvtmq4g5BKeGeIA73Xt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
