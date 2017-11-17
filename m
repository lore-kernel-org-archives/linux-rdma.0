From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/5] verbs: Introduce thread domain and its
 related verbs
Date: Fri, 17 Nov 2017 11:42:48 -0700
Message-ID: <20171117184248.GN4276@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-2-git-send-email-yishaih@mellanox.com>
 <20171113195822.GD22610@ziepe.ca>
 <3719edfc-282a-db5b-2474-3cf1355fb301@dev.mellanox.co.il>
 <20171114191754.GI4263@ziepe.ca>
 <774e2f74-8361-6941-a015-27a2014d8cc9@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <774e2f74-8361-6941-a015-27a2014d8cc9-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 11:34:01AM +0200, Yishai Hadas wrote:

> >>ibv_td should expose in verbs.h the 'context' as the inline function
> >>ibv_alloc_td() needs it to get the verbs_context and call the driver
> >>function if was set.
> >
> >You mean ibv_dealloc_td, OK..
> >
> >Related to my other point, ibv_alloc_td should probably accept a
> >ibv_pd as an argument instead.
> >
> 
> Why ibv_alloc_td() should get an ibv_pd ? do you have a typo here ?

No..

Since ibv_alloc_td returns a 'ibv_pd' with additional information, it
makes no sense to have an API that can return an 'ibv_pd' that is not
actually a PD.

So, all TD's have to be created from a PD, and the concept of a TD
without a PD should be entirely removed from the API.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
