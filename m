From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Tue, 4 Aug 2015 12:09:33 -0600
Message-ID: <20150804180933.GB5038@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com>
 <20150803152420.GA24193@infradead.org>
 <55BFB40F.8000500@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BFB40F.8000500-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 03, 2015 at 11:33:51AM -0700, Bart Van Assche wrote:
> >Bart, do you know what hardware this workaround is for?
> 
> I hope the HW vendors can comment on this. Sorry but I'm not sure which HCA
> models and/or firmware versions do not support FMR mapping with a non-zero
> offset.

Perhaps David can remember why he added this:

commit 8f26c9ff9cd0317ad867bce972f69e0c6c2cbe3c
    IB/srp: rework mapping engine to use multiple FMR entries
    
+       /* If we start at an offset into the FMR page, don't merge into
+        * the current FMR. Finish it out, and use the kernel's MR for this
+        * sg entry. This is to avoid potential bugs on some SRP targets
+        * that were never quite defined, but went away when the initiator
+        * avoided using FMR on such page fragments.
+        */
+       if (dma_addr & ~dev->fmr_page_mask || dma_len > dev->fmr_max_size) {
+               ret = srp_map_finish_fmr(state, target);
+               if (ret)
+                       return ret;
+
+               srp_map_desc(state, dma_addr, dma_len, target->rkey);
+               srp_map_update_start(state, NULL, 0, 0);
+               return 0;
        }

The way it is phrased makes it seem like a target bug, not a HCA bug?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
