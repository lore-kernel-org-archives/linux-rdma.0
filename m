From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Question about RDMA_CM_EVENT_ROUTE_ERROR
Date: Fri, 25 May 2012 00:18:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A23FFD@ORSMSX101.amr.corp.intel.com>
References: <4FBEBAD8.5010507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBEBAD8.5010507-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: pierre orzechowski <pierre.e.orzechowski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We are trying to figure out the cause for RDMA_CM_EVENT_ROUTE_ERROR
> errors after a failover event of the bonding driver.
> The event status returned is -EINVAL. To gather further information on
> when this EINVAL is returned,
> I added some debug which showed 3 for mad_hdr.status in the below
> function in drivers/infiniband/core/sa_query.c.
> 
> [drivers/infiniband/core/sa_query.c]
> static void recv_handler(struct ib_mad_agent *mad_agent, struct
> ib_mad_recv_wc *mad_recv_wc)
> {
>          struct ib_sa_query *query;
>          struct ib_mad_send_buf *mad_buf;
> 
>          mad_buf = (void *) (unsigned long) mad_recv_wc->wc->wr_id;
>          query = mad_buf->context[0];
> 
>          if (query->callback) {
>                  if (mad_recv_wc->wc->status == IB_WC_SUCCESS) {
>                          query->callback(query,
> 
> mad_recv_wc->recv_buf.mad->mad_hdr.status ? -EINVAL : 0,
>                                          (struct ib_sa_mad *)
> mad_recv_wc->recv_buf.mad);
> 
> How do I find out what 3 in mad_recv_wc->recv_buf.mad->mad_hdr.status
> stands for ?

You would need to look in the IB spec.  Note that the status field is 16-bits and should be in big endian order.  Assuming, therefore, that the '3' falls into the upper bits of the status field, this would be an SA specific status value of ERR_NO_RECORDS.
 
> To test RDS reconnect time we are rebooting one of the switch connected
> to one port of the bonding driver.
> It then fails over to the other port, RDMA CM gets notified which then
> notifies RDS.
> RDS initiates a reconnect.   rdma_resolve_route results in these errors.
> There are some 25 connections that try to failover at the same time.
> We get this error for a couple of seconds and finally the
> rdma_resolve_route succeeds.
> Some of them succeed right away. So it may be due to the load generated
> by too many rdma_resolve_route.

You may need to back up and see what rdma_resolve_addr returns in the cases where rdma_resolve_route fails, and compare that with rdma_resolve_addr when rdma_resolve_route succeeds.  Maybe there's be a timing issue with the SA detecting the switch failure.  Can you tell if the RDS traffic is actually migrating to the new ports?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
