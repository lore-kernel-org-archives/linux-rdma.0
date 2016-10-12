From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core release?
Date: Wed, 12 Oct 2016 12:35:48 -0600
Message-ID: <20161012183548.GA31053@obsidianresearch.com>
References: <20161012105103.GA30534@infradead.org>
 <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w@mail.gmail.com>
 <59ebde13-0fcd-0640-e750-bb6e57bfb921@redhat.com>
 <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
 <20161012163149.GA20174@infradead.org>
 <20161012164759.GB18838@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE23B5D@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7DE23B5D-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 12, 2016 at 06:17:45PM +0000, Woodruff, Robert J wrote:

> and wait till all packaging was flushed out before moving to the new
> code base. I think it would be desirable if there were some kind of
> official release tar ball or at least official release git tag that
> is recommended by you guys that we should use in OFED.

It is pretty fluid at this point, if OFED says, hey we are happy with
this commit, I'm sure Doug can tag it. I suspect we will produce tar
files out of github, so a tag means a tar will appear.

The current git HEAD should be a suitable starting point for OFED, I
think. It is no worse than what OFED had from the individual tar
files, and contins various important driver updates.

> I have not followed this really closely, but have you guys finalized
> how the packaging in SRPMs will/should work ? Or is that an exercise
> left up to the Linux distros and/or OFED to decide on ?

As Doug touched on this, the distros have to decide based on their own
internal policies how this should look, so we will help but not
dictate. SuSE and CentOS already use quite different packaging and
even different rpm names from what I can see.

What does OFED do, and what do you want? Closeness to current distro
packaging? Closeness to future packaging? Something OFED specific?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
