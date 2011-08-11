From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: slow rdma_connect
Date: Thu, 11 Aug 2011 17:19:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E3E828@FMSMSX151.amr.corp.intel.com>
References: <4E44075C.2@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E44075C.2-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arun Kaimalettu <arun.kaimalettu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> to complete the connections to a server.  The machine where we are testing
> has enough CPU resource , so this 30 - 40secs appears to be the time for
> rdma_cm to transition from resolving address to establishing connections..
> Is this expected or should we be configuring rdma cm to handle this load ?

The rdma_cm can handle this load, but...
 
> set of system calls involved in both sides are:
> 
> server:
> rdma_create_id, rdma_listen, loop with { select, rdma_get_cm_event}
> (listen backlog is 10)

the backlog is the issue.  With a backlog of only 10, all additional incoming requests get dropped and must be retried.  The connect retry is a couple of seconds.  Try increasing the backlog (or setting it to 0).

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
