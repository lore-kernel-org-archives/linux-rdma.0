From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 37/37] add Kconfig
Date: Fri, 5 Aug 2011 20:44:24 +0200
Message-ID: <CAO+b5-oFKiAhTkCntAo5_mMCtdg1vb1eM_mTi-8E-T_atHa_3w@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.966262587@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.966262587-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
+config INFINIBAND_RXE
+	tristate "Software RDMA over Ethernet (RoCE) driver"
+	depends on INET && PCI && INFINIBAND
+	---help---
+	This driver implements the InfiniBand RDMA transport over
+	the Linux network stack. It enables a system with a

Shouldn't that read "an Ethernet network" instead of "the Linux network stack" ?

+	standard Ethernet adapter to interoperate with a RoCE
+	adapter or with another system running the RXE driver.
+	Documentation on InfiniBand and RoCE can be downloaded at
+	www.infinibandta.org and www.openfabrics.org. (See also
+	siw which is a similar software driver for iWARP.)

Isn't RoCE an official IBTA standard ? If so, seems like a good idea
to me to mention that here.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
