From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 27 May 2016 16:13:57 +0300
Message-ID: <20160527131357.GX25500@leon.nu>
References: <166c87fa-09ef-f170-7351-d18062bc25cf@redhat.com>
 <20160527045157.GW25500@leon.nu>
 <20160527114414.GA27420@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NJ5+aVN4Egd/eJfU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160527114414.GA27420-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NJ5+aVN4Egd/eJfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 27, 2016 at 07:44:15AM -0400, Dennis Dalessandro wrote:
> On Fri, May 27, 2016 at 07:51:57AM +0300, Leon Romanovsky wrote:
> >On Thu, May 26, 2016 at 06:34:28PM -0400, Doug Ledford wrote:
> >>Hi Linus,
> >>
> >>This is the second group of code for the 4.7 merge window.  It looks
> >>large, but only in one sense.  I'll get to that in a minute.  The list
> >>of changes here breaks down as follows:
> >>
> >>Round two of 4.7 merge window patches
> >>
> >
> ><...>
> >
> >>- The big item on the list: hfi1 driver updates, plus moving the hfi1
> >>  driver out of staging                             <- everything else
> >
> >Hi Doug and Linus,
> >
> >The move hfi1 from the staging is a right thing, it was there a long
> >time and it is almost ready.
>=20
> No, not almost, it is totally ready. We have bent over backwards to go we=
ll
> beyond what was in the TODO list. This is a clean, stable, and well
> performing driver.

It is your's TODO, not mine.

>=20
> >However the timing of this move puzzle me, we are in the process of ABI
> >change [1, 2] as a response to security alert [3]. Moves like this with
> >proprietary char device and ABI scheme different from whole RDMA stack
> >will limit the ABI work without real need.
>=20
> The driver sitting in staging or not has no impact on the ABI re-design.
> They are two completely separate issues.

Separate char device? IOCTLs per-device vs. global IOCTLs per subsystem?
Role of the IB CORE code in the driver management?

>=20
> >Will this driver be **forced** to adjust to new ABI scheme whenever it
> >comes? If it is not possible, the better solution to converge on ABI cha=
nge will be
> >to leave this driver in staging/rdma and wait till proper solution will =
be accepted.
>=20
> I think Doug has made it perfectly clear that hfi1 will need to adopt the
> new ABI when it is available, and we are certainly on board with that.

It is too generic and not limited in time, I'm not against moving your
driver out of staging, just want to be sure that ABI effort won't be
limited by current hfi1 code which doesn't fit into current IB core
model.

>=20
> -Denny

--NJ5+aVN4Egd/eJfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXSEgVAAoJEORje4g2clinMkQQALsHA5BKINinMSwijo6eqMIT
tyNBYp7KzUcCrclUV/kXWMnUeMSDqO3lXrF5BWYZ3dicPGj8wzXN/VL0Kix3IsKa
SjXp7+pPmz8Lv4zIOWOH5iz7avMCsssrt8VU+uEnbUtpqVwZU094rcvoHEetzfen
1kokNKwuink/43KC2krDpLOk0iK4JZwf85WSaZKE0/lAiiZKS4+Mf86daPHVprfk
eQoZBKNM2j1cx4/ImR2DmnLf6rdWPBSYclhsSmfRZzymctQdNDIvoRxqVyd9gXvx
iH/PPDZQy/3VDhn+iwGwXl22fWQyIPFHYcBi2AVW4d1tT6lKVTW0mtzrEk4N8qIP
P4fDxnHe7c1Sr5yxKydVSr3vdbgFL85vm0bkFystbK/CMcLFo1ZJmfWpbR2XeEHQ
4B90zosVYffSRRNGvQjCoBq+slqJamu/wR9loCKRozPuOdBykqOXJ0q3ozEGLiiv
Y+rDXvVraU69N6rDIbDyBQkSBnmqjVj5rcQhROb1pKIVSb7/9HiLIonHORetRpux
eFWb26dfUGVaqbgDoMn/5lWEBhlOp7PWM4fEIUyX2Wyh++BHIYZVCS2lBNFI97vJ
ulKP2SlldaBjFHN1p6pjGy8yZ4LkQbWclaUI+NEXGDF/R8gCfDu3lhQgHDoEuSnt
PZ12Jh/7Eqt7wNt23XdT
=hJxM
-----END PGP SIGNATURE-----

--NJ5+aVN4Egd/eJfU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
