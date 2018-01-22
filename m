From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 01/17] Update rdma/ib_user_verbs.h
Date: Mon, 22 Jan 2018 08:42:06 -0700
Message-ID: <20180122154206.GC14372@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
 <20180111221340.965-2-jgg@ziepe.ca>
 <fe2337a1-b02d-cc01-c55d-e6e493ec30ef@dev.mellanox.co.il>
 <20180115171033.GA2206@ziepe.ca>
 <c4ee82a7-f235-4370-cf64-d5c73a79bd1b@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c4ee82a7-f235-4370-cf64-d5c73a79bd1b-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 22, 2018 at 12:48:48PM +0200, Yishai Hadas wrote:

> >We could also switch to a more iproute like model where we just
> >unconditionally use our copies of the kernel headers..
> 
> Are you referring to drop the cmake linux header check and always use a
> private copy of the latest kernel UAPI file in rdma-core ? it can make more
> sense comparing to current candidate code.

Yes

> It can reside in a folder named 'rdma' and not installed by rdma-core as
> applications don't use this file. If so we can drop the fixup file and its
> matching check.
>
> What do you think ?

It seems worth doing now, but not as part of this series

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
