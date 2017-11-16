From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Thu, 16 Nov 2017 11:13:29 -0700
Message-ID: <20171116181329.GB20056@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-7-leon@kernel.org>
 <20171115001510.GG25894@ziepe.ca>
 <CAAk-MO-QQj3_H2CZuCCOCU51tWwdCfkvhh-Q3LqrKM=Su2Q+Kg@mail.gmail.com>
 <20171115153946.GP25894@ziepe.ca>
 <CAAk-MO-nMs-+RtK_QOxPzq7uCA9hpG30ho52v4CSRPZ6769=1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO-nMs-+RtK_QOxPzq7uCA9hpG30ho52v4CSRPZ6769=1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 10:30:15AM +0200, Erez Shitrit wrote:

> > It needs to work in a way where it looks up a DGID from the LLADDR and
> > gets back a wire GRH and LRH which come from SA.
> 
> For that there is the ah object, this object is used as it came from the SA.

Okay, that makes sense. This is such an important point, the patch
description really should have explored it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
