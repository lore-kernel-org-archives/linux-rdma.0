From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Thu, 30 Jul 2015 22:00:18 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2577809D@fmsmsx120.amr.corp.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
 <55BA9A38.2030401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BA9A38.2030401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 07/30/2015 04:01 PM, Marciniszyn, Mike wrote:
> >>
> >> I thought you were getting rid of this?
> >>
> >> Jason
> >
> > Doug wanted the v4 submitted as we currently have it.
> 
> To be accurate, I said "If you want a chance at making 4.3, I need a v4".  I
> didn't comment on whether or not any specific review comments were
> addressed.
> 
> > Doug?
> 
> I have no problem with this code.  That Al finds the user space ABI for this
> driver to be bizarre is neither here nor there to me.  Sure, this file does not
> exhibit normal file API behavior.  Who cares?  It's not a normal file in *any*
> sense of the word.  For example, the normal write routine will never, ever
> accept just plain data.  It's always in the form of a command.  If you don't
> have the right magic decoder ring, you will get nothing but errors when
> trying to do something with this file.
>  Much like /dev/infiniband/uverbs? files, it is a command interface, not a
> raw data interface.  I actually think the fact that you guys use write for a
> single command and writev/write_iter for a command queue is an elegant
> solution to your particular needs.  The only reason Al threw a hissy over it is
> because it tripped him up when he went to do the conversion from writev to
> write_iter.  That's understandable.  So, some clear documentation so
> someone like Al doesn't have to go reading through sources and try to figure
> out what you are doing would be the generally nice thing to do for other
> kernel generalists that might come poking around this way.  Or, another
> option would be to drop the write function altogether and just make all
> commands come through writev/write_iter and if you only have one
> command, you only send one element.  Regardless, those things can be
> cleaned up in follow on patches, please do not resubmit this set for that.
> 

Jason,

I did ask you in http://marc.info/?l=linux-rdma&m=143707462806767&w=2 if you thought ioctl was ok.

Hearing nothing, we left the interface as it was.

I suspect (I lack the early history) that the ioctl BKL might have forced both uverbs and PSM to go this route.

Doug,

Where would be the appropriate location to document?  In the source itself?  Somewhere else?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
