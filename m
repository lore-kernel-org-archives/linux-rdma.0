From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] New libmlx5-1.2.1 release
Date: Wed, 20 Jul 2016 19:18:59 +0300
Message-ID: <ca9d314c-8f17-43b3-f368-7d94c0fe0676@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

An updated version of libmlx5 has been released.

The new source code is available at the official git repo:
git://openfabrics.org/~yishaih/libmlx5.git

Tarball is available for download at:
http://www.openfabrics.org/downloads/mlx5

Highlights of changes in this release:

Addition of support for Memory window.
Addition of support for MR re-registration.
Addition of support for raw packet QP.
Addition of support for TX/RX checksum offloads for raw packet QP.
Addition of support for completion timestamp.
Addition of support for atomic operations.
Addition of support for create/destroy flow.
Addition of support to block reception of multicast packets you send.
Addition of support to scatter extended frame check on raw packet QP.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
