From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] IB/ipoib: fix for rare multicast join race condition.
Date: Mon, 8 Feb 2016 12:23:07 +0000
Message-ID: <F3529576D8E232409F431C309E29399328F6C7FE@CRSMSX102.amr.corp.intel.com>
References: <20160206135041.11630.77019.stgit@phlsvlogin03.ph.intel.com>
 <20160206171828.GD8584@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160206171828.GD8584-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

> A number of very minor comments:
> 1. Please remove dot at the end of commit message title.
> 
Ok. Thanks.

> 2. This function declared as a void, it is an error to add "return 0".
> 
ipoib_mcast_join() is declared as int.  Please see a very first change.

> -static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
> +static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)

> 3. There is no need to compare with 0. Just use "if (ipoib...(...))"
> construction.
Ok. No problem.

Thanks,
Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
