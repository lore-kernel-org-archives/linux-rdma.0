From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: srp_daemon and cable pulling
Date: Thu, 30 Aug 2012 14:43:01 +0000
Message-ID: <503F7BF5.4050104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

The traditional solution to restore SRP connections in a H.A. setup
after an SRP logout is to have one srp_daemon process running per HCA
port on the initiator. However, srp_daemon stops working if it can't
reach the subnet manager anymore. So it's only useful if a cable between
target and SM has been pulled but not if a cable between initiator and
SM has been pulled. Has anyone been looking into this before ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
