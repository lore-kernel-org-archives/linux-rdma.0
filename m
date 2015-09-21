From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/mlx4: Report checksum offload cap when query device
Date: Tue, 22 Sep 2015 00:41:49 +0300
Message-ID: <CAJ3xEMg31JSPU2_gW0OGjC9rdTgDRcx=7LnuPncD6+gCE7nRMw@mail.gmail.com>
References: <cover.1442413048.git.bodong@mellanox.com>
	<68bea4df2c89e5457aaaccf914756bc309d742a7.1442413048.git.bodong@mellanox.com>
	<55FB7AE8.2070304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55FB7AE8.2070304-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 18, 2015 at 5:46 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 09/16/2015 11:56 AM, Bodong Wang wrote:
>> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/mlx4/main.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
>> index 8be6db8..a70ca6a 100644
>> --- a/drivers/infiniband/hw/mlx4/main.c
>> +++ b/drivers/infiniband/hw/mlx4/main.c
>> @@ -217,6 +217,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
>>               props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
>>       }
>>
>> +     props->csum_cap.eth_csum_cap |= IB_CSUM_SUPPORT_RAW;
>> +     props->csum_cap.ib_csum_cap |= IB_CSUM_SUPPORT_UD;
>> +

> This patch highlights something I didn't think about on the previous
> patch.  Why separate eth/ib if you have per QP flags?  The QP denotes
> the ib/eth relationship without the need to separate it into two
> different caps.  In other words, you can never have an IB qp type on eth
> because the only eth QP types we support other than RAW are all RDMA and
> not IP.  Really, there's enough spare bits in ib_device_cap_flags that
> you could do away with the new caps entirely.  Right now, we support UD
> (which we already have a flag for), we can add two flags (for RAW and
> RC) and that should cover all of the foreseeable options as that would
> allow us to extend IP CSUM support to cover connected mode and cover all
> of the current options.  I don't see us doing IP traffic in any other
> situation, so I thing that should suffice.  Bits 25 and 26 could be used
> for the two new bits.  Then you just need to extend the bits to user space.

Doug,

The vendor may support the offload for a certain QP type only over
certain link. E.g mlx4 support checksum for UD QPs only over IB but
not over Eth,  checksum for RC QPs isn't supported, and RAW_PACKET QPs
are available anyway only for Eth links. But if this is what you think
needs to be done, I guess we can do that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
