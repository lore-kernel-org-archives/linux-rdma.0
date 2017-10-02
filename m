From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [bug report] IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage
Date: Mon, 2 Oct 2017 13:00:29 +0200
Message-ID: <CAK8P3a1t6zyQXtfov6HguOb9V7E4i54pK8+y8BjPqGqvsc9mpQ@mail.gmail.com>
References: <20171002101309.dpxylk77ud5gsr2i@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002101309.dpxylk77ud5gsr2i@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 2, 2017 at 12:13 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Arnd Bergmann,
>
> The patch 12f727721eee: "IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL
> usage" from Sep 6, 2017, leads to the following static checker
> warning:
>
>         drivers/infiniband/core/uverbs_std_types.c:249 create_udata()
>         error: uninitialized symbol 'inbuf'.
>
> drivers/infiniband/core/uverbs_std_types.c
>    222  static void create_udata(struct uverbs_attr_bundle *ctx,
>    223                           struct ib_udata *udata)
>    224  {
>    225          /*
>    226           * This is for ease of conversion. The purpose is to convert all drivers
>    227           * to use uverbs_attr_bundle instead of ib_udata.
>    228           * Assume attr == 0 is input and attr == 1 is output.
>    229           */
>    230          void __user *inbuf;
>    231          size_t inbuf_len = 0;
>    232          void __user *outbuf;
>    233          size_t outbuf_len = 0;
>    234          const struct uverbs_attr *uhw_in =
>    235                  uverbs_attr_get(ctx, UVERBS_UHW_IN);
>    236          const struct uverbs_attr *uhw_out =
>    237                  uverbs_attr_get(ctx, UVERBS_UHW_OUT);
>    238
>    239          if (!IS_ERR(uhw_in)) {
>    240                  inbuf = uhw_in->ptr_attr.ptr;
>    241                  inbuf_len = uhw_in->ptr_attr.len;
>    242          }
>    243
>    244          if (!IS_ERR(uhw_out)) {
>    245                  outbuf = uhw_out->ptr_attr.ptr;
>    246                  outbuf_len = uhw_out->ptr_attr.len;
>    247          }
>    248
>    249          ib_uverbs_init_udata_buf_or_null(udata, inbuf, outbuf, inbuf_len,
>    250                                           outbuf_len);
>
> In the original code, this was a macro so smatch understood that we
> don't use inbuf and outbuf if they aren't initialized.  Now it's a
> function and smatch generates a warning if you pass uninitialized
> variables to a function.
>
> It's not a bug, but it's really ugly.

I see. Should we maybe open-code the ib_uverbs_init_udata_buf_or_null()
call in this function?

diff --git a/drivers/infiniband/core/uverbs_std_types.c
b/drivers/infiniband/core/uverbs_std_types.c
index b095bce7f238..039802ae7332 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -227,27 +227,26 @@ static void create_udata(struct uverbs_attr_bundle *ctx,
         * to use uverbs_attr_bundle instead of ib_udata.
         * Assume attr == 0 is input and attr == 1 is output.
         */
-       void __user *inbuf;
-       size_t inbuf_len = 0;
-       void __user *outbuf;
-       size_t outbuf_len = 0;
        const struct uverbs_attr *uhw_in =
                uverbs_attr_get(ctx, UVERBS_UHW_IN);
        const struct uverbs_attr *uhw_out =
                uverbs_attr_get(ctx, UVERBS_UHW_OUT);

        if (!IS_ERR(uhw_in)) {
-               inbuf = uhw_in->ptr_attr.ptr;
-               inbuf_len = uhw_in->ptr_attr.len;
+               udata->inbuf = uhw_in->ptr_attr.ptr;
+               udata->inbuf_len = uhw_in->ptr_attr.len;
+       } else {
+               udata->inbuf = NULL;
+               udata->inbuf_len = 0;
        }

        if (!IS_ERR(uhw_out)) {
-               outbuf = uhw_out->ptr_attr.ptr;
-               outbuf_len = uhw_out->ptr_attr.len;
+               udata->outbuf = uhw_out->ptr_attr.ptr;
+               udata->outbuf_len = uhw_out->ptr_attr.len;
+       } else {
+               udata->outbuf = NULL;
+               udata->outbuf_len = 0;
        }
-
-       ib_uverbs_init_udata_buf_or_null(udata, inbuf, outbuf, inbuf_len,
-                                        outbuf_len);
 }

 static int uverbs_create_cq_handler(struct ib_device *ib_dev,

       Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
