From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma\hfi1 - coding style issues cleanup
Date: Thu, 28 Apr 2016 08:41:28 -0400
Message-ID: <20160428124127.GB9685@phlsvsds.ph.intel.com>
References: <1461830300-2851-1-git-send-email-omer.dagan@tandemg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461830300-2851-1-git-send-email-omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 10:58:20AM +0300, omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org wrote:
>From: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>

>diff --git a/drivers/staging/rdma/hfi1/aspm.h b/drivers/staging/rdma/hfi1/aspm.h
>index 0d58fe3..384df0a 100644
>--- a/drivers/staging/rdma/hfi1/aspm.h
>+++ b/drivers/staging/rdma/hfi1/aspm.h
>@@ -234,7 +234,7 @@ static inline void aspm_disable_all(struct hfi1_devdata *dd)
> {
> 	struct hfi1_ctxtdata *rcd;
> 	unsigned long flags;
>-	unsigned i;
>+	unsigned int i;

Can you please explain the value in doing "unsigned int" vs "unsigned"?
None of the static checkers like checkpatch, sparse, or coccinelle seem to 
mind.
 
> u64 read_csr(const struct hfi1_devdata *dd, u32 offset)
> {
>-	if (dd->flags & HFI1_PRESENT) {
>+	if (dd->flags & HFI1_PRESENT)
> 		return readq((void __iomem *)dd->kregbase + offset);
>-	}
>+
> 	return -1;
> }
>

Also please don't fix multiple types of issues in one patch. This is very 
easy to lose sight of in the review and stands on its own. 

This is a checkpatch issue. Likely the result of a previous patch removing a 
line of code, something that is only seen when you run checkpatch on the 
entire file not just the patch so this is a good find.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
