From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/usnic: Change BUG_ON to WARN_ON
Date: Tue, 7 Jan 2014 22:05:57 +0000
Message-ID: <F58CD9B3-7D65-4DBB-9004-34E3A509FC61@cisco.com>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com>
 <1387298917-7365-6-git-send-email-umalhi@cisco.com>
 <52B56799.2010306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B56799.2010306-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Content-ID: <3626EAB8FA60E74DBC7A1DBBCBE9C2B7-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ack.

Upinder

On Dec 21, 2013, at 2:04 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> On 12/17/13 17:48, Upinder Malhi wrote:
>> usNIC calls BUG_ON(spinlock_is_held..) at few places.  In some of these
>> instances, the call is made with another spinlock already held.  Change
>> all such calls in usNIC to WARN_ON to make it fool-proof.
>> 
>> Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>> ---
>> drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 16 ++++++++--------
>> drivers/infiniband/hw/usnic/usnic_uiom.c      |  2 +-
>> 2 files changed, 9 insertions(+), 9 deletions(-)
>> 
>> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
>> index f647b6b..ad57a77 100644
>> --- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
>> +++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
>> @@ -82,7 +82,7 @@ static int add_fwd_filter(struct usnic_ib_qp_grp *qp_grp,
>> 	struct usnic_vnic_res_chunk *chunk;
>> 	int rq_idx;
>> 
>> -	BUG_ON(!spin_is_locked(&qp_grp->lock));
>> +	WARN_ON(!spin_is_locked(&qp_grp->lock));
>> 
>> 	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
>> 	if (IS_ERR_OR_NULL(chunk) || chunk->cnt < 1) {
> 
> Please consider using lockdep_assert_held() instead of
> BUG_ON(!spin_is_locked()) or WARN_ON(!spin_is_locked()). Both the old
> code and the new code will fail on uniprocessor systems with
> CONFIG_DEBUG_SPINLOCK=n. From include/linux/spinlock_up.h:
> 
> #ifdef CONFIG_DEBUG_SPINLOCK
> ...
> #else /* DEBUG_SPINLOCK */
> #define arch_spin_is_locked(lock)	((void)(lock), 0)
> ...
> #endif
> 
> Bart.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
