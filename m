From: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Question about RDMA_CM_EVENT_ROUTE_ERROR
Date: Thu, 24 May 2012 17:48:56 -0500
Message-ID: <4FBEBAD8.5010507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: pierre orzechowski <pierre.e.orzechowski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

We are trying to figure out the cause for RDMA_CM_EVENT_ROUTE_ERROR 
errors after a failover event of the bonding driver.
The event status returned is -EINVAL. To gather further information on 
when this EINVAL is returned,
I added some debug which showed 3 for mad_hdr.status in the below 
function in drivers/infiniband/core/sa_query.c.

[drivers/infiniband/core/sa_query.c]
static void recv_handler(struct ib_mad_agent *mad_agent, struct 
ib_mad_recv_wc *mad_recv_wc)
{
         struct ib_sa_query *query;
         struct ib_mad_send_buf *mad_buf;

         mad_buf = (void *) (unsigned long) mad_recv_wc->wc->wr_id;
         query = mad_buf->context[0];

         if (query->callback) {
                 if (mad_recv_wc->wc->status == IB_WC_SUCCESS) {
                         query->callback(query,
                                         
mad_recv_wc->recv_buf.mad->mad_hdr.status ? -EINVAL : 0,
                                         (struct ib_sa_mad *) 
mad_recv_wc->recv_buf.mad);

How do I find out what 3 in mad_recv_wc->recv_buf.mad->mad_hdr.status 
stands for ?

To test RDS reconnect time we are rebooting one of the switch connected 
to one port of the bonding driver.
It then fails over to the other port, RDMA CM gets notified which then 
notifies RDS.
RDS initiates a reconnect.   rdma_resolve_route results in these errors.
There are some 25 connections that try to failover at the same time.
We get this error for a couple of seconds and finally the 
rdma_resolve_route succeeds.
Some of them succeed right away. So it may be due to the load generated 
by too many rdma_resolve_route.

Thanks for your help.

Venkat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
