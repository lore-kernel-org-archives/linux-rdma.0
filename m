From: "eagle.rtlinux" <eagle.rtlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Infiniband coding mistake fixed.
Date: Mon, 15 Sep 2014 21:22:20 +0800
Message-ID: <5416E80C.7010705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eagle.rtlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

hello,

The last parameter of get_user_pages should be a array of pointers to 
vmas corresponding to each page. Through this coding mistake can not 
cause some problem now, it is a potential time bomb.

Signed-off-by: Yang Honggang <eagle.rtlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
  drivers/infiniband/hw/qib/qib_user_pages.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c 
b/drivers/infiniband/hw/qib/qib_user_pages.c
index 2bc1d2b..e93d459 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -69,7 +69,7 @@ static int __qib_get_user_pages(unsigned long 
start_page, size_t num_pages,
          ret = get_user_pages(current, current->mm,
                       start_page + got * PAGE_SIZE,
                       num_pages - got, 1, 1,
-                     p + got, vma);
+                     p + got, vma + got);
          if (ret < 0)
              goto bail_release;
      }
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
