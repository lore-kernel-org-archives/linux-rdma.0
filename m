From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Tue, 8 Sep 2015 15:32:11 +0300
Message-ID: <55EED54B.7090608@dev.mellanox.co.il>
References: <20150906064550.GA30683@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150906064550.GA30683-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/6/2015 9:45 AM, Christoph Hellwig wrote:
> Hi All,
>
> right now RDMA/CM works on a QP basis, but seems very awakward if you
> want multiple QPs as part of a single logical device, which will be
> useful for a lot of modern protocols.  For example we will need to check
> in the CM handler that we're not getting a different ib_device if we
> want to apply the device limit in any sort of global scope, and it's
> generally very hard to get a struct ib_device that can be used as
> a driver model parent.
>
> Is there any interest in trying to add an API to the CM to do a single
> address resolution and allocate multiple QPs with these checks in
> place?

Hi Christoph,

The CM is responsible of establishing an RDMA channel. What you are
referring to is a concept of a session. I'm not entirely sure how we can
fit a model where the CM establishes a multi-channel session as the
CM request contains a (single) source QPN. So there is a 1-1
relationship between a cm_id and a queue-pair. The device handle depends
on the address resolution to the end-node.

I assume we can think of some form of an rdma_session which will manage
multiple cm_id's (that belongs to a single address resolution), call
the ULP to allocate their corresponding queue-pairs and send a connect 
request for each one. Such an rdma_session can verify the same ib_device
handle on all the cm_id's. But I'm not sure how such a concept would
impact on aspects such as event handling etc...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
