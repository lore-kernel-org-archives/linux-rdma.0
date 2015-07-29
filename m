From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH REPOST libibverbs] Add IP and TCP/UDP TX checksum offload
 support
Date: Wed, 29 Jul 2015 12:32:04 -0400
Message-ID: <55B90004.3070900@redhat.com>
References: <1434276784-15909-1-git-send-email-ogerlitz@mellanox.com>
 <alpine.DEB.2.11.1506181021160.13957@east.gentwo.org>
 <alpine.DEB.2.11.1507011015400.20250@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s2lDaVueafunu2cLt9JDAhMvBhBaBA7G6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507011015400.20250-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s2lDaVueafunu2cLt9JDAhMvBhBaBA7G6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/01/2015 11:17 AM, Christoph Lameter wrote:
> Is there any release schedule and/or upstream repo where I can see chan=
ges
> for libibverbs and libmlx4?
>=20

I'm working on libibverbs right now.  The upstream git repo has not
changed, it's the same as it always was.

Or, Jason asked for some (IMO very much needed) documentation on this
feature via man page additions.  For instance, the changelog calls out
that this is only used for TCP/UDP packets over IB UD QPs or Eth Raw
QPs.  Well, IB UD QPs sending IP packets is IPoIB, which is generally a
kernel protocol.  So, when it comes to user space, is this realistically
a Raw Eth QP only thing?

Also, the man page entry calls out what I would classify as hardware
limitations in the general IB verbs man page.  I would think it would
more appropriately call out that the support is hardware dependent and
then provide some means for the hardware to specify what types of IP
CSUM offloads it supports.  For instance, although there's been talk of
making connected mode IPoIB go faster by dropping the TCP checksum and
relying on the RC EC code instead and just ignoring the TCP checksum.
Another alternative would be to add TCP checksum support to your
firmware for connected mode QPs, so it's possible that in the future the
types of IP CSUM support could grow.  This patchset doesn't allow for
that or for distinguishing between hardware that has new or old firmware.=


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--s2lDaVueafunu2cLt9JDAhMvBhBaBA7G6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuQAEAAoJELgmozMOVy/dvbUP/ROlR3dG7CEy6UVqSqmSb0QG
ylEbq4tre7M2F7Qn6dJDjYfk8DkHZyYazrJorLftxRljFWFCqHmqjqy+dYsGZ4QW
ojzRkSOupS5t7hgT1ZEjnToE6biOPJrANuYkAbACA+sGrJ2FZwSwCmcxBSnXsJ3f
CNOKWecMO6ewmwK8TiV1KqU6D4fE0nRkDuHrSr7Guz9eIimaxvZJ04qal7Jmplk+
i4M86zne7CyMVr88YZR3lzEwdiWrxxVSw2qyk9EJWU0CCfg0+4uk9fso1isjpl50
lAdE0oYnHl5oTD7YFBztDPywz2D/ObixGXiaduH9eld+n9dCFf64ccYzMUa60/gx
3DDU4CufFb2880ht188Ia4DQhc94BIlUmlrZpQQ9IvnjRA916nZhoL6KH9ighbZd
VKhx8IVXlMCgJeGk3zFChPym43qzJCbQ9Fr9mX/1K/7RqDvWjSnhN9s9kIdgq+Yx
9HQExSv78WRaKvGqfbdD5rg/0qFu7pw8aNkCnWuzN5eAonJ4V+8uA9dXGoZcEe17
cpfFKrP+mGCniHX4wRQibq6z/eoADKVZnU6e8esLon/34WsZ9AtjhZiU7EH9fauq
H2civqf7FXaq4eKI5nldMUZ530w88s+ZBWX+oKuVkH9j+5MI37RGk0ayygz6W6qu
MCxxsJRAuhxnXB9uI5c0
=tfbm
-----END PGP SIGNATURE-----

--s2lDaVueafunu2cLt9JDAhMvBhBaBA7G6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
