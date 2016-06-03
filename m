From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/hfi1: Fix indentation
Date: Fri, 3 Jun 2016 15:26:39 -0400
Message-ID: <20160603192638.GA946@phlsvsds.ph.intel.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com> <54ad6b3b-4185-9345-26d0-ab3fd9ce36e4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54ad6b3b-4185-9345-26d0-ab3fd9ce36e4-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 03, 2016 at 12:09:56PM -0700, Bart Van Assche wrote:
> #define C_MAX_NAME 13 /* 12 chars + one for /0 */
>diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
>index 5cc492e..0d28a5a 100644
>--- a/drivers/infiniband/hw/hfi1/init.c
>+++ b/drivers/infiniband/hw/hfi1/init.c
>@@ -1337,7 +1337,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
> 		dma_free_coherent(&dd->pcidev->dev, sizeof(u64),
> 				  (void *)dd->rcvhdrtail_dummy_kvaddr,
> 				  dd->rcvhdrtail_dummy_physaddr);
>-				  dd->rcvhdrtail_dummy_kvaddr = NULL;
>+		dd->rcvhdrtail_dummy_kvaddr = NULL;
> 	}
> 
> 	for (ctxt = 0; tmp && ctxt < dd->num_rcv_contexts; ctxt++) {

This is the same thing as a patch from Dan Carpenter I think?
https://patchwork.kernel.org/patch/9139133/

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
