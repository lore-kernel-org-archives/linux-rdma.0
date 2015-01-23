From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Fri, 23 Jan 2015 02:45:25 -0500
Message-ID: <1421999125.3352.265.camel@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
	 <CAJ3xEMi7mowr_qFMUXtM5m8p974qF39nPf-Qh-NOYK_jUzswSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-q/aMbDEq8G+76xnbQQai"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi7mowr_qFMUXtM5m8p974qF39nPf-Qh-NOYK_jUzswSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-q/aMbDEq8G+76xnbQQai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-01-23 at 09:01 +0200, Or Gerlitz wrote:
> On Thu, Jan 22, 2015 at 4:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > My 8 patch set taken into 3.19 caused some regressions.  This patch
> > set resolves those issues.
>=20
> Doug, Roland - eight rc1 patches followed ten rc6 fixes - sounds a bit
> too much to me.

We can do as we wish upstream, but these are going live in our product
ASAP.  The original 8 rc1 patches took so long to get upstream that they
had already been live in 6.5-z and 6.6 and were slated for 7.1.  We had
a few customers report problems, but not as many as you might think.
The new patches are going to go out and fix those problems, period.  I
can't wait for 3.20 to fix these issues.  C'est la vie.

FWIW, I expect that these patches (plus the one patch I didn't put in
this same thread) to be live on production machines probably within 10
days (or less).  I'll let you know how that goes.

>  If we (and Linus) like or not, probably the right
> thing to do is revert the rc1 patches and come up with a set of
> hopefully < 18 patches for 3.20 - using squashes and such, and there's
> not much time for that too, BTW.

I'm not going to squash them.  I used to write big monolithic patches,
back in the day when I was a newbie kernel engineer.  Trying to review
or understand the nuances of those patches was nigh on impossible.
Here, each patch was unique in the issue it addressed and done that way
particularly to make it easier to follow the logic later when someone
might review this code and these changes.  A big monolithic patch that
hides these revisions hides the nuances that made getting this right
difficult.  I'm not going to go back to those days.  Git is just fine
with these patches being separated.

> Taking into account Doug's listing of the remaining problems in the
> original set which are not addressed by the patch Erez suggested, this
> isn't an option either.

I agree with you on this point.  But, I would also point out, that if
you are looking for justification to take this current patch set, that's
the real justification.  It's all about understanding the problem, and
dealing with it properly.  My patch set does that.  Patch count and line
count are secondary to understanding when it comes to determining if a
change is acceptable in late rc stage IMO.

> Alex, you acked all the series, haven't you noticed the IPv6 and IPv4
> multicast breakage or it worked for you?

Surprisingly enough, not many people use multicast.  And the whole
reason I didn't see the problem in the first place is that the initial
multicast setup that's necessary to make the links come up works OK,
it's only new joins after that which are effected.  We haven't had any
reports of multicast not working except from you.  Your report was
valid, just no one else cared (I'm sure someone would have eventually,
but out of the people using 6.5-z and 6.6 kernels, no one reported
multicast issues, just other issues).

> Or.
>=20
> > Doug Ledford (10):
> >   IB/ipoib: fix IPOIB_MCAST_RUN flag usage
> >   IB/ipoib: Add a helper to restart the multicast task
> >   IB/ipoib: make delayed tasks not hold up everything
> >   IB/ipoib: Handle -ENETRESET properly in our callback
> >   IB/ipoib: don't restart our thread on ENETRESET
> >   IB/ipoib: remove unneeded locks
> >   IB/ipoib: fix race between mcast_dev_flush and mcast_join
> >   IB/ipoib: fix ipoib_mcast_restart_task
> >   IB/ipoib: flush the ipoib_workqueue on unregister
> >   IB/ipoib: cleanup a couple debug messages
> >
> >  drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +
> >  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 234 ++++++++++++++---=
--------
> >  3 files changed, 131 insertions(+), 106 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-q/aMbDEq8G+76xnbQQai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUwfwVAAoJELgmozMOVy/dty0P/3Ov9VrBPIq0+J6WOYFWF86X
c1aSoqhgpKRXM1t1No9QkfXh5PSFOU4NygUFlblGSddySPmxdMhC7KMrHjWzh4yC
uojBnGuO1jULEgX7upwEWvZW/7DnpeJjz0dr9XsAjpm7mv7LtwxO3bbWzEo3RwuD
Es7G3fyTMzCzTdmknwGl5qxzWkxcpbHX3VLsHCgJ9RCSyAE80SzDJFe7MW9PE60M
DgmJkPEjy/sZ7b9q1xmdJcQpfwHozsqqQLyHR/lklqQGQ3oHTP542o31jpuNe+Pf
HW0oRk2Q1y8MZNtEgMSPIOEFN1x72LvqogYGtEMhzISAxWp9A8wieczP4+rJyIiI
phJFy5dhH8oPuo7YoubihsTAnHoLiaelBPqB4ZU4gUX0s4Z2E/0pClNK3ymTDXBE
YQoHaZWT/SafjhL3EQA3+2lPbzZwES8zN6HUCPYt7GrM7VTL9iSF6VuaxyuebtdT
C+kGKptEAtWdpEUtHeqBV8tJS1MfCjVqGMPbamY0CvD0bjzqlWvN9UxOXc/fjBNE
FVFq++Icva23R9JP/hUEsjAacBydzur1l45QpFdT7iI78dEA3QT1k3wOqr/X+OCD
+dQeGMIBGtc8RKZeFyZLFgGguZvkIypgmqx6p+mO1ze8jHxVW2m4lyrJu34IXXPR
ecyOJ7NCnr4ujwYh39l5
=Dp/l
-----END PGP SIGNATURE-----

--=-q/aMbDEq8G+76xnbQQai--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
