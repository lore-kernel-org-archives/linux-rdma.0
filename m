From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/ipath: fix error return code in
 ipath_register_ib_device()
Date: Wed, 27 Mar 2013 14:41:59 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0DF6AB22@FMSMSX108.amr.corp.intel.com>
References: <CAPgLHd-ZH-DTBKHBfppYX409qLddst46dXkZ_dn5c2i_A+YCQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPgLHd-ZH-DTBKHBfppYX409qLddst46dXkZ_dn5c2i_A+YCQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org" <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -	if (ipath_verbs_register_sysfs(dev))

I would suggest modifying ipath_verbs_register_sysfs() to correctly return the failure from device_create_file() in ret out of ipath_verbs.c:

static int ipath_verbs_register_sysfs(struct ib_device *dev)
{
        int i;
        int ret;

        for (i = 0; i < ARRAY_SIZE(ipath_class_attributes); ++i)
                if (device_create_file(&dev->dev, <------------------------------
                                       ipath_class_attributes[i])) {
                        ret = 1;
                        goto bail;
                }

        ret = 0;

bail:
        return ret;
}

With that fixed the caller should assign and return ret.

The qib_verbs_register_sysfs() is fixed:

/*
 * Register and create our files in /sys/class/infiniband.
 */
int qib_verbs_register_sysfs(struct qib_devdata *dd)
{
        struct ib_device *dev = &dd->verbs_dev.ibdev;
        int i, ret;

        for (i = 0; i < ARRAY_SIZE(qib_attributes); ++i) {
                ret = device_create_file(&dev->dev, qib_attributes[i]);
                if (ret)
                        return ret;
        }

        return 0;
}

I will post a patch shortly for qib, which has the same ret flaw in the caller to qib_verbs_register_sysfs().    If you want me to hit both, I can.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
