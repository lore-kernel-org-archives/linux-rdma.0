From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH rdma-core 0/4] ibacm fixes relating to interface iteration
Date: Wed, 25 Oct 2017 09:40:30 -0400
Message-ID: <0140f374-d3c6-43b5-f424-01a7e1b93f76@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A couple of trivial patches to improve some ACM log messages:
	acm_util.c: Better log message when ioctl fails in acm_if_iter_sys
	In acm.c:acm_open_providers, cosmetic change to log message

and patch to better iterate interfaces when IPv6 is disabled in kernel:
	In acm_util.c:acm_if_iter_sys, try IPv4 if IPv6 doesn't find any appropriate interfaces
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
