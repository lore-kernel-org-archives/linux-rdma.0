From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 1 Sep 2016 14:21:10 -0600
Message-ID: <20160901202110.GH20472@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <4f0876ce-f3c9-83e3-d0ef-0c5656ce9462@grimberg.me>
 <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com>
 <20160901172355.GA20472@obsidianresearch.com>
 <3a266ff7-006f-3d27-9e07-9e2e3ba2d1f9@redhat.com>
 <01e201d2048a$6e89faa0$4b9defe0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01e201d2048a$6e89faa0$4b9defe0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 02:52:55PM -0500, Steve Wise wrote:
> > >
> > > So we have nominations for
> > >
> > > srptools http://git.openfabrics.org/?p=~bvanassche/srptools.git/.git.
> > > perftest git://git.openfabrics.org/~grockah/perftest.git master
> > 
> > I would drop perftest out.  Here's why.  I like the idea that this
> > package is for software that interacts with the kernel directly.  It
> > needs to, in some way, involve itself with the kernel char interface or
> > with the kernel netlink interface.  So far, everything meets that
> > critera.  Perftest does not.  So, in the same fashion as libfabrics and
> > fabtests, I would leave perftest out, but that isn't to say a separate
> > package that pulled together various testing apps for RDMA could be
> > created too.
> > 
> 
> I see your point.  That is fine with me. 

I'm happy either way, but I will point out that libibverbs and
librdmacm sources contains various things similar to perftest (eg the
pingpong stuff, _bw, etc).

If we were to merge perftest I'd probably aim to consolidate all of
those similar examples/tests/etc under one directory in the source
tree.

I'd cast perftest and related as diagnostic tools to help users
validate verbs hardware is working as expected, so still under the
plumbing umbrella.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
