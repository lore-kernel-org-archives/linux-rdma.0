From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for
 multicast handling
Date: Wed, 21 Jan 2015 16:48:00 -0500
Message-ID: <1421876880.3352.124.camel@redhat.com>
References: <cover.1421725318.git.dledford@redhat.com>
	 <54BE7F66.4070404@dev.mellanox.co.il>
	 <CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg@mail.gmail.com>
	 <CAJ3xEMi5vGc-Urv_7RSWCn9-ZAiq0WzVn3y0__jrTc48jM9gpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gjuMEs44aj8JEIoiLcD5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi5vGc-Urv_7RSWCn9-ZAiq0WzVn3y0__jrTc48jM9gpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-gjuMEs44aj8JEIoiLcD5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-21 at 22:34 +0200, Or Gerlitz wrote:
> On Wed, Jan 21, 2015 at 7:19 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Tue, Jan 20, 2015 at 8:16 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifUpdFzICT1y@public.gmane.org=
l> wrote:
>=20
> >> After trying your V4 patch series, I can tell that first, the endless =
scheduling of
> >> the mcast task is indeed over, but still, the multicast functionality =
in ipoib is unstable.
>=20
> > Is this worse than 3.18?  (Have you tested that?)
>=20
> Roland, Doug,
>=20
> To be fully clear here by "this" we're talking on seven patches of
> complexity and volume which I think go way beyond post -rc5 timeline:
>=20
>   IB/ipoib: Fix failed multicast joins/sends
>   IB/ipoib: Add a helper to restart the multicast task
>   IB/ipoib: make delayed tasks not hold up everything
>   IB/ipoib: Handle -ENETRESET properly in our callback
>   IB/ipoib: don't restart our thread on ENETRESET
>   IB/ipoib: remove unneeded locks
>   IB/ipoib: fix race between mcast_dev_flush and mcast_join
>=20
>  drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 204 +++++++++++++++----=
------
>  2 files changed, 121 insertions(+), 84 deletions(-)

I don't usually look at the line count or the patch count, I look at the
changes.  Most of the 7 patches above are very self contained and very
small.  The exception is the final patch and even though it is large,
the net result is that it takes a needlessly complex function and makes
it easier to read, easier to understand, easier to verify that it does
what it's supposed to do, and then fixes a locking issue.  I also look
at testing.  While it's not obvious to the people on this list, I am
testing this rather profusely and so is our internal QE department and a
few others.  I'm really down to only the rmmod race (which I suspect the
7 patches above did not introduce, but the original 8 patches did).

> Doug, I understand your claim and frustration that with 3.18 and such
> (older kernels) your ifdown/up loop manages to break the driver,

Yes.  Quite easily.

>  but
> fixing the driver such that this test works and in the same time
> practically breaking IPv6 and IPv5 multicast introduces a deep
> regression vs. 3.18

You're right.  That's why there are these 7 patches.

>  - which as you wrote here, would be wrong to fix
> with such a further big change.
>=20
> Are you really sure that reverting the offending patch 016d9fb25cd9
> "IPoIB: fix MCAST_FLAG_BUSY usage" and maybe some more dependent
> related hunks from downstream patches of that series isn't possible?

Positive.  The 8 patches change the semantics of the MCAST_BUSY_FLAG
usage throughout the code.  If you pick some and leave others, you can
end up with parts using the flag one way and parts another and then you
really blow your locking and usage to hell.

> If this is the case, I would suggest that we either revive the review
> on the fix we sent [1] or drop the whole 3.19-rc1 changes. I vote for
> the former.
>=20
> [1] http://marc.info/?l=3Dlinux-rdma&m=3D142064313123254&w=3D2

So, my original 8 patches were broken.  That's easy enough to see.  My
"sin" in my testing of those patches was that my test methodology was
too myopic.  I focused on the ifup/ifdown loop scenario, and didn't test
other things that might be effected.  Similarly, if people are only
testing this latest set of code one way (for example, using rmmod/insmod
as the means to force the connection up and down and test the
joins/leaves), that can be similarly myopic.  This patch from Erez is
horribly broken for cases other than rmmod/insmod testing.  I'm guessing
you didn't see it because you never tested any other way, like using
ifup/ifdown or pulling a cable or turning a switch port off and back on.
If you had, there would not be a question of using it, at least as it
stands.

Look, smaller is not always better.  A fix that seems to work and is
smaller, but renders the code almost unintelligible because it makes the
code internally inconsistent between various areas is not a preferable
patch to a larger patch that fixes things right and makes the overall
code consistent and understandable.

> > Because Doug's changes fixed some bad, easy-to-reproduce issues.  On
> > the other hand we don't want to introduce new regressions to fix the
> > old issues.
>=20
> See above, we did introduced regressions.

Which are already fixed by this 7 patch patchset.  The one remaining
issue isn't actually an ipv6 or ipv4 multicast issue, but specifically
an issue related to locking around rmmod/insmod and that we are allowing
ourselves to get into an inconsistent state during these cycles which
then effects later running (for instance, we might not clean out all of
our multicast joins before rmmod on ipoib succeeds, so on the next
insmod and attempt to join that same multicast group, the ib_sa layer
multicast membership state no longer agrees with us and we have
problems).  I've got to fix that.  But if you run your tests without
rmmod/insmod being how you bring the link up/down, I think you'll find
it now passes those tests with flying colors.  At least it does in my
testing and I would greatly value confirmation of that.

> > I think we only have a few days to decide whether to revert back to
> > 3.18 code, or push forward with these fixes.
>=20
> Or.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-gjuMEs44aj8JEIoiLcD5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUwB6QAAoJELgmozMOVy/dZasQAJdNA3APwHKEfGnOMIp6H9O5
Fs03Pj+Nd4wV4xU5bC/r6Xp0WsuiIFcjEp7vh9BLfYnebwVDyGnxyRSLLjKSLDV5
KxgxzX0/BRK55CVHj52qKLMp31K8uAxekKEbTk7EoU3NJfFuDeGb0AWK8DxJ5Fvo
ylbjcVh9ZRIALc2yqsur88aVKL6OJvxNVLfy8a3lYYF/RuFMywEPNDznEaN8C9Dj
BTyq7hTP9+Up8sd0znaPsoKiz4xXSMWg0b6sQNnFx18cKZh0n6/xXIuKbS7YPQor
wd1T0s+tTkeCjWV6pF7q93g1dvKGkvYRD8vVGcNEaKcJ7BEgFJsCpN36YVGDeEL2
TF8mA4J7RcQACs1BglTE5uvuwgSaEekYcluxy3G0vARzIJqfATQ2XWqmkLx8bht5
OTOZQ5mIsfchw4xrw6O9pjncO7VVZczqXWjnM3jTTcVs6SoHk+I0TYnRiNnHq4zp
7YOuPwsVhkdYWBTDjyvfaDhVeRCK5sczQtXKJgzbbYoCpE5Gjh1y71OXtdGwkaYn
Q5Pp+RIOnbThEMX8RkjdqVH987QBWd2a4YWrUMQ+KmTZEH39OE70sJN9/kNWN8JO
is2M+oqpN4DiIrnRT/S8/2eFPQLMa4XNMciyJbEMqHFQ/SK5Aa/yFP9FHDiHIxkc
4eRDRDOXtSEZ3f1W9lVW
=P20o
-----END PGP SIGNATURE-----

--=-gjuMEs44aj8JEIoiLcD5--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
