From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Leak in rdma_get_cm_event on pthread_cancel?
Date: Fri, 13 Jan 2012 16:43:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325676E37@ORSMSX101.amr.corp.intel.com>
References: <4F101978.6010608@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F101978.6010608-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> When I want to stop the thread reading rdma events, I kill it with a
> pthread_cancel(), since it is blocked in a
> rdma_get_cm_event(). This causes a leak of the evt variable in the
> rdma_get_cm_event() function. Not a big deal, of
> course, but a couple of pthread_cleanup_push(free, evt) and
> pthread_cleanup_pop() should solve it.

What version of the librdmacm are you using?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
