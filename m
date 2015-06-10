From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/core: Don't warn on no SA support in event handler
Date: Wed, 10 Jun 2015 15:28:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE66CA@ORSMSX109.amr.corp.intel.com>
References: <1433927612-20517-1-git-send-email-monis@mellanox.com>
 <55780D8C.1070600@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55780D8C.1070600-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Registering an event handler is done for a device. This device may have
> > one RoCE port (no SA cap) and one InfiniBand port (has SA cap).
> > Therefore, warning from the event handler about a specific port that
> > doesn't have SA cap is correct but pollutes the kernel log without a
> > need.
> 
> Maybe we should think about register event handler per port :-P

I agree, though I think that can be added separately from this change.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
