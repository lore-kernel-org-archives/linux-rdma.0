From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/ipoib: Limit call to free rdma_netdev for
 capable devices
Date: Tue, 27 Jun 2017 12:08:38 -0700
Message-ID: <20170627190838.GA55990@knc-06.sc.intel.com>
References: <20170614065909.23650-1-leon@kernel.org>
 <20170614065909.23650-3-leon@kernel.org>
 <20170627173407.GA55945@knc-06.sc.intel.com>
 <20170627174156.GA5340@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170627174156.GA5340-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 27, 2017 at 11:41:56AM -0600, Jason Gunthorpe wrote:
>On Tue, Jun 27, 2017 at 10:34:07AM -0700, Vishwanathapura, Niranjana wrote:
>> >diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> >index 0ddd9709e1df..91fae34bdd4f 100644
>> >+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> >@@ -2301,7 +2301,10 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
>> >		flush_workqueue(priv->wq);
>> >
>> >		unregister_netdev(priv->dev);
>> >-		free_netdev(priv->dev);
>> >+		if (device->free_rdma_netdev)
>> >+			device->free_rdma_netdev(priv->dev);
>> >+		else
>> >+			free_netdev(priv->dev);
>>
>> This is causing an crash in hfi1 driver.
>> If the call to alloc_rdma_netdev() has returned -EOPNOTSUPP, we shouldn't be
>> calling free_rdma_netdev() here (as device driver doesn't own that netdev).
>> I will send out a patch to hfi1 driver to guard check for the type in its
>> free_rdma_netdev() call to handle such issues.
>
>I think instead you should move free_rdma_netdev from struct ib_device
>to struct rdma_netdev to prevent this mistake in general.
>

Thanks, that is another option. With that, we will be freeing the rdma_netdev 
from a function pointer call that belongs to that rdma_netdev. Is that ok?  
(Though I think it should work fine).

Also, I think this needs updating ib_verbs.h, hfi1, ipoib and mlx5 (under 
drivers/net) together. I can make the change, if this is the direction we are 
taking.

Another option is to add a new type RDMA_NETDEV_IPOIB_DEF and use only within 
ipoib driver to differentiate default case.

Thanks,
Niranjana

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
