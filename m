From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 02/43] IB/mlx4: Support ib_alloc_mr verb
Date: Wed, 22 Jul 2015 20:22:20 +0300
Message-ID: <55AFD14C.8040007@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-3-git-send-email-sagig@mellanox.com>
 <20150722165831.GB26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722165831.GB26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 7:58 PM, Jason Gunthorpe wrote:
> On Wed, Jul 22, 2015 at 09:55:02AM +0300, Sagi Grimberg wrote:
>>
>> +struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
>> +			       enum ib_mr_type mr_type,
>> +			       u32 max_entries,
>> +			       u32 flags)
>> +{
>
> This is just a copy of mlx4_ib_alloc_fast_reg_mr with
> this added:
>
>> +	if (mr_type != IB_MR_TYPE_FAST_REG || flags)
>> +		return ERR_PTR(-EINVAL);
>
> Are all the driver updates the same? It looks like it.
>
> I'd suggest shortening this patch series, have the core provide the
> wrapper immediately:
>
> struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
> {
> ...
>
>      if (pd->device->alloc_mr) {
> 	mr = pd->device->alloc_mr(pd, mr_type, max_entries, flags);
>      } else {
>     	if (mr_type != IB_MR_TYPE_FAST_REG || flags ||
> 	    !ib_dev->alloc_fast_reg_mr)
> 		return ERR_PTR(-ENOSYS);
> 	mr = pd->device->alloc_fast_reg_mr(..);
>      }
> }
>
> Then go through the series to remove ib_alloc_fast_reg_mr
>
> Then go through one series to migrate the drivers from
> alloc_fast_reg_mr to alloc_mr
>
> Then entirely drop alloc_fast_reg_mr from the driver API.
>
> That should be shorter and easier to read the driver diffs, which is
> the major change here.

Yea, it would be better...

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
