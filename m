From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/srpt: Fix a race condition related to SRP login
Date: Sun, 3 Jan 2016 15:09:57 +0200
Message-ID: <56891DA5.5060506@dev.mellanox.co.il>
References: <5684ED4B.2010303@sandisk.com> <5684EE16.8070701@sandisk.com>
 <20160103105127.GA10025@lst.de> <56890507.9080404@dev.mellanox.co.il>
 <56891BB8.6040502@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56891BB8.6040502-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> But now the first I/O(s) could be lost if no other I/O comes in,
>>> right?  I suspect that we need to keep this loop to protect against
>>> such corner cases.
>>
>> It can happen theoretically, but why do we even bother? Why not just
>> post the recv buffer after we moved in to CH_LIVE? This why we let the
>> RC transport handle the "Recv-Not-Ready" NAK by retrying?
>
> Making wait list processing in the RTU handler safe would require to
> introduce additional locking. Posting receive buffers after the RTU
> event has been received would introduce another race condition because
> then it can happen that an initiator starts sending data before the
> receive buffers have been posted.

And what is the problem with that? The peer HCA will get a RNR_NAK
and retry a pre-configured number of retries (7). The initiator stack
won't feel it at all...

I'd say it's a clean way to go.

> A possible solution would be to  trigger the receive handler after
> the RTU event has been received in
> such a way that all invocations of the receive handler are still
> serialized.

We can also do that, it's less trivial though.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
