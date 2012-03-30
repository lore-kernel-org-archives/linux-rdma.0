From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1 4/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Fri, 30 Mar 2012 17:22:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237345199E92@ORSMSX101.amr.corp.intel.com>
References: <1332814814-7643-1-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-2-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-3-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-4-git-send-email-parav.pandit@emulex.com>
 <ffae965c-1bff-4735-bc2f-db9b026f69e3@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ffae965c-1bff-4735-bc2f-db9b026f69e3-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> - async event handling.

Can you briefly explain how the code synchronizes between async event reporting and the user trying to free the same object?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
