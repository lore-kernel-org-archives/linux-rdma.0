From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Thu, 29 Jan 2015 10:34:37 -0500
Message-ID: <1422545677.2854.260.camel@redhat.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
	 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
	 <1422301106.2854.41.camel@redhat.com>
	 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
	 <1422309605.2854.62.camel@redhat.com> <54C74D49.3080201@dev.mellanox.co.il>
	 <1422378130.2854.119.camel@redhat.com> <54CA2CE0.30107@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Mdv7GZ5xvJoIwsOv9yjn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54CA2CE0.30107-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Mdv7GZ5xvJoIwsOv9yjn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-29 at 14:51 +0200, Or Gerlitz wrote:
> On 1/27/2015 7:02 PM, Doug Ledford wrote:
> > [...]
> > I haven't heard an argument from you yet that I believe beats the point=
s
> > I've made above.  So I believe a solution that does not revert back to
> > having two separate code paths to be maintained is preferable to your p=
atch.
>=20
> Doug,
>=20
> It's not going to work this way.
>=20
> We should 1st and most take a decision what gonna happen with the=20
> 3.19driver

Yes.  And that's what my above comment was about, the 3.19 driver.  My
opinion that I stated then, and I'll reiterate now, is that we should
revert the original 8 or pull in my full patchset.

> and only then restart/resume the multi way/arguments discussion, and we=
=20
> have
> very little time for 3.20-rc1too, BTW.
>=20
> So lets close the 3.19 saga, again, either revert your eight patches

I would support that option.

>  or=20
> apply Erez's patch.

I disagree with this option.  You've chosen one regression to highlight,
but ignored other regressions, and Erez's patch by itself does not
address those other regressions.  You can't go picking and choosing
which regressions to highlight and ignore if your rationale for
justification is that we don't allow regressions in releases.
Certainly, failure to unload the module or reboot due to a hand in
ib_sa_unregister_client would be considered a regression too, yes?  But
that isn't addressed by Erez's patchset.

I'm tired of arguing about this Or.  You will not change my mind.
Erez's patch is a bandaid that only solves one particular issue while
ignoring others, it doesn't have half the testing my patchset has, it
doesn't address half the issues mine does, and with it in place there
are still glaring problems left for the end user to suffer through.  As
much as it pains me to admit it, my original patchset had issues that
were pretty severe, and a bandaid *does not do the job*.  It takes some
honest to god stitching to fix that up.  If my much more complete fixup
is "too much, too late", so be it.  We revert the original 8 patches.
But a bandaid on a katana slice doesn't cut it.

> This way or another for 3.20 we can do things right by whatever method=
=20
> we agree on.

Agreed.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-Mdv7GZ5xvJoIwsOv9yjn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUylMNAAoJELgmozMOVy/dfhcQALiGAKlJpwEYhfVnPocWnwwq
xFwAc6MOMmLMUC0Kl+jErW1ImlUDY4JcsZy8WzH7XLIWtQwpocZaMl6/ZbOW+dKG
/0ivSycjDfv0wALJCalyOJ/La7iKkwCv1N2XOwboOayQTbhEa0NP9TrqWF6lVpnx
NfozZn1PYSbL64njvHWd49Tn9JAXmS86rw/IJlaGavkj7tGnoDQMfM1P8WkQRjbL
9c4glelFhdLJycJt+flDCjnqh/fiXOOdvSFY63EiUY9OJeYx3L7axXm7M5b84Evq
MlUoy+/G8uLk+all2g2GdTa6p6UOs8Z8Z7IQb2t2gqwibU91wRRiFtUKTuSkUcuw
/d/dEj2MLOEc8ZHOF52ZMr2b7u8TvlfWh/QlX+IZOSKRtfWJHbD0/7qr+KZfUMDg
1yYdJnRqPXuGNO7ntS2U6cj9AvOZy7a9c1jIBegHTxW5GeHcTh5jwPrqrvz65gzl
YyWAwcA+2qX0qVLKDNK5yI9UgDCWMNOy49D+YlQQ9ndMwW2luIsdH9IzC6AsIQEC
e5dn+3jbKNIdFSHJltHt4grp1wxqp0iCrJgKEwCQmne4xBkWixWMj/hRJciWYHtO
H0i2OY+QAgsZwn806JpxTV2leCBDV9lykiw3gfwasUnMaUQhddPiI8r+9OAe+blt
0RDKFLxVg7SsaMjKBu0A
=8Tku
-----END PGP SIGNATURE-----

--=-Mdv7GZ5xvJoIwsOv9yjn--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
