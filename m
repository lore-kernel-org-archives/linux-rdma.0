From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: This merge window...
Date: Sun, 16 Jul 2017 17:38:16 +0300
Message-ID: <20170716143816.GD25686@mtr-leonro.local>
References: <824b3771-78a6-7c80-50d9-a34383169185@redhat.com>
 <CAJ3xEMh-YcUgydmc96UumX3cfgr7P+0rRenOvBe_6m_bo+K3mg@mail.gmail.com>
 <1499875106.2924.26.camel@redhat.com>
 <20170712160432.GA24552@infradead.org>
 <20170712171044.GE1528@mtr-leonro.local>
 <e3a1c07f-8a52-351e-312c-6e374ec7d136@grimberg.me>
 <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
 <11752e09-6ac3-6362-0aac-8e735b80033b@redhat.com>
 <20170716035749.GB14674@mtr-leonro.local>
 <d285c27b-bcd2-9585-f513-d7e96fb28e34@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d285c27b-bcd2-9585-f513-d7e96fb28e34-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 16, 2017 at 08:46:43AM -0400, Doug Ledford wrote:
> On 7/15/2017 11:57 PM, Leon Romanovsky wrote:
> > On Sat, Jul 15, 2017 at 02:12:42PM -0400, Doug Ledford wrote:
> >> On 7/14/2017 10:28 AM, Christopher Lameter wrote:
> >>> On Thu, 13 Jul 2017, Sagi Grimberg wrote:
> >>>
> >>>> Join on the awesomeness.
> >>>
> >>> It would even be more awesome if we had multiple people that can work the
> >>> release process so that we do not have a single person bottleneck.
> >>>
> >>> Doug: Would you please do some more detailed planning and delegate things
> >>> as possible? A couple of developers should be able to review the current
> >>> state of things and help to move things forward if there is a bottleneck
> >>> currently or coming up.
> >>>
> >>
> >> I am, without a doubt, reworking my process.  I will not be syncing up
> >> against Dave Miller's tree any more.  When I take patches, they should
> >> apply cleanly to my tree and work without dependencies.  If there are
> >> dependencies, then people need to send the dependencies through Dave's
> >> tree (assuming that's where they go) in release X, and then send the
> >> dependent code to my tree in release X + 1.
> >
> > There are two parts in this proposal, while second part (dependency) is
> > fair enough and possible to meet, it is unclear to me the first part
> > (apply cleanly).
> >
> > 1. On which branch should we send our topics?
>
> You can always use -rc1 as a safe starting point.  I'm going to try to
> open things up around then anyway.

No problem, it is the same as we do it anyway for our shared code.

>
> > 2. Are you acknowledge that this branch is going to be updated +/- on daily basis?
>
> Not necessarily daily, but certainly every 2-3 days.

2-3 days in some countries is the same as to say daily :)

>
> > 3. How do you see us submitting multiple topics? Sequential submission - like DaveM,
> > and it should be applied close to submissions (if no objections and so on ..).
> > Or parallel submissions - like it is now and the conflicts are unavoidable.
>
> Not the parallel submissions we are using now.  It generates far too
> many conflicts and such.  What I would prefer to see is one submission,
> then two or three days (so the first submission has had some bake time),
> then the next one and it should assume the first is applied and apply
> cleanly on top of 4hat.

I'm totally in for it. It will simplify greatly the whole my process and
will allow to do more cross-tree work.

Can we move to pull-request model? So our whole submission queue will participate
in linux-next and we will move our testing to use it as a testing branch instead of
our artificial queue-next [1]?

It will allow to all of us to have trees in linux-next, because we will
have same SHA1 and Stephen won't have any merge conflicts between trees.

>
> > 4. If 2 and 3 are not going to change, should we wait till late rc and submit all (100+)
> > patches at one or two shots to avoid merge conflicts?
> >
> > I would be glad to get the whole picture of submission process, before
> > we are moving forward.
>
> Is what I wrote above clear enough?

Thanks, it is much clear.
When do you expect to update your branches so we will be able to prepare our shared code?

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=queue-next

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllrelgACgkQ5GN7iDZy
WKfTFQ//WsqBHtuwUYTa1NDjQPd98b4mCJn5Op4XzvWrZsDtv9oip7lA9HAH04dz
jdczssIWTapLUrCJ8wWdyYWQ2LfVJ+sVDd8UyK67QAoAwZ+a6GeehQJAthuwRru/
Z7sl+ZOToqdZ/Fzd0+3dJxt96p48DQ189rf3NnnwkdhhQB5HJ/YJwqSklnm0Wzik
JySyhpuTjK3a1kBNXvJfyG20hNspeJvPUvUQmmaZu2Bf/wH5GqLwhtAg/D7vbJwQ
BQK2/8pUJKIkCVl4Upye4EKKZuyxb6OsbKZPkidOIT31qR4ASpYoutURg7MdaUPs
Pt+gnKddsYPzuGXUEtBtpN4WZ7uyknMznKJjJidWlgMiU1KdK6LHz/w4/Tpot3d9
ReWpvEg/GQIClE7tK398yEOzHbVvQecp7MBB1NyIyZO2nfk8yJvmZi5z+b10g8/n
FZkPhprkIOIzVQPCl9eHN71vJQ5JyDjn5+gFYg3H3XujAdKEM59N5gL4Snml71yH
/HUtbYCsu02/g1s4IgZG5fZf27v7TwijhFGjS6XmK443uo82ntEB9vo0Sk7lpINE
XOVY9HIfz+HYKU+zZ7695hnE8+uF+fqEWpV/dLr8OLWkb7duALAy1BS2BmGJJ1yj
NF3V4C/xqgfr8qMtstkQO42CTGChtqWYElkVP1Na0tDMhbPtWXc=
=K6Hd
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
