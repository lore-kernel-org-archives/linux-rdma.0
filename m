From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/8] Introduce vector CALC support
Date: Tue, 23 Feb 2016 18:33:35 +0200
Message-ID: <CALq1K=KTnjWFz8aoY8of+1eB+=45McN6gXrmHE=ijw30y1W52Q@mail.gmail.com>
References: <1456215928-9305-1-git-send-email-leon@leon.nu> <008201d16e4e$e513f590$af3be0b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <008201d16e4e$e513f590$af3be0b0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 23, 2016 at 5:28 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
>> Sent: Tuesday, February 23, 2016 2:25 AM
>> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Leon Romanovsky
>> Subject: [PATCH rdma-next V1 0/8] Introduce vector CALC support
>>
>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> This patch set introduces vector CALC support.
>>
>> This feature takes as input several vectors of equal length,
>> combines them with a single operation type, producing result vectors
>> which are sent to the destination.
>>
>> The proposed operations are "add, and, or, xor, max, min" and "swap
>> endianness".
>>
>> The hardware processes the data an MTU of at a time, processing the elements
>> of each segment in parallel.
>>
>> This patch set depends on commit b4ff3a36d3e4 ("net/mlx5: Use offset based
>> reserved field names in the IFC header file") which is part of net tree.
>>
>
> Hey Leon,
>
> I look through this and I don't see any user of this.  I also don't see any API for submitting these operations.  Did I miss
> something?  It looks like this series just cleans up some code and adds the ability to advertise CALC.  Where's the user(s)?

The user will come in the following patches. I'll submit libibverbs
and libmlx5 supplementary parts right after I'll return to my office
from vacation.

Thanks.

>
> Steve
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
