From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/qib: remove redundant setting of any in for-loop
Date: Fri, 20 Oct 2017 00:35:51 -0700
Message-ID: <1508484951.6806.46.camel@perches.com>
References: <20171020072103.10337-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020072103.10337-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-10-20 at 09:21 +0200, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> The variable all is being set but is never read after this
> hence it can be removed from the for loop initialization.
> Cleans up clang warning:

any is really used as bool and is initialized at function
entry.  The earlier loop also reinitializes any unnecessarily.

> drivers/infiniband/hw/qib/qib_file_ops.c:640:7: warning: Value
> stored to 'any' is never read
> 
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
> index 2d6a191afec0..b5c2e4223ee7 100644
> --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> @@ -637,7 +637,7 @@ static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
>  		ret = -EBUSY;
>  		goto bail;
>  	}
> -	for (any = i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
> +	for (i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
>  		if (!ppd->pkeys[i] &&
>  		    atomic_inc_return(&ppd->pkeyrefs[i]) == 1) {
>  			rcd->pkeys[pidx] = key;

Perhaps the function is better written without
the empty bail: label and without setting ret
and just using return.

Combining the int/bool conversion of any and the
direct returns seems clearer to me.

Something like:
---
 drivers/infiniband/hw/qib/qib_file_ops.c | 70 ++++++++++++--------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 2d6a191afec0..8078854e1cd6 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -568,20 +568,17 @@ static int qib_tid_free(struct qib_ctxtdata *rcd, unsigned subctxt,
 static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
 {
 	struct qib_pportdata *ppd = rcd->ppd;
-	int i, any = 0, pidx = -1;
+	int i;
+	bool any = false;
+	int pidx = -1;
 	u16 lkey = key & 0x7FFF;
-	int ret;
 
-	if (lkey == (QIB_DEFAULT_P_KEY & 0x7FFF)) {
-		/* nothing to do; this key always valid */
-		ret = 0;
-		goto bail;
-	}
+	/* nothing to do; this key always valid */
+	if (lkey == (QIB_DEFAULT_P_KEY & 0x7FFF))
+		return 0;
 
-	if (!lkey) {
-		ret = -EINVAL;
-		goto bail;
-	}
+	if (!lkey)
+		return -EINVAL;
 
 	/*
 	 * Set the full membership bit, because it has to be
@@ -594,18 +591,15 @@ static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
 	for (i = 0; i < ARRAY_SIZE(rcd->pkeys); i++) {
 		if (!rcd->pkeys[i] && pidx == -1)
 			pidx = i;
-		if (rcd->pkeys[i] == key) {
-			ret = -EEXIST;
-			goto bail;
-		}
-	}
-	if (pidx == -1) {
-		ret = -EBUSY;
-		goto bail;
+		if (rcd->pkeys[i] == key)
+			return -EEXIST;
 	}
-	for (any = i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
+	if (pidx == -1)
+		return -EBUSY;
+
+	for (i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
 		if (!ppd->pkeys[i]) {
-			any++;
+			any = true;
 			continue;
 		}
 		if (ppd->pkeys[i] == key) {
@@ -613,44 +607,34 @@ static int qib_set_part_key(struct qib_ctxtdata *rcd, u16 key)
 
 			if (atomic_inc_return(pkrefs) > 1) {
 				rcd->pkeys[pidx] = key;
-				ret = 0;
-				goto bail;
-			} else {
-				/*
-				 * lost race, decrement count, catch below
-				 */
-				atomic_dec(pkrefs);
-				any++;
+				return 0;
 			}
+			/* lost race, decrement count, catch below */
+			atomic_dec(pkrefs);
+			any = true;
 		}
-		if ((ppd->pkeys[i] & 0x7FFF) == lkey) {
+		if ((ppd->pkeys[i] & 0x7FFF) == lkey)
 			/*
 			 * It makes no sense to have both the limited and
 			 * full membership PKEY set at the same time since
 			 * the unlimited one will disable the limited one.
 			 */
-			ret = -EEXIST;
-			goto bail;
-		}
-	}
-	if (!any) {
-		ret = -EBUSY;
-		goto bail;
+			return -EEXIST;
 	}
-	for (any = i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
+	if (!any)
+		return -EBUSY;
+
+	for (i = 0; i < ARRAY_SIZE(ppd->pkeys); i++) {
 		if (!ppd->pkeys[i] &&
 		    atomic_inc_return(&ppd->pkeyrefs[i]) == 1) {
 			rcd->pkeys[pidx] = key;
 			ppd->pkeys[i] = key;
 			(void) ppd->dd->f_set_ib_cfg(ppd, QIB_IB_CFG_PKEYS, 0);
-			ret = 0;
-			goto bail;
+			return 0;
 		}
 	}
-	ret = -EBUSY;
 
-bail:
-	return ret;
+	return -EBUSY;
 }
 
 /**
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
