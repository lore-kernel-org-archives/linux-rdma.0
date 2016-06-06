From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Hang in ipoib_mcast_stop_thread
Date: Mon, 6 Jun 2016 10:57:42 -0600
Message-ID: <20160606165741.GA6413@obsidianresearch.com>
References: <57553DE7.2060009@kyup.com>
 <CAAk-MO_6GMm1AHay4uQ4yZ8HHcH_Dk=Ls5gKSVZUCejexDahLQ@mail.gmail.com>
 <57556866.8040703@kyup.com>
 <CAAk-MO-T_9J2jtX+gtJQXeMVTW6bxbRUrq3mHRepVPatbHFO9g@mail.gmail.com>
 <575575B5.9010504@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <575575B5.9010504-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2016 at 04:08:05PM +0300, Nikolay Borisov wrote:

> Be that as it may, but the queue seems to never be unlocked by the
> driver. Even after restart I still continue to get such messages. One of
> the network admins told me this could happen since the infiniband switch
> port has to be reset after an outage. I find it hard to believe that
> even after physical restart of the server the ib interface cannot connect.

I've also randomly seen apparently hung VL0 credit that could only be
solved by a switch reset. I also was never able to pin down a root
cause. VL15 would work fine..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
