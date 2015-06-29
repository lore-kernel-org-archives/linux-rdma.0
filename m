From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 1/5] IB/uverbs: Fix reference counting usage
 of event files
Date: Mon, 29 Jun 2015 11:40:38 -0600
Message-ID: <20150629174038.GB2755@obsidianresearch.com>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com>
 <1434984438-21733-2-git-send-email-yishaih@mellanox.com>
 <20150624175738.GC21033@obsidianresearch.com>
 <558BE9FA.9060402@dev.mellanox.co.il>
 <20150625175228.GF21033@obsidianresearch.com>
 <559005A0.4070800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <559005A0.4070800-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 28, 2015 at 05:33:04PM +0300, Yishai Hadas wrote:

> You are wrong here, we have here balanced put, the first is done as
> part of fput(filp) -> ib_uverbs_event_close_file ->
> kref_put(&file->ref, ib_uverbs_release_event_file) and the second at
> the end of this function as part of the err: label
> kref_put(&ev_file->ref, ib_uverbs_release_event_file);

Ugh, that is so gross, seriously? Sure, the counts work out, but that
is *totally unreadable*.

Sigh, just use this:

 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
                                        int is_async)
 {
        struct ib_uverbs_event_file *ev_file;
        struct file *filp;
+       int ret;
 
-       ev_file = kmalloc(sizeof *ev_file, GFP_KERNEL);
+       ev_file = kzalloc(sizeof(*ev_file), GFP_KERNEL);
        if (!ev_file)
                return ERR_PTR(-ENOMEM);
 
@@ -555,15 +561,41 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
        INIT_LIST_HEAD(&ev_file->event_list);
        init_waitqueue_head(&ev_file->poll_wait);
        ev_file->uverbs_file = uverbs_file;
+       kref_get(&ev_file->uverbs_file->ref);
        ev_file->async_queue = NULL;
-       ev_file->is_async    = is_async;
        ev_file->is_closed   = 0;
 
        filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
                                  ev_file, O_RDONLY);
        if (IS_ERR(filp))
-               kfree(ev_file);
+               goto err_put_refs;
+
+       if (is_async) {
+               WARN_ON(uverbs_file->async_file);
+               uverbs_file->async_file = ev_file;
+               kref_get(&uverbs_file->async_file->ref);
+               INIT_IB_EVENT_HANDLER(&uverbs_file->event_handler,
+                                     uverbs_file->device->ib_dev,
+                                     ib_uverbs_event_handler);
+               ret = ib_register_event_handler(&uverbs_file->event_handler);
+               if (ret)
+                       goto err_put_file;
+
+               /* At that point async file stuff was fully set */
+               ev_file->is_async = 1;
+       }
+
+       return filp;
+
+err_put_file:
+       fput(filp);
+       kref_put(&uverbs_file->async_file->ref, ib_uverbs_release_file);
+       uverbs_file->async_file = NULL;
+       return ERR_PTR(ret);
 
+err_put_refs:
+       kref_put(&ev_file->uverbs_file->ref, ib_uverbs_release_file);
+       kref_put(&ev_file->ref, ib_uverbs_release_event_file);
        return filp;
 }

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
