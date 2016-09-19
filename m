From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 19 Sep 2016 16:54:18 -0600
Message-ID: <20160919225418.GA22760@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB07FBE1@ORSMSX109.amr.corp.intel.com>
 <20160913180342.GA6933@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08075C@ORSMSX109.amr.corp.intel.com>
 <20160913222539.GB29095@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB080798@ORSMSX109.amr.corp.intel.com>
 <edc4c963-847a-e973-f1f1-ab9b78ad9d19@redhat.com>
 <20160916161626.GB2833@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08C5F3@ORSMSX109.amr.corp.intel.com>
 <20160919185502.GA12436@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08D2CD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB08D2CD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2016 at 06:58:52PM +0000, Hefty, Sean wrote:
> > I would delete the windows support in that package if we take it into
> > rdma-core.
> > 
> > Is that OK?
> 
> That's fine with me.  I haven't tested on windows in a long time.
> I'm not sure how usable it is, as no one is maintaining the
> libibverbs and libibumad windows ports.

Okay, it is up now. I haven't done all the steps, but call it a draft.

https://github.com/jgunthorpe/rdma-plumbing/tree/master/ibacm

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
