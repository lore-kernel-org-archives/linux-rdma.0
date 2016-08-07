From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: Queue ns scanning after a sucessful
 reconnection
Date: Sun, 7 Aug 2016 12:12:35 +0300
Message-ID: <ce424fe1-d6e8-706f-18f8-aa9c880bcdec@grimberg.me>
References: <1469980540-16103-1-git-send-email-sagi@grimberg.me>
 <1470330508.19927.18.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470330508.19927.18.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: J Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> On an ordered target shutdown, the target can send a AEN on a
>> namespace
>> removal, this will trigger the host to queue ns-list query. The
>> shutdown
>> will trigger error recovery which will attepmt periodic reconnect.
>>
>> We can hit a race where the ns rescanning fails (error recovery
>> kicked
>> in and we're not connected) causing removing all the namespaces and
>> when
>> we reconnect we won't see any namespaces for this controller.
>>
>> So, queue a namespace rescan after we successfully reconnected to the
>> target.
>>
>> Note, that unlike user initiated controller reset, we don't need to
>> trigger
>> namespace scanning (until the point I noticed the above at least)
>> because we
>> reconnect to an existing controller. However due to the interaction
>> with
>> the aen mechanism we queue ns scan here as well.
>>
>> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> ---
>> I'm open to other suggestions if anyone has any...
>
> this sounds like a fix that should really go in the core target code
> instead of RDMA code as this could affect any implementation layer.

But it fixes the host behavior (nvme-rdma).

> If the target is shutting down I'm not sure why it would enter error
> recovery which would attempt a reconnect.  If the target is shutting
> down, shut down.  Maybe the keep-alive timer needs to stop
> (nvmet_stop_keep_alive_timer()???). I could see the benefit of the
> target emitting an AEN to tell the host to rescan for namespaces so it
> doesn't keep a stale list of namespaces after shutdown.

Its not the target entering error recovery, its the host. What would
you expect from a host that suddenly was disconnected by the target?
Not sure what other than periodic reconnects would be adequate...

The patch here just requeue ns scanning when we successfully reconnected
to the target that was restored.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
