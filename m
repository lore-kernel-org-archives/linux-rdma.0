From: Shamir Rabinovith <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] librdmacm: lazy initialization for ib devices]
Date: Thu, 27 Mar 2014 10:23:26 +0200
Message-ID: <20140327082325.GA5006@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

----- Forwarded message from Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> -----

So what exact capability is under the spot here? and how it's related
to a certain HCA driver and not to the kernel uverbs layer?

----- End forwarded message -----

ibv_open_device fail when opening the hca many times. ucma_init call
this api a-priori on all the devices for any process that use the
library. The patch remove this a-priori open and open the device only
when verbs are really needed. I do not think its issue at the verbs
but more issue in how the librdmacm use the verbs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
