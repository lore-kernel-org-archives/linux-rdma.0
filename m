From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 30 Aug 2016 22:02:29 +0300
Message-ID: <20160830190229.GR594@leon.nu>
References: <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <20160830071716.GA3098@infradead.org>
 <20160830073521.GM594@leon.nu>
 <20160830163033.GC26778@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sd7l8P2TFUHagl4l"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160830163033.GC26778-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sd7l8P2TFUHagl4l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 30, 2016 at 10:30:33AM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 30, 2016 at 10:35:21AM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 30, 2016 at 12:17:16AM -0700, Christoph Hellwig wrote:
> > > On Tue, Aug 30, 2016 at 09:08:42AM +0300, Leon Romanovsky wrote:
> > > > Doug is a busy person and there is a limit on how fast he can handle it.
> > > > He is already buried under his internal and external responsibilities.
> > > >
> > > > Placing him responsible for vendors code will add extra step,
> > > > extra complexity to the chain and will hurt kernel/libibverbs flows.
> > >
> > > Leon, calm down.  What Jason is proposing is to apply the exact same
> > > flow we have in the kernel to a much smaller project.  We prove it
> > > works on a giant project, and it will work on a smaller one.
> >
> > Kernel project has more than "pile of code in one place".
>
> Sigh, that is insulting Leon. I haven't just pulled a bunch of tar
> files together. Go look at the commits, and actually try out the
> repo. I did a lot of work to harmonize things and there is still more
> to do. I just pushed another update for you which includes some of the
> cruft removal.

"Insulting", you are taking it to far. No one is arguing with you about
the complexity of what you had done. I truly appreciate the effort which
you invested in it, but without the process it is not efficient as it
supposed to be.

>
> Besides, how do you think the kernel got to where it is today? Do you
> think it started out like this? NO. This is a process, starting with a
> consolidated repository, getting the distros on board, getting a team
> willing to even look at this stuff together, developing a process and
> so on.

So let's define a process together.

>
> The first step is the 'make it easy step'. Today everything is just
> too hard for developers. When Christoph Hellwig says building our user
> space is too hard *you should listen*. He isn't wrong, and he isn't
> inexperienced at this.

Sure, I listen, I was in that situation a year ago and still
remember how much time takes to setup the development machine,
but you should read second half of Christoph's answer to me too -
about overwhelmed maintainer in RDMA stack. It is enough to release
that valve "to push the train" and improve the user space domain.

>
> How many potential community members have been dissuaded by that
> simple fact??
>
> > > Maintainer overload always is a problem, and it's helped by adding
> > > more maintainers.  And yes, both the kernel RDMA stack and the user
> > > code should have a small maintainer team, but that's a different
> > > discussion.
> >
> > Awesome, let's start from this discussion to clear the ground and move
> > to technical proposals after it.
>
> We've already been over this ground, multiple times over
> years. Consolidation is the techincal direction a lot of people want
> to move toward.

Again, all participants are agree, the disagreement is in
preparation step before such move.

>
> Whatever maintainership structure is decided on can steward the
> consolidated repo.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sd7l8P2TFUHagl4l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxdhFAAoJEORje4g2clinpH4P/RM7fIo/h/a7hFaqZfi9ZXvt
0eLgBxf0FOVqrhdNHf2mw4WBsA1+RwyKK55mJ5XBmltpSnEZjAa7wesdTynJ8is8
pG1W+N5HXWcILpRoyxpAp8bDbjWiaun/+HmSARH6BrQ+W3lqyugyyq4krrry4st2
D8u0gOvivlyMYu2NlDlDvjAQzGepisIU+E0bRBjC6sGv66276j1i8md699EzOzS6
vkwF1xZqxWkHOCDB0Rg/s+v1yqWyY+tzTmdXEdSbpYubmHlf/EakLW23jiO3KcUj
KBF+V1pI281Mp0KKrSNwcH4UPit9W055tInyPfDZVUOX46MWZg4ZPJyXkbjuGffp
/b2oto2aoU2nkbtNlSIIo+yamGBC1/HZg8TsfoggcXgjmH2N+3X7J4czxFSng4HJ
7uICR9G+dFtcz3PEP4xBbKUrd14xWjhXbrnH/RIEReMQgllk9ws29veUstAsUXMh
gDw89tvju4EOnz92YCBr4LpjbqjapsVDkDYR2n+uMY1DQa08PIAqUnTjwc9SFI86
p11sHYrJy3fzXnuGLpIjoE0S8X6sM+F2s7q5VcqnZYZTX6e0/I7o0QF5VQW0wJHl
76xUuOOFIvzpGve6WVLA3B7hYp6LM5cO/9+BtyOI7QFI0z3YyFGpo0u90SpMwFrU
UVM/0CD+XwDQfJ352Ec1
=3GSm
-----END PGP SIGNATURE-----

--sd7l8P2TFUHagl4l--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
