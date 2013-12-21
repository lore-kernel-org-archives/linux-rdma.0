From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/usnic: Change BUG_ON to WARN_ON
Date: Sat, 21 Dec 2013 11:04:09 +0100
Message-ID: <52B56799.2010306@acm.org>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com> <1387298917-7365-6-git-send-email-umalhi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387298917-7365-6-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/17/13 17:48, Upinder Malhi wrote:
> usNIC calls BUG_ON(spinlock_is_held..) at few places.  In some of these
> instances, the call is made with another spinlock already held.  Change
> all such calls in usNIC to WARN_ON to make it fool-proof.
> 
> Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 16 ++++++++--------
>  drivers/infiniband/hw/usnic/usnic_uiom.c      |  2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> index f647b6b..ad57a77 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> @@ -82,7 +82,7 @@ static int add_fwd_filter(struct usnic_ib_qp_grp *qp_grp,
>  	struct usnic_vnic_res_chunk *chunk;
>  	int rq_idx;
>  
> -	BUG_ON(!spin_is_locked(&qp_grp->lock));
> +	WARN_ON(!spin_is_locked(&qp_grp->lock));
>  
>  	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
>  	if (IS_ERR_OR_NULL(chunk) || chunk->cnt < 1) {

Please consider using lockdep_assert_held() instead of
BUG_ON(!spin_is_locked()) or WARN_ON(!spin_is_locked()). Both the old
code and the new code will fail on uniprocessor systems with
CONFIG_DEBUG_SPINLOCK=n. From include/linux/spinlock_up.h:

#ifdef CONFIG_DEBUG_SPINLOCK
...
#else /* DEBUG_SPINLOCK */
#define arch_spin_is_locked(lock)	((void)(lock), 0)
...
#endif

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
