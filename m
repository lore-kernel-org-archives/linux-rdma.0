From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/16] librdmacm/rsocket: Fix hang in rrecv/rsend after
 disconnecting
Date: Thu, 31 May 2012 00:33:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A25049@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A24BE7@ORSMSX101.amr.corp.intel.com>
 <4FC6709C.70304@linux.vnet.ibm.com> <4FC6B369.90100@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC6B369.90100-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks for the feedback.

> 1. netperf: get_transport_info: getsockopt: errno 95
> This failure is due to the missing TCP_MAXSEG socket option support. May
> be this is OK as this option
> doesn't make much sense when using RDMA. Or we could return a reasonable
> value.

Missing socket options are usually easy enough to add, so that setsockopt can return success.  :)  Maybe this option makes sense as the MTU?  One issue I hit into with rsockets is that several options must be set before connecting.  And in this case, if MAXSEG mapped to MTU, it would need to match on both sides.

> 2. shutdown_control: no response received  errno 95
> Here select() on control socket is failing with EOPNOTSUPP after doing a
> shutdown(SHUT_WR) of the control socket

rshutdown() pretty much assumes SHUT_RDWR.  I need to think whether anything should be done to handle SHUT_RD or SHUT_WR, or if shutdown should just ignore those.

The issue may be the result of rshutdown() switching the rsocket from nonblocking to blocking in order to process the shutdown properly.  The code is waiting for all pending sends to complete to prevent data loss...
 
> 3. Once in a while netserver timesout in recv() after the client closes
> the connection.

...or maybe we still lose the disconnect message.  Did this occur after you applied patch 3?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
