From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Thu, 26 May 2016 18:00:09 +0300
Message-ID: <153e0a54-2ca6-f05a-d36a-05e736a348d7@mellanox.com>
References: <1464181344-11987-1-git-send-email-yishaih@mellanox.com>
 <1464181344-11987-3-git-send-email-yishaih@mellanox.com>
 <20160525172624.GA4602@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525172624.GA4602-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 25/05/2016 20:26, Jason Gunthorpe wrote:
> On Wed, May 25, 2016 at 04:02:19PM +0300, Yishai Hadas wrote:
>
>>  struct ibv_cq_ex {
>>  	struct ibv_context     *context;
>>  	struct ibv_comp_channel *channel;
>> @@ -869,6 +873,23 @@ struct ibv_cq_ex {
>>  	uint32_t		async_events_completed;
>>
>>  	uint32_t		comp_mask;
>
> I'd also suggest looking at the cacheline layout of this structure,
> grouping related things together to minimize the foot print.
>

We need to keep the first part identical to ibv_cq in order to allow 
ibv_cq_ex to be used in other APIs. In addition, the identical part is 
already aligned and grouped.
The new part will be aligned and grouped in the next re-spin.

> I also think this is not enough to deal with future extention needs.
>
> This:
>
> +       struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
> +                                         struct ibv_cq_init_attr_ex *init_attr);
>
> Should take sizeof(ibv_cq_ex) as an argument and allocate and zero at least
> enough memory to cover the caller's struct size. Have the
> ibv_create_cq_ex inline do this
>
> This ensures if we add new function pointers to the end then they are
> null'd even if libibverbs is older, which is a little safer than
> overflowing memory.
>

In order to use read_xxxx function, a user should allocate a suitable CQ 
(with the correct flag). If a support for a flag is needed in 
libibverbs, it should be checked in the create function.

Currently, no explicit support is needed from libibverbs. The only 
required support comes from the vendor's driver and it indeed checks 
those attributes before creating a CQ. We can check comp_mask and 
wc_flags validity in __lib_ibv_create_cq_ex that will ensure the running 
libibverbs is familiar with all requested fields.

> This stuff:
>
> +struct ibv_cq_init_attr_ex {
> +       /* Minimum number of entries required for CQ */
> +       int                     cqe;
>
> And other similar should use 'unsigned int' for values that cannot be negative.
>

Ok

> These two don't seem well thought out:
>
> +enum ibv_create_cq_wc_flags {
> +       IBV_WC_EX_WITH_BYTE_LEN         = 1 << 0,
> +       IBV_WC_EX_WITH_IMM              = 1 << 1,
>
> +enum {
> +       IBV_WC_STANDARD_FLAGS = IBV_WC_EX_WITH_BYTE_LEN         |
>
>
> Eg RC QP's do not have several of those fields.
>
> I expect that if the caller asks for (eg) IBV_WC_EX_WITH_SLID then it
> must be available. This means it is an error to ask for it on QPs that
> do not deliver that value, like RC.
>
> Thus IBV_WC_STANDARD_FLAGS is misnamed and/or useless.
>

It's useful when a CQ needs to support all legacy attribute and could be 
attached to both RC and UD QPs.

> You need to do a full audit of all the QP types and which fields they
> can return and rethink these constants. Ensure the core code and/or
> driver properly enforces the flags.
>

We could later expand the per-defined helper defines of 
IBV_WC_RC_STANDARD_FLAGS, IBV_WC_UD_STANDARD_FLAGS.
We introduced this define in order to ease migration of old poll_cq API 
users.

> The driver should also null fields accessor function pointers that it
> cannot return.
>

We could have checked when creating a QP if the to-be attached CQ 
doesn't support querying invalid attributes in respect of this QP (i.e 
SLID in RC), but doing that you won't be able to attach the same CQ to 
several QP types and get various QP-type specific attributes, as you can 
today. Thus, we prefer the current approach.

The fields that the user requested are guaranteed to be correct only 
when querying a completion originated by a supporting QP - exactly like 
today. We of course nullify function pointers the user didn't request.

>> +	uint16_t (*read_slid)(struct ibv_cq_ex *current);
>
> Maybe make this uint32_t for OPA? Thoughts Intel?
>

No problems from our side regarding this.

> You also need to post the driver side before this can be accepted...
>

Lets iron this API. We'll post libmlx5 implementation that matches this API.

> Jason
>

Regards,
Yishai and Matan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
