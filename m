From: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Subject: Re: ibv_req_notify_cq and multithreading
Date: Fri, 13 Jan 2012 09:10:01 +0100
Message-ID: <4F0FE6D9.4050403@list-group.com>
References: <4F0EC562.2040709@list-group.com> <1828884A29C6694DAF28B7E6B8A8237325676B8F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325676B8F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Il 1/12/2012 16:52 PM, Hefty, Sean ha scritto:
>> I'm trying to have N threads reading from the same completion channel, bounded
>> to M completion queues. I would like to
>> have N<<  M, and to ensure that only a single thread at time can call
>> ibv_poll_cq() on a given queue, to process the
>> events in the same order they were put in the queue.
>>
>> I can't understand how to properly achieve this, since:
>> 1- If I call ibv_req_notify_cq() before ibv_poll_cq(), I might end up with two
>> threads polling the same queue.
>> 2- If I call ibv_req_notify_cq() after ibv_poll_cq(), I could end up with
>> events in the cq not being notified in the
>> channel (I read this on the IBTA 11.4.2.2, and I *think* I actually
>> experienced this under load).
>>
>> I can use option 1 with an additional lock before ibv_req_notify_cq(), but I
>> would like to know if there is a simpler
>> way which I can't see.
>
> I can't think of a simpler way.  You just don't have any idea which CQ will be returned from the completion channel.  Does your traffic pattern work to create N completion channels and distributed the CQs among them?
> --

Each CQ is related to a separate connection; putting two on the same channel, and making a single thread read the 
channel, would force an arbitrary coupling between connections which I'm trying to avoid.
Point 2 is correct though? ibv_req_notify_cq() should be called before ibv_poll_cq()?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
