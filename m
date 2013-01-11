From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: Distributing IPoIB interrupts
Date: Fri, 11 Jan 2013 15:48:51 -0500
Message-ID: <CAPb9-SHHoBbYfKSzwck45j3HzXUVoo73fffAafBMexn7riff2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

One of my colleagues has been trying to benchmark the maximum
performance of Mellanox ConnectX-3 Infiniband cards using IP over IB.
He was able to use smp_affinity to distribute Ethernet packet-receive
interrupts across many cores, and specify on which cores the
interrupts occurred. With IPoIB, smp_affinity successfully moved
interrupts to a specific core, but he was unable to distribute the
IPoIB interrupts onto multiple cores. Is there a design detail of how
IPoIB works that prevents this? Does anyone know of a setting,
configuration value, or feature that we're overlooking to allow this,
or is it impossible? Thanks in advance for your feedback.

Sincerely,
Christopher
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
