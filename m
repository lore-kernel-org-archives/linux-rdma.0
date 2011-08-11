From: Arun Kaimalettu <arun.kaimalettu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: slow rdma_connect
Date: Thu, 11 Aug 2011 22:16:20 +0530
Message-ID: <4E44075C.2@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

We have a client-sever application that use rdma cm to establish connections
to do RDMA.   It takes around 30 or 40 secs for 500 clients started 
simultaneously
to complete the connections to a server.  The machine where we are testing
has enough CPU resource , so this 30 - 40secs appears to be the time for
rdma_cm to transition from resolving address to establishing connections..
Is this expected or should we be configuring rdma cm to handle this load ?

set of system calls involved in both sides are:

server:
rdma_create_id, rdma_listen, loop with { select, rdma_get_cm_event}
(listen backlog is 10)

client:
rdma_create_id, rdma_resolve_addr, rdma_resolve_route, rdma_connect, 
loop with { select rdma_get_cm_event}
(resolve timeouts are 20ms,
connect parameters are :
   param.responder_resources = 1;
   param.initiator_depth     = 1;
   param.rnr_retry_count     = 7;
   param.retry_count         = 7;
}

versions:
libibcm-1.0.5-1
ibacm-1.0.3-1
librdmacm-1.0.13-1

--
thanks,
arun

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
