From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 2/4] rsockets: retry for completion events upon
 interruption
Date: Wed, 17 Sep 2014 16:13:40 -0600
Message-ID: <20140917221340.GB26853@obsidianresearch.com>
References: <66c7c361d03a72de6a216fd1d6ffa0bc@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DD4395@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DD4395-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 17, 2014 at 04:27:05PM +0000, Hefty, Sean wrote:
> > +resume_get_cq_event:
> >   	ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, &context);
> >   	if (!ret) {
> >   		ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
> >   		rs->cq_armed = 0;
> > +	} else if (restart_onintr == 1 && errno == EINTR) {
> > +		errno = 0;
> > +		goto resume_get_cq_event;
> 
> I'm not convinced that this is desirable behavior.  If the thread
> waiting for an event was interrupted, why does it make sense to
> ignore the interrupt and return to waiting?  Couldn't the app detect
> the return code and call back into rsockets in this case?

More broadly, it doesn't make sense for a library to check EINTR in
one place without also checking every blocking syscall it makes.

Realistically, apps that want to use signals in this way will need to
see the EINTR at the app level, while apps that don't care should be
using SA_RESTART to prevent EINTR from being generated.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
