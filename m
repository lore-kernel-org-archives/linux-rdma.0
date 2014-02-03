From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Need help with strange mlx4_core error
Date: Mon, 3 Feb 2014 07:35:46 +0400
Message-ID: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all. After switching to kernel 3.10 i get sometimes errors in dmesg
like this:
[Sun Jan 26 09:58:50 2014] <mlx4_ib> destroy_qp_common: modify QP
007def to RESET failed.
[Sun Jan 26 20:27:52 2014] <mlx4_ib> destroy_qp_common: modify QP
0221ca to RESET failed.
[Mon Jan 27 03:44:20 2014] <mlx4_ib> destroy_qp_common: modify QP
0232ad to RESET failed.
[Mon Jan 27 14:23:25 2014] mlx4_core 0000:03:00.0: command 0x19
failed: fw status = 0x9
[Mon Jan 27 14:23:25 2014] ib0: failed to modify QP to INIT: -9
[Mon Jan 27 16:37:00 2014] <mlx4_ib> destroy_qp_common: modify QP
00258a to RESET failed.
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0: Internal error detected:
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[00]: 001805a5
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[01]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[02]: 20060384
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[03]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[04]: 0018050c
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[05]: 00000001
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[06]: 00002cd4
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[07]: 00000084
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[08]: 0000f8af
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[09]: 00004000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[0a]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[0b]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[0c]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[0d]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[0e]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_core 0000:03:00.0:   buf[0f]: 00000000
[Mon Jan 27 16:58:26 2014] mlx4_en 0000:03:00.0: Internal error
detected, restarting device
[Mon Jan 27 16:58:35 2014] <mlx4_ib> destroy_qp_common: modify QP
002cd4 to RESET failed.
[Mon Jan 27 16:58:35 2014] ib0: dev_queue_xmit failed to requeue packet
[Mon Jan 27 16:58:35 2014] ib0: dev_queue_xmit failed to requeue packet
[Mon Jan 27 16:58:35 2014] ib0: dev_queue_xmit failed to requeue packet
[Mon Jan 27 16:58:36 2014] mlx4_core: Initializing 0000:03:00.0
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 59 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 60 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 61 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 62 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 63 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 64 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 65 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 66 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 67 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 68 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 69 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 70 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: irq 71 for MSI/MSI-X
[Mon Jan 27 16:58:38 2014] mlx4_core 0000:03:00.0: command 0xc failed:
fw status = 0x40
[Mon Jan 27 16:58:38 2014] mlx4_en 0000:03:00.0: UDP RSS is not
supported on this device.

I don't know what traffic can trigger this (i'm using IPoIB with
connected mode) but i think this can happening then someone send
massive udp traffic.
What can i do to fix this issue? When error appears ib0 device (IPoIB)
goes to down.

Very big thanks for all help.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
