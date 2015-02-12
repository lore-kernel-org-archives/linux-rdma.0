From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/ipoib: don't queue a work struct up twice
Date: Thu, 12 Feb 2015 14:47:16 -0500
Message-ID: <1423770436.3387.4.camel@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
	 <30a5bd6461381448c52af0d7408dbc14da9ac4d0.1423703861.git.dledford@redhat.com>
	 <54DCF20C.3040704@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lnbCX59OkBYRXkvKf5db"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DCF20C.3040704-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-lnbCX59OkBYRXkvKf5db
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-02-12 at 20:33 +0200, Or Gerlitz wrote:
> On 02/12/2015 03:43 AM, Doug Ledford wrote:
> > In b2d408f78b3 (IB/ipoib: make delayed tasks not hold up everything) I
> > added the ability to have some joins processed around delayed joins.
> > Because the join task processes one join at a time, we needed to queue
> > the task to run again immediately and then again at the appropriate
> > delay time.  I didn't think about the fact that our work struct can onl=
y
> > be on the workqueue once at a given time and instead tried to queue the
> > same struct up twice.  Instead, kick the queue again immediately on a
> > delayed restart attempt, when the task sees that it has nothing to do
> > but delayed work, it will pick the shortest work item and queue a delay
> > equal to its expiration.  Finally, in case we have delayed work, in the
> > send_mcast routine we need to cancel any delayed work before kicking th=
e
> > thread immediately.
> This is strictly a fix to a downstream patch of the series, lets squash=
=20
> it there somehow, I see no point to submit
> commit that has a bug and later a fix in the same series.

A number of them *are* strictly fixes.  That's a given.  But both you
and Erez emailed me and wanted this patch set sooner rather than later
because Erez in particular had some other things he wanted to send
through and wanted them to be based upon this patchset so they would
apply cleanly.  When I went to squash these things, it became clear very
quickly that I would end up rewriting significant portions of this work,
and that I would have to retest all but the first few patches one patch
at a time.  And I'm actually OK doing that, but it wasn't possible to
meet both requirements at the same time.  So, I'll keep a new branch and
this branch, and I'll reorder things (like the singleton fix you brought
up in another email being first) and squash things, and when I get done,
I'll do a diff between the two branches to make sure that there are no
logical differences.  That should avoid invalidating all of the
testing/QE work that has already been done on this patchset.  In the
meantime, Erez can work off of these patches knowing the end result will
be the same either way.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-lnbCX59OkBYRXkvKf5db
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU3QNEAAoJELgmozMOVy/dL/4P/2HwwyW8GWrXt2RYB+puvfBW
t5KX+G/f/ZijAWknXJx/HGCbxcXYOW4PN+ClrvG/TjzVy9ipoiRT9LGYY9lwCmkm
IvYM+Wz8ngv4qlsaz2L2c4xaLJTl61jSKq5iZTTlJ6sk2ZFuRSxMw3EiJfBLZZFw
eRbRKtCTqKuw+wGSi2DVMxZXylHzOQMVgB2Kr565vIV7GGHhfu/Sx/RT6wnTS/Ta
i3FMvKDzi5Glk+B9k9shHQ0b2588ObclKT67aukEWEsh6LJwiVyq7VEl7xcCWDLL
jU/O+YjrUJvwlrrRbWeNhdOVilMUUVG9CS8pYg3B1KakY0BFCuj1HnkxIueLwCGo
W5jwaU/mjGwsHSMxGBvuGAYmBsx0OVie0alBv1jEAualj07S7dhpjqyAJZOLYZfF
dN/0oLNPy8PhlZNT6x26I9Cz4Ia3gaff9swHOz81QfWTYWzjo9bf3Ht3OSzcDBrQ
AhJ/PUS041IwpKckB97piyUM0Zx9e3wP0owuDhSvUyBW0EYRb5gYTCfOVyBvgniI
ZKtL/+vhyYwkJ4WWpAnCdXPED6MxPoIbqHGUkZAwxcGRN8JZY966Zcjkw1ecsZ3u
lNcUQZIyYvNISDGLuwFl097jr3lUj1RbeJxpKr88rpPmouH+OEjcTEG7YGJHhy5i
WSgdOMDKNmKD8S1Ldei/
=0f+d
-----END PGP SIGNATURE-----

--=-lnbCX59OkBYRXkvKf5db--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
