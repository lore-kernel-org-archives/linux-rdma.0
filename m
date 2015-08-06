From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next V7 6/6] IB/ucma: HW Device hot-removal support
Date: Thu, 6 Aug 2015 15:36:39 +0000
Message-ID: <HE1PR05MB1418EA195D579C09EB1FB746B1740@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com>
 <1438697008-26209-7-git-send-email-yishaih@mellanox.com>
 <20150804220903.GE10934@obsidianresearch.com>
 <55C22739.5060808@dev.mellanox.co.il>
 <20150805182117.GA15583@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805182117.GA15583-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> 
> I have no real problem with that, it would be nice to have an answer
> to the uverbs vs ucma removal ordering question and the basic issue of
> if we even want to do this so async before merging the driver patch
> that enables it..
> 

I don't think that the order matters.
When you do a surprise removal, you disconnect the application from both ucma and uverbs device references.
In this state, the only thing that the application can do is close all handles.
It doesn't matter if you succeed closing a resource on a device that is still accessible, or "close" an already destroyed resource...

The primary reason for device surprise removal is to recover from device fatal errors or PCI errors.
A quick asynchronous device recovery is exactly what we need, as there is nothing that the application can do more at this state.
This is the most pressing issue that this patch-set solves.

For the administrative removal use case, can consider providing applications a grace period before disconnecting them in a future patch set.
Even here, however, I am not sure that if an administrator decided to remove a device while there are still active applications, we should stall his request.
Anyway, let's get this patch-set done.

> > The first 4 you already review and acked the fifth is in mlx4_ib and has no
> > comments to fix so far - some months in the list.
> 
> Personally, I'm not looking much at drivers..
> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
