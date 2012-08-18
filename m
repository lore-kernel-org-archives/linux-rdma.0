From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and fork
Date: Fri, 17 Aug 2012 17:34:20 -0700
Message-ID: <1345250060.1128.29.camel@oc1677441337.ibm.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
	 <502A9039.4090505@us.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
	 <1344968289.2101.36.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com>
	 <1345239625.1128.20.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89F70@ORSMSX101.amr.corp.intel.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89F90@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A89F90-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-08-17 at 22:36 +0000, Hefty, Sean wrote:
> > >   retries = 0, err = 0, index = 16, ctrl_avail = 3, sqe_avail = 1020,
> > 
> >                                       ^^^^^^^^^^^^^^
> > This looks like part of the problem.  There should be 4 control messages
> > available by default.  The receiver has sent a control message to the sender,
> > but the control message never completed at the receiver.  My guess is that the
> > sender never received it either.  It may be the missing buffer update, which
> > would be an RDMA write into the sender's 'target_sgl' array.
> > 
> > Have you ever been able to reproduce this problem without using fork() support?
> 
> A simple check to add is whether the rs_post_write() call ever fails, but in rs_send_credits() in particular.  Checking for an error from ibv_get_cq_event() in rs_get_cq_event() may also be useful.  In neither case do I expect an error, but we could confirm it.

I didn't see any errors with these calls.
So far i have been able to consistently reproduce this hang only when fork support is enabled.
I am seeing this issue randomly even with a simple tcp client/server test only with fork.

Thanks
Sridhar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
