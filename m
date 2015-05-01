From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: Fix unaligned accesses
Date: Fri, 1 May 2015 10:57:18 -0600
Message-ID: <20150501165718.GA17940@obsidianresearch.com>
References: <1430448168-38479-1-git-send-email-david.ahern@oracle.com>
 <20150501162413.GC8531@obsidianresearch.com>
 <5543AACF.7060502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5543AACF.7060502-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 01, 2015 at 10:33:19AM -0600, David Ahern wrote:
> On 5/1/15 10:24 AM, Jason Gunthorpe wrote:
> >>-		data_cmp = cm_compare_private_data(private_data,
> >>+		data_cmp = cm_compare_private_data((u32 *) private_data,
> >>  						   cm_id_priv->compare_data);
> >
> >I'd be happier without this cast, at the worst move it up one more
> >layer, at the best, fix the two impacted structures as well.
> 
> I tried to fix private_data and it blows the patch up.

Add this:

diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index be068f47e47e..a1e8cbf0a234 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -103,7 +103,7 @@ struct cm_req_msg {
        /* local ACK timeout:5, rsvd:3 */
        u8 alt_offset139;
 
-       u8 private_data[IB_CM_REQ_PRIVATE_DATA_SIZE];
+       u32 private_data[IB_CM_REQ_PRIVATE_DATA_SIZE/4];
 
 } __attribute__ ((packed));
 
@@ -801,7 +801,7 @@ struct cm_sidr_req_msg {
        __be16 rsvd;
        __be64 service_id;
 
-       u8 private_data[IB_CM_SIDR_REQ_PRIVATE_DATA_SIZE];
+       u32 private_data[IB_CM_SIDR_REQ_PRIVATE_DATA_SIZE/4];
 } __attribute__ ((packed));
 
 struct cm_sidr_rep_msg {
 
> >>I feel like I stepped into a tar pit... It's a bit odd that
> >>IB_CM_COMPARE_SIZE is part of an enum rather than a #define.
> >
> >This is, again, idiomatic. '#define CONSTANT' is often frowned upon,
> >the semantics of enum are much cleaner/safer,
> 
> '#define NAME VALUE' is used throughout the kernel. Why does ib_rdma
> need to be different?

There is a mix, the style guide endorses both options.
 
> >To look for more sketchy things that might impact SPARC, ARM, etc.
> 
> Seems like a topic for another patch.

Yep

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
