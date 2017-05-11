From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Corrected description of max_sge and
 max_sge_rd
Date: Thu, 11 May 2017 13:11:46 +0300
Message-ID: <20170511101145.GH3011@yuval-lap>
References: <1494433465-1883-1-git-send-email-yishaih@mellanox.com>
 <20170511083355.GE3011@yuval-lap>
 <dc3fc605-0636-f6d1-5e8c-b4cd10369260@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <dc3fc605-0636-f6d1-5e8c-b4cd10369260-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 11, 2017 at 12:44:19PM +0300, Yishai Hadas wrote:
> On 5/11/2017 11:33 AM, Yuval Shaia wrote:
> >On Wed, May 10, 2017 at 07:24:25PM +0300, Yishai Hadas wrote:
> >>From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >>This patch corrects ambiguity in documentation of max_sge and max_sge_rd
> >>fields. This ambiguity seems to be created due to [1] and due to mention
> >>of "RD and non RD QPs" in man page.
> >>
> >>Here RD can be understood as reliable datagram QP of Infiniband
> >>specification as opposed to "read".
> >>
> >>max_sge_rd: Maximum number of sges per WR for RDMA Read operations.
> >>max_sge: Maximum number of sges per WR for QP for non RDMA Read
> >>operations.
> >
> >So the new comments makes it clear but can you consider change the name to
> >reflect that?
> 
> Those fields are exposed to user applications and can't be renamed without
> breaking compatibility. Please note that the notation of "rd" is used in
> other fields as well and are documented correctly (e.g. see man page for
> max_qp_rd_atom), so this patch just aligns the man page with other fields
> around and fixes the ambiguity.

Make sense

> 
> >>diff --git a/libibverbs/man/ibv_query_device.3 b/libibverbs/man/ibv_query_device.3
> >>index 35daa53..0e9d286 100644
> >>--- a/libibverbs/man/ibv_query_device.3
> >>+++ b/libibverbs/man/ibv_query_device.3
> >>@@ -33,8 +33,8 @@ uint32_t                hw_ver;                 /* Hardware version */
> >> int                     max_qp;                 /* Maximum number of supported QPs */
> >> int                     max_qp_wr;              /* Maximum number of outstanding WR on any work queue */
> >> int                     device_cap_flags;       /* HCA capabilities mask */
> >>-int                     max_sge;                /* Maximum number of s/g per WR for non-RD QPs */
> >>-int                     max_sge_rd;             /* Maximum number of s/g per WR for RD QPs */
> >>+int                     max_sge;                /* Maximum number of s/g per WR for SQ & RQ of QP for non RDMA Read operations */
> >
> >Should the line be break here as it exceed 80 characters?
> Not really required, this is aligned with having one descriptive line per
> field as done for other fields which are even longer, when using 'man' it
> looks fine.
> 
> Thanks for your review.

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
