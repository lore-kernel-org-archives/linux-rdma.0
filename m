From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [QUESTION] IB/ipoib: IB_DEVICE_UD_IP_CSUM & NETIF_F_SG
Date: Thu, 14 Jul 2016 12:57:14 +0300
Message-ID: <20160714095714.GA13573@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
Looking at ipoib_set_dev_features().
Any idea why NETIF_F_SG depends on IB_DEVICE_UD_IP_CSUM?

Thanks,
Yuval
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
