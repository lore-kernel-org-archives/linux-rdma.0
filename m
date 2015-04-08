From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Fixes on top of CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical memory access
Date: Wed,  8 Apr 2015 16:29:59 +0200
Message-ID: <cover.1428502843.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find one patch to prevent a possible issue partially
addressed by commit 8494057ab5e4 ("IB/uverbs: Prevent integer
overflow in ib_umem_get address arithmetic") (see discussions
in [1]) and another one to add back the possibility of registering
memory mapped at 0 (which is probably not something to be allowed,
but it's not up to ib_umem_get() to prevent it).

[1] "Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access"

 http://mid.gmane.org/1428497043.22575.176.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
 http://marc.info/?i=1428497043.22575.176.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Regards.

Yann Droneaud (2):
  IB/core: disallow registering 0-sized memory region
  IB/core: don't disallow registering region starting at 0x0

 drivers/infiniband/core/umem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
