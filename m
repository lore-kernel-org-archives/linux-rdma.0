From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 01/27] IB/Verbs: Implement new callback query_transport()
Date: Wed, 22 Apr 2015 12:22:34 -0400
Message-ID: <20150422162233.GA1494@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534B981.1030302@profitbricks.com> <1429714975.45956.113.camel@redhat.com> <EE7902D3F51F404C82415C4803930ACD5DC446F3@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC446F3-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 03:21:43PM +0000, Devesh Sharma wrote:
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
> > Sent: Wednesday, April 22, 2015 8:33 PM
> > To: Michael Wang
> > Cc: Roland Dreier; Sean Hefty; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> > kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org; Tom Tucker; Steve Wise;
> > Hoang-Nam Nguyen; Christoph Raisch; Mike Marciniszyn; Eli Cohen; Faisal
> > Latif; Jack Morgenstein; Or Gerlitz; Haggai Eran; Ira Weiny; Tom Talpey; Jason
> > Gunthorpe
> > Subject: Re: [PATCH v5 01/27] IB/Verbs: Implement new callback
> > query_transport()
> > 
> > On Mon, 2015-04-20 at 10:32 +0200, Michael Wang wrote:
> > > Add new callback query_transport() and implement for each HW.
> > 
> > The more I think about it, the more I think we need to eliminate this patch
> > entirely.
> > 
> > The problem here is that, if we follow my suggestion, then we are going to
> > eliminate the query as an API function and replace the information it gives us
> > with a static port attribute bitmap.  If we do this patch, then reform this patch
> > to my idea later, we introduce a very short lived API/ABI change in the kernel
> > module interface that serves absolutely no purpose.  Instead, let's do the
> > bitmap creation first, update the drivers to properly set the bitmap, then do all
> > of the remaining reforms you have here using that bitmap and completely skip
> > the
> > query_transport() API item that will no longer serve a purpose.
> 
> Any vendor device that registers with IB stack already has capability flags, are you referring to the same as bit maps?
> Is it possible to use same as bitmaps you are referring to? I am trying to understand you complete idea.

The idea was to use additional bit maps.

https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
