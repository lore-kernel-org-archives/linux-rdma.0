From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 00/11] Add completion timestamping support
Date: Sat, 23 May 2015 07:23:31 +0300
Message-ID: <CAJ3xEMgZXS3yu4JSCq6EcwXvDLRQn01M7pduNfxWr0pRws0pbg@mail.gmail.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 5:56 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
[...]
> In mlx4, allowing the user to read the core clock efficiently involves mapping
> this area of the hardware to user-space (being done by using a mmap command)
> and reading the clock from the correct offset of the page.
>
> This offset is returned in the vendor's specific data from mlx4's kernel driver
> to the mlx4's user-space driver. query_device is modified in order to support
> passing this vendor specific data. A user-space application could use a new
> verb in order to read the hardware's clock.
>
> Translating the hardware's clock into ms could be done by dividing this
> value by hca_core_clock (which is returned by the extended version of
> query_device uverb).
>
> A user-space application could get the current HW's clock by executing
>
> ibv_query_values_ex(struct ibv_context *context, uint32_t q_values,
>                     struct ibv_values_ex *values)
>
> The function gets a mask of the values to query and return their values.
> Vendors could either implement this as a uverb command or use their
> user-space driver to return those values directly from the HW (the mlx4 way).
>
> Changes from V0:
> (1) Pass ib_cq_init_attr instead of cqe and comp_vector.
> (2) Fix unneeded indentation.
> (3) Change flags to u32.
> (4) Add const to create_cq's ib_cq_init_attr argument in vendor implementation.


Hi Doug,

I believe the V1 post addressed all the reviewer comments on V0 except
for one open issue.

What's still open is the debate on mlx4 using the uverbs builtin udata
mechanism to transfer the clock offset in the mmaped page to user
space. I have replied there and still waiting get a response.

Or.

> Matan Barak (11):
>   IB/core: Change provider's API of create_cq to be extendible
>   IB/core: Change ib_create_cq to use struct ib_cq_init_attr
>   IB/core: Add CQ creation time-stamping flag
>   IB/core: Extend ib_uverbs_create_cq
>   IB/core: Add timestamp_mask and hca_core_clock to query_device
>   IB/core: Pass hardware specific data in query_device
>   IB/mlx4: Add mmap call to map the hardware clock
>   IB/mlx4: Support extended create_cq and query_device uverbs
>   IB/mlx4: Add support for timestamp in cq creation
>   IB/mlx4: Add timestamp_mask and hca_core_clock to query_device
>   IB/mlx4: Return hca core clock's offset in query_device vendor's data
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
