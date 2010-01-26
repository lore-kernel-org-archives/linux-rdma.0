From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: Re: infiniband limit of 32 cards per system?
Date: Tue, 26 Jan 2010 15:03:33 -0700
Message-ID: <20100126220333.GB12035@ldl.fc.hp.com>
References: <20100125235013.GD2828@grease.ALLEYCAT> <adaiqapplv7.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaiqapplv7.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

* Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>:
> 
>  > If that enum is indeed the limiting factor, would someone
>  > mind explaining (or pointing me at TFM ;) why it's limited
>  > to 32 devices?
> 
> That dates back to when device #s had 8 bits for major and 8
> bits for minor.  We got one major assigned for IB, and had to
> split up the 256 minors that gave us among userspace verbs,
> management access, etc.  And 32 seemed like a pretty reasonable
> limit for most uses.

Hm...

        IB_UMAD_MAX_PORTS  = 64,
        IB_UMAD_MAJOR      = 231,
        IB_UMAD_MINOR_BASE = 0
	register_chrdev_region(base_dev, IB_UMAD_MAX_PORTS * 2, "infiniband_mad");

        IB_UVERBS_MAJOR       = 231,
        IB_UVERBS_BASE_MINOR  = 192,
        IB_UVERBS_MAX_DEVICES = 32
	register_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES, "infiniband_verbs");

        IB_UCM_MAJOR = 231,
        IB_UCM_BASE_MINOR = 224,
        IB_UCM_MAX_DEVICES = 32
	register_chrdev_region(IB_UCM_BASE_DEV, IB_UCM_MAX_DEVICES, "infiniband_cm");

It looks like we have a hole from [128, 192).

Would it be something as simple as this?

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uve
index 5f284ff..b9aa2b8 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -57,8 +57,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 enum {
        IB_UVERBS_MAJOR       = 231,
-       IB_UVERBS_BASE_MINOR  = 192,
-       IB_UVERBS_MAX_DEVICES = 32
+       IB_UVERBS_BASE_MINOR  = 128,
+       IB_UVERBS_MAX_DEVICES = 64
 };
 
 #define IB_UVERBS_BASE_DEV     MKDEV(IB_UVERBS_MAJOR, IB_UVERBS_BASE_MINOR)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
