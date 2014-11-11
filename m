From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4: RoCE support in SRIOV environment
Date: Tue, 11 Nov 2014 12:09:17 +0530
Message-ID: <CANwwZzVkpjKRyOAm9Ky_f3Xxof8YpASzxj0WNhKxZ4Ai0tJfdA@mail.gmail.com>
References: <CANwwZzW1Oe9ff30Wk6xANak9T2Pjoo0fYhWAOzv1GWq7DP+Ung@mail.gmail.com>
	<20141111081609.297d20f8@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141111081609.297d20f8@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>
>
> Hi, RoCE support in SRIOV was added in upstream kernel 3.14 :
>

Hi,

Thank you so much for pointing out when the support was added and also
the commit details.
This is really very helpful!!

I will go through these to further increase my understanding. Thanks so much...

Best Regards,
Bob



On Tue, Nov 11, 2014 at 11:46 AM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Mon, 10 Nov 2014 20:05:54 +0530
> Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi,
>>
>> I was going through the mlx4 code and previous mailing lists when I
>> came across the following thread:
>>
>>
>> http://marc.info/?l=linux-rdma&m=134398354428293&w=2
>>
>>
>> In that thread, it is mentioned as follows:
>>
>> Some Limitations
>> ----------------
>> 1. FMRs are not currently supported on slaves. This will be corrected
>> in a future submission.
>> 2. RoCE is not currently supported on slaves. This will be corrected
>> in a future submission.
>>
>
> Hi, RoCE support in SRIOV was added in upstream kernel 3.14 :
>
> commit 39e7d095f9d0a82a78804650917cd57972a480ce
> Merge: 36f6fdb aa9a2d5
> Author: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Date:   Wed Mar 12 15:57:26 2014 -0400
>
>     Merge branch 'mlx4-next'
>
>     Or Gerlitz says:
>
>     ====================
>     mlx4: Add SRIOV support for RoCE
>
>     This series adds SRIOV support for RoCE (RDMA over Ethernet) to the mlx4 driver.
>
>     The patches are against net-next, as of commit 2d8d40a "pkt_sched: fq:
>     do not hold qdisc lock while allocating memory"
>
>     changes from V1:
>      - addressed feedback from Dave on patch #3 and changed get_real_sgid_index()
>        to be called fill_in_real_sgid_index() and be a void  function.
>      - removed some checkpatch warnings on long lines
>
>     changes from V0:
>       - always check the return code of mlx4_get_roce_gid_from_slave().
>         The call we fixed is introduced in patch #1 and later removed by
>         patch #3 that allows guests to have multiple GIDS. The 1..3
>         separation was done for proper division of patches to logical changes.
>     ====================
>
>     Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
>
>
> -Jack
>
>>
>> As the thread dats back to 2012, I wanted to confirm if FMR & RoCE are
>> still not supported in SRIOV environment(master & slave)?
>>
>>
>> Thanks so much in advance!!
>>
>> Best Regards,
>> Bob
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
