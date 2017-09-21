From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Is ib_mtu iboe_get_mtu() slightly off?
Date: Wed, 20 Sep 2017 17:38:43 -0700
Message-ID: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have:

static inline enum ib_mtu iboe_get_mtu(int mtu)
{
        /*
         * reduce IB headers from effective IBoE MTU. 28 stands for
         * atomic header which is the biggest possible header after BTH
         */
        mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 28;
       ...

28 bytes is the size of the AtomicETH header.  But couldn't we have a
packet with both AtomicETH and XRCETH (4 more bytes)?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
