From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Wed, 7 Sep 2016 09:56:44 +0300
Message-ID: <20160907065644.GB3639@leon.nu>
References: <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <20160830071716.GA3098@infradead.org>
 <20160830073521.GM594@leon.nu>
 <20160830163033.GC26778@obsidianresearch.com>
 <4b791de5-0d6e-fd94-8a31-2fe833ca72db@grimberg.me>
 <20160906070102.GA23248@infradead.org>
 <20160906183405.GA27914@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160906183405.GA27914-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 06, 2016 at 12:34:05PM -0600, Jason Gunthorpe wrote:
> On Tue, Sep 06, 2016 at 12:01:02AM -0700, Christoph Hellwig wrote:
> > On Sun, Sep 04, 2016 at 11:18:02AM +0300, Sagi Grimberg wrote:
> > > I think that having a maintainer per provider makes perfect sense
> > > and as long as you Jason (or anyone else) are committed to merging it
> > > all together and produce standard releases we are pretty much set.
> > >
> > > What I think it missing is a release schedule, stable fixes
> > > methodology and merge cycles. I think once we can agree on that
> > > a lot of the concerns will be addressed.
> >
> > So let's keep the maintainers as-is, e.g. each previous project
> > keepts it's own maintainer similar to driver maintainers in the
> > kernel.
>
> This is certainly what I imagined. Nobody else has the domain
> expertise for these sub components.
>
> However, there is a lot of work just to keep everything ticking over,
> compilers change, build tooling changes, distros need hand holding,
> boring patches need accepting. That is where all maintainers should see
> value in this approach.
>
> > We'll add Jason as a global maintainer for the build system or any
> > non-controverial fixes and we should be much better setup than the
> > current situation.
>
> I was hoping a team including Doug would handle the general patch
> stream. Most of the patch flow today is for libibverbs and related
> anyhow. If Leon wants to handle the boring patches and provider pulls
> then that seems like a good combination.

It is not that I'm over-excited about it, just I think that someone needs
to do it to keep RDMA stack moving forward. I personally see the whole RDMA
stack as one entity and don't want to separate it to kernel vs. user.

>
> > Combine that with kernel-like major releases plus minor release on
> > demand and we should have a winning setup.
>
> I think the release cadence should be driven more by the distros, but
> following the kernel cadence is a sane place to start.
>
> Not much point in making a release if nobody is out there wanting to
> use it. I expect the distros will want to go to a more stable
> maintenance footing so we many want to offer to co-maintain a public
> LTS branch...

Release -> put a tag every X-days. For example Linus's tag will close
patch acceptance and 1-2 weeks after that, new tag will be added. In such way
everyone will know exactly what and when new version will be available.

Changelog can be generated from git history, participation in
rawhide/testing/tumblweed will ensure that packages are constantly
built.

At this point of time I don't see any reasons to manage stable branches,
it is much easier and convenient to ensure that master is always
buildable and ready to ship.

It will be worth to make a split for libibverbs2.0 when we will work on
ABI.

>
> > Now we just need to bikeshed on a good name for the repo, because
> > honestly rdma-plumbing sucks as a name :)
>
> Let the painting commence!
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXz7osAAoJEORje4g2clinwSEQAJbl8jK83rUG/5Cd74aGmYc6
7xZnez4OrsH/V3JAbq2BxYUqXG0Xl8fpV/trrjfyCOyyl29bGx0sBvofuk2a7Zbo
SC6I0pknl9pm5FTJ7/ob5wcYk7a39vh9u57bm6iKOo+o37PexhVkMwCp7IV5SyGG
xLB2TH8buWW5wZAL/g8dt7i0uqL4lvuTK61EupPSKxZk/qNyAPxp73PdKuICOB1/
9FcTYxdXElRGeqAv3q6LJXL2llYksHTNq1xckhspASrp8Svt6zQ4cxN47/r4KjlJ
fstABb+2iJT9K5jXKwj+GZwLvRJ8vfVCJ8MjH+WOR10uD8Jx/bWzsmtdyRZmCKg3
v4/xuLfLNCBry84tGOt+HoIGzpQDpQeKEQYUtks0PUGAlFh9+lBuWSl8Br/Yof++
2obSPwo2Gmrl2aSz16DEYftORS0YGL9F3KWjTztuMx4Jr1KjF3I3xIAGG27+62d2
ze0nBGPxhemxxp2q+C6okVrYK7brbg9KWmO7IoYA1DP6k7kz/sDYxXtGVnNaCclv
2D2E4w44Vp1wc9QX4P+imcfcDvRXY8viVI5q33gCJ4iAVThXy13q/njsqwKMAaY5
kXf5uGJHrXyOVnpnlRyrzVvV9xI+RbiXLJ1LNlNwdixHFx4RkzkKmuxfd/AI3BpL
VI39NX/sQ54jwv03YwVr
=t+AX
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
