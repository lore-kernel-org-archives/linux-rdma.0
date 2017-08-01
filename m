From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 15:38:15 -0500
Message-ID: <20170801203815.GA4620@ctung-MOBL3.amr.corp.intel.com>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <20170801195840.GC31205@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801195840.GC31205-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 01:58:40PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 01, 2017 at 10:15:11AM -0500, Chien Tin Tung wrote:
> > On Tue, Aug 01, 2017 at 09:22:47AM -0500, Christopher Lameter wrote:
> > > On Tue, 1 Aug 2017, Chien Tin Tung wrote:
> > > 
> > > > Why do I need to explain the original patch?  It was accepted many kernels
> > > > ago.  Your questions on the original were based on false assumptions and
> > > > facts which I've proven over and over.  You are right in that I do
> > > > not want to revisit those either.  There is a patch that can solve
> > > > the problem you are facing but yet you insist on the revert.  This is
> > > > very puzzling to me.  You simply refuse to move this forward.  That
> > > > is your choice but revert is a no go for me.
> > > 
> > > Ok this is pretty confusing to someone not involved in the prior
> > > discussions. Could both of your stop attacking each other and start
> > > talking about the technical issues?
> > 
> > There's been multiple threads over this revert.  This one is the
> > latest Leon walked away from: https://patchwork.kernel.org/patch/9814367/
> > 
> > I'm simply asking for proof/evidence/facts to back up Leon's claims.
> > Show me the code/stack trace/whatever and I will be happy to admit wrong
> > publicly on the list and move on.  I do have better things to do than
> > to NACK a revert.
> 
> Well, I think the design of the netlink protocol in iwpmd is pretty
> strange, but audit netlink is the other major user of blocking
> netlink_uncast to achive some reliability, so it should be workable
> here as well.

Agreed, somewhat.  I'm all for making things better but the basis of
any conversation needs to start with correct assumptions.

> Presumably the iwpmd kernel side is designed to handle the locking
> right to avoid deadlocks.

Please stop using the word deadlock in relation to usage of 1-shot
retry in ibnl_unicast.  It does not and will not cause deadlock period.
It will wait for a buffer within timeout value but that's it.

> I'm not sure why there is so much noise about this - yes, iwpmd is
> really weird, but it is a UAPI, we can't change it and we can't demand
> they change. For better or worse the protocol is based on
> 'near-reliable' netlink delivery of messages and we are stuck with
> that.
> 
> Leon is also right that every other user of netlink_unicast in rdma
> should be using the non-blocking version.

In Mustafa's patch, there are calls to both versions of ibnl_unicast.
There are situations where the retry version of ibnl_unicast
is not desirable, note I didn't say wrong.

Here is the reality.

The retry version of ibnl_unicast will only wait when there is
no buffer to send the Netlink message.  It does not
interfere with other Netlink calls.  For that matter, other
calls to transmit a Netlink message will fail as there are no
buffers available.  If a buffer does not become available within
timeout parameter, you have bigger problems.

> So, the above patch seems like a sensible approach to me..

Finally.  Thank you.

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
