From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 6 Sep 2016 10:37:08 -0600
Message-ID: <20160906163708.GA3862@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <bb889a58-331c-8ba8-920d-e3a79072dce4@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bb889a58-331c-8ba8-920d-e3a79072dce4-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 06, 2016 at 09:59:48AM -0400, Hal Rosenstock wrote:

> It would be nice if history from the original repos was
> preserved/propagated into this combined repo. Is there a reason that
> wasn't done ?

Of course this was done. I talked about it at length in the first
email. What are you seeing that makes you think otherwise?

Check it out in action here:

https://github.com/jgunthorpe/rdma-plumbing/blame/master/libibumad/src/umad.c

The blame is going back through the entire available git history.

Note that git has all sorts of weirdness with rename handling so this
doesn't always work so well.. eg github's single file history doesn't
work, but 'git log --follow' mostly does.

> > Steve suggests that iwpm be included as well, which makes sense..
> > 
> > My hope is that Doug will step up as the unified maintainer, with a process
> > similar to the kernel. Most of the libraries are unchanging/unmaintained/dead.
> 
> What is the anticipated process here ? Will the submaintainers need to
> go through the uber-maintainer ?

I think Doug and Leon are working that out somewhere in this thread.

There is a range of options projects tend to use:
- Send a patch, ack other peoples patches
- Send a pull request
- Have a 'commit bit' and push directly to the master repo

umad changes so little that the first is probably the least work
option for you.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
