From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 2 Aug 2017 10:45:53 -0600
Message-ID: <20170802164553.GA31901@obsidianresearch.com>
References: <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <20170801195840.GC31205@obsidianresearch.com>
 <20170802034438.GV13672@mtr-leonro.local>
 <20170802155856.GA21208@obsidianresearch.com>
 <20170802162938.GC13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170802162938.GC13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 02, 2017 at 07:29:38PM +0300, Leon Romanovsky wrote:
> On Wed, Aug 02, 2017 at 09:58:56AM -0600, Jason Gunthorpe wrote:
> > On Wed, Aug 02, 2017 at 06:44:38AM +0300, Leon Romanovsky wrote:
> > > On Tue, Aug 01, 2017 at 01:58:40PM -0600, Jason Gunthorpe wrote:
> > > >
> > > > I'm not sure why there is so much noise about this - yes, iwpmd is
> > > > really weird, but it is a UAPI, we can't change it and we can't demand
> > > > they change.
> > >
> > > If you claim that it is UAPI change, we MUST revert this patch, because
> > > reverted patch CHANGED UAPI.
> >
> > That is not how I read it.. The UAPI was intended to be lossless and
> > there was a kernel bug that made it more lossy than expected, that is
> > what that original patch was addressing.
> 
> The catch 22 here is in the fact that there is no kernel bug. I assume
> and according to Bart's questions (but better to ask him) he thinks the same,
> that the bug is in protocol layer and/or user space part. There is no
> visible kernel bug.

No, I disagree.. It is pretty clear how iwpm works, it it pushes
unsolicted messaged directly to the userspace daemon from the kernel
and expects the daemon to receive those messages.

With such a scheme it is really important for the kernel to do
everything it can to minimize the risk of message loss, and using the
blocking sending for unsolicited messages is certainly part of it -
that is what audit does for instance.

The discussion really got into the weeds when people brought up
O_NONBLOCK or ENOBUFS, or any other user space change as that has
nothing to do with pushing unsolicited messages from the kernel to
userspace.

Arguing that is a 'protocol bug' doesn't make much sense, the protocol
is a uAPI, so it is up to the kernel to provide the best
implementation possible, which in this case means working to minimize
loss of the messages..

Noting again, that this is *ONLY* talking about the unsolicted
messages the iwpm sends toward userspace. IMHO, use of blocking send
in other contexts, such as dump callbacks, is an error.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
