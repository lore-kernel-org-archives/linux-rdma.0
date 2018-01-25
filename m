From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] IB/mthca: Fix how mthca_map_user_db() calls gup
Date: Thu, 25 Jan 2018 11:27:27 -0800
Message-ID: <20180125192727.dkwuqel3xfut66wj@linux-n805>
References: <20180123205459.432-1-dave@stgolabs.net>
 <1516898063.27592.136.camel@redhat.com>
 <20180125175048.GG10706@ziepe.ca>
 <1516903584.27592.183.camel@redhat.com>
 <20180125185330.GH10706@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125185330.GH10706-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 25 Jan 2018, Jason Gunthorpe wrote:

>>
>> Since the original post was referred to an ABBA deadlock, wouldn't we
>> have to drop db_tab->mutex, then grab both in the proper order?
>
>I had understood that was only a concern because Davidlohr was having
>trouble proving the callchain didn't include mmap_sem already..
>
>I can see the call chain all ends on verbs ops, and I know verbs ops
>with ucontext's are never called under mmap_sem by the core code..

Right. Ok so this simplifies things and we can just use gup_fast().

Thanks,
Davidlohr

---8<---------------------------------------------------
[PATCH v2] IB/mthca: Fix gup usage in mthca_map_user_db()

get_user_pages() must be called with mmap_sem held, currently
it is not. In fact it is called under the user db_table->mutex.
To fix this we can convert gup to use the fast alternative,
and safely avoid taking mmap_sem, if possible. Furthermore
this is safe wrt to the mutex as other callers that take the
lock (unmap and alloc_db) are not called under mmap_sem
(hence possible deadlock).

Signed-off-by: Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_memfree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index c6fe89d79248..9a412738d5c3 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -472,7 +472,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		goto out;
 	}
 
-	ret = get_user_pages(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages, NULL);
+	ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages);
 	if (ret < 0)
 		goto out;
 
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
