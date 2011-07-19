From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/7] IBoE user space support
Date: Tue, 19 Jul 2011 12:25:48 +0300
Message-ID: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland, the enclosed patch series enhances the user space IB
stack to support IBoE. This work is based on earlier patches
done by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> and posted during
August/2010 see some pointers below.

One notable change from the previous post, is keeping the UD related
resolution between GID to Ethernet L2 address objects (e.g mac, vlan)
within libmlx4. Another patch with notable change is the last, which
aligns libmlx4 with the kernel w.r.t supported devices.

[PATCH 1/7] libibverbs: Add link layer field port attribute
[PATCH 2/7] libibverbs: change kernel API to accept link layer
[PATCH 3/7] libibverbs: add GID change event
[PATCH 4/7] libibverbs: update examples for IBoE

[PATCH 5/7] libmlx4: add IBoE support
[PATCH 6/7] libmlx4: add IBoE UD/VLANs support

[PATCH 7/7] libmlx4: align the list of ConnectX devices supported with the kernel

Or.

libibverbs V10 from August 2010
http://marc.info/?l=linux-rdma&m=128283236815520
http://marc.info/?l=linux-rdma&m=128283237715545
http://marc.info/?l=linux-rdma&m=128283238115562
http://marc.info/?l=linux-rdma&m=128283239215578

libmlx4 V10 from August 2010
http://marc.info/?l=linux-rdma&m=128283239515584
http://marc.info/?l=linux-rdma&m=128283240415602
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
