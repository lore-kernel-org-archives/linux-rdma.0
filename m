From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes for v3.13
Date: Thu, 19 Dec 2013 09:08:25 -0800
Message-ID: <CAL1RGDUfC38aKqDv7rOnbi3m7PMPC8ze+1kymgrWwNvYHU7e2Q@mail.gmail.com>
References: <cover.1387273677.git.ydroneaud@opteya.com> <CAJZOPZKKg73s6Y+=KD6c8vdDXG0CmkL_gErv=KE-U0jPTSWEjg@mail.gmail.com>
 <1387459287.11925.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387459287.11925.52.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Unfortunately, some patches in V4 were replacement for patches in V3.
> In this particular case, I've rework the commit messages in V4, so these
> changes might be lost.

> And I'm a bit disappointed about this particular patch applied with a
> conflict fix:
>
> https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/commit/?h=for-next&id=2f92baf8313756fd32da4d2a24abc67c8f4f7026
>
>         if (!access_ok(VERIFY_WRITE,
>                        (const void __user *) (unsigned long) ex_hdr.response,
>                        (hdr.out_words + ex_hdr.provider_out_words) * 8))
>                 return -EFAULT;
>
> https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/tree/drivers/infiniband/core/uverbs_main.c?h=for-next&id=2f92baf8313756fd32da4d2a24abc67c8f4f7026#n679
>
> Checking for write access on a pointer to const doesn't sound right.
> It's harmless, and, if sparse/coccinelle doesn't have a check for such,
> it should be added to report a warning.

Sorry for that mistake.  I've fixed that conflict fix to get rid of
the const.  I've also pulled in the changelog updates.

However, I still prefer not moving all the casts out into every place
where we use INIT_UDATA(), so I'd prefer something like the patch
below.  I integrated that into the series and pushed out the result
(since everyone seems OK with rebasing for-next).

Please let me know what you think.

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Date: Thu, 19 Dec 2013 08:37:03 -0800
Subject: [PATCH] IB/uverbs: Set pointers to NULL if length is 0 in
 INIT_UDATA()

Trying to have a ternary operator to choose between NULL (or 0) and the
real pointer value in invocations leads to an impossible choice between
a sparse error about a literal 0 used as a NULL pointer, and a gcc
warning about "pointer/integer type mismatch in conditional expression."

Rather than clutter the source with more casts, move the ternary
operator into the INIT_UDATA() macro, which makes it easier to use and
simplifies its callers.

Reported-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      | 12 ++++++------
 drivers/infiniband/core/uverbs_main.c | 11 ++++-------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 9879568aed8c..d2defbbdb5da 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -47,12 +47,12 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>

-#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)            \
-    do {                                \
-        (udata)->inbuf  = (const void __user *) (ibuf);        \
-        (udata)->outbuf = (void __user *) (obuf);        \
-        (udata)->inlen  = (ilen);                \
-        (udata)->outlen = (olen);                \
+#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)                \
+    do {                                    \
+        (udata)->inbuf  = (ilen) ? (const void __user *) (ibuf) : NULL;    \
+        (udata)->outbuf = (olen) ? (void __user *) (obuf) : NULL;    \
+        (udata)->inlen  = (ilen);                    \
+        (udata)->outlen = (olen);                    \
     } while (0)

 /*
diff --git a/drivers/infiniband/core/uverbs_main.c
b/drivers/infiniband/core/uverbs_main.c
index 34386943ebcf..76b6f217a13e 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -676,15 +676,12 @@ static ssize_t ib_uverbs_write(struct file
*filp, const char __user *buf,
                 return -EINVAL;
         }

-        INIT_UDATA(&ucore,
-               (hdr.in_words) ? buf : 0,
-               (unsigned long)ex_hdr.response,
-               hdr.in_words * 8,
-               hdr.out_words * 8);
+        INIT_UDATA(&ucore, buf, (unsigned long)ex_hdr.response,
+               hdr.in_words * 8, hdr.out_words * 8);

         INIT_UDATA(&uhw,
-               (ex_hdr.provider_in_words) ? buf + ucore.inlen : 0,
-               (ex_hdr.provider_out_words) ? (unsigned
long)ex_hdr.response + ucore.outlen : 0,
+               buf + ucore.inlen,
+               (unsigned long) ex_hdr.response + ucore.outlen,
                ex_hdr.provider_in_words * 8,
                ex_hdr.provider_out_words * 8);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
