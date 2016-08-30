From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 30 Aug 2016 10:30:33 -0600
Message-ID: <20160830163033.GC26778@obsidianresearch.com>
References: <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <20160830071716.GA3098@infradead.org>
 <20160830073521.GM594@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160830073521.GM594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 30, 2016 at 10:35:21AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 30, 2016 at 12:17:16AM -0700, Christoph Hellwig wrote:
> > On Tue, Aug 30, 2016 at 09:08:42AM +0300, Leon Romanovsky wrote:
> > > Doug is a busy person and there is a limit on how fast he can handle it.
> > > He is already buried under his internal and external responsibilities.
> > >
> > > Placing him responsible for vendors code will add extra step,
> > > extra complexity to the chain and will hurt kernel/libibverbs flows.
> >
> > Leon, calm down.  What Jason is proposing is to apply the exact same
> > flow we have in the kernel to a much smaller project.  We prove it
> > works on a giant project, and it will work on a smaller one.
> 
> Kernel project has more than "pile of code in one place".

Sigh, that is insulting Leon. I haven't just pulled a bunch of tar
files together. Go look at the commits, and actually try out the
repo. I did a lot of work to harmonize things and there is still more
to do. I just pushed another update for you which includes some of the
cruft removal.

Besides, how do you think the kernel got to where it is today? Do you
think it started out like this? NO. This is a process, starting with a
consolidated repository, getting the distros on board, getting a team
willing to even look at this stuff together, developing a process and
so on.

The first step is the 'make it easy step'. Today everything is just
too hard for developers. When Christoph Hellwig says building our user
space is too hard *you should listen*. He isn't wrong, and he isn't
inexperienced at this.

How many potential community members have been dissuaded by that
simple fact??

> > Maintainer overload always is a problem, and it's helped by adding
> > more maintainers.  And yes, both the kernel RDMA stack and the user
> > code should have a small maintainer team, but that's a different
> > discussion.
> 
> Awesome, let's start from this discussion to clear the ground and move
> to technical proposals after it.

We've already been over this ground, multiple times over
years. Consolidation is the techincal direction a lot of people want
to move toward.

Whatever maintainership structure is decided on can steward the
consolidated repo.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
