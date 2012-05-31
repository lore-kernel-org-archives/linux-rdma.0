From: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question about RDMA_CM_EVENT_ROUTE_ERROR
Date: Thu, 31 May 2012 13:53:01 -0500
Message-ID: <4FC7BE0D.2040102@oracle.com>
References: <4FBEBAD8.5010507@oracle.com> <1828884A29C6694DAF28B7E6B8A8237346A23FFD@ORSMSX101.amr.corp.intel.com> <4FBFBF4D.9090400@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBFBF4D.9090400-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pierre orzechowski <pierre.e.orzechowski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/25/2012 12:20 PM, Venkat Venkatsubra wrote:
> On 5/24/2012 7:18 PM, Hefty, Sean wrote:
>>> We are trying to figure out the cause for RDMA_CM_EVENT_ROUTE_ERROR
>>> errors after a failover event of the bonding driver.
>>> The event status returned is -EINVAL. To gather further information on
>>> when this EINVAL is returned,
>>> I added some debug which showed 3 for mad_hdr.status in the below
>>> function in drivers/infiniband/core/sa_query.c.
>>>
>>> [drivers/infiniband/core/sa_query.c]
>>> static void recv_handler(struct ib_mad_agent *mad_agent, struct
>>> ib_mad_recv_wc *mad_recv_wc)
>>> {
>>>           struct ib_sa_query *query;
>>>           struct ib_mad_send_buf *mad_buf;
>>>
>>>           mad_buf = (void *) (unsigned long) mad_recv_wc->wc->wr_id;
>>>           query = mad_buf->context[0];
>>>
>>>           if (query->callback) {
>>>                   if (mad_recv_wc->wc->status == IB_WC_SUCCESS) {
>>>                           query->callback(query,
>>>
>>> mad_recv_wc->recv_buf.mad->mad_hdr.status ? -EINVAL : 0,
>>>                                           (struct ib_sa_mad *)
>>> mad_recv_wc->recv_buf.mad);
>>>
>>> How do I find out what 3 in mad_recv_wc->recv_buf.mad->mad_hdr.status
>>> stands for ?
>> You would need to look in the IB spec.  Note that the status field is 
>> 16-bits and should be in big endian order.  Assuming, therefore, that 
>> the '3' falls into the upper bits of the status field, this would be 
>> an SA specific status value of ERR_NO_RECORDS.
> Yes, it is 0x300. My display was in little endian order.
>>
>>> To test RDS reconnect time we are rebooting one of the switch connected
>>> to one port of the bonding driver.
>>> It then fails over to the other port, RDMA CM gets notified which then
>>> notifies RDS.
>>> RDS initiates a reconnect.   rdma_resolve_route results in these 
>>> errors.
>>> There are some 25 connections that try to failover at the same time.
>>> We get this error for a couple of seconds and finally the
>>> rdma_resolve_route succeeds.
>>> Some of them succeed right away. So it may be due to the load generated
>>> by too many rdma_resolve_route.
>> You may need to back up and see what rdma_resolve_addr returns in the 
>> cases where rdma_resolve_route fails, and compare that with 
>> rdma_resolve_addr when rdma_resolve_route succeeds.  Maybe there's be 
>> a timing issue with the SA detecting the switch failure.  Can you 
>> tell if the RDS traffic is actually migrating to the new ports?
> Ok. I will check what rdma_resolve_addr returns and compare it with a 
> successful case.
> Some other connections completed successfully over the new port during 
> the same period and traffic did go through successfully over them.
>> -Sean 
> Venkat
rdma_resolve_addr returned the old GID for the destination IP during 
these rdma_resolve_route failures.
Then we found the arp entry for these destination IPs continued pointing 
to the old GID and did not get updated with the failed over GID.
Aren't they supposed to be updated through gratuitous arp on a failover 
? Looks like some entries did not get updated.
Anyway this is a missing arp entry update issue now. Nothing to do with 
rdma_resolve_*. ping over ipoib also shows the same failure.
For testing purpose we tried flushing the arp table right after the 
failover so that arp requests go out right away and relearn the new GID.
That worked fine.

Venkat

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
