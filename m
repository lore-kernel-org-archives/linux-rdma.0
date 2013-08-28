From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH librdmacm 0/3] no IBV_SEND_INLINE thus memory
 registration required on QLogic/Intel HCA
Date: Wed, 28 Aug 2013 17:02:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA967C@ORSMSX109.amr.corp.intel.com>
References: <cover.1376746185.git.ydroneaud@opteya.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA890E@ORSMSX109.amr.corp.intel.com>
 <32E1700B9017364D9B60AED9960492BC21193FDB@FMSMSX107.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA95B6@ORSMSX109.amr.corp.intel.com>
 <32E1700B9017364D9B60AED9960492BC211940BD@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211940BD-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yann Droneaud' <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Based on performance tests, increasing the maximum inline can result in a
> > significant decrease in overall bandwidth.  So, I don't believe that we
> want
> > providers to increase max_inline automatically to what could be
> supported.
> >
> 
> So why would providers return a max_inline value that invites non-optimal
> performance?

It can improve small message latency.

I think you want the application (or administrator) to specify the desired inline size based on its needs.  The other trade-off is that the amount of memory allocated for the QP increases with inline size.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
