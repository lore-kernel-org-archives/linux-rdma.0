From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: "memory management error" with NFS/RDMA on RoCE
Date: Tue, 8 Aug 2017 12:14:50 -0400
Message-ID: <E3835D55-59DE-4F6B-A794-E94A93318C95@oracle.com>
References: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61@oracle.com> <797a43c4-f30d-9deb-a332-c62cbd01be7b@grimberg.me> <2FEEE227-9BCF-4454-A056-3997C1E54686@oracle.com> <7ef3ca44-1253-7aae-1b46-f78cc15e627d@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ef3ca44-1253-7aae-1b46-f78cc15e627d-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Aug 8, 2017, at 11:45 AM, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> 
> Hi all,
> soory for late response.
> 
> On 6/27/2017 5:56 PM, Chuck Lever wrote:
>> Hi Sagi-
>> 
>>> On Jun 27, 2017, at 5:28 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>>> 
>>> 
>>>> While running xfstests on an NFS/RDMA mount, I see this in
>>>> the client's /var/log/messages multiple times:
>>>> Jun 22 14:13:45 manet kernel: mlx5_0:dump_cqe:275:(pid 0): dump error cqe
>>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>>> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
>>>> Jun 22 14:13:45 manet kernel: 00000000 08007806 250000cd 024027d3
>>>> Jun 22 14:13:45 manet kernel: rpcrdma: fastreg: memory management operation error (6/0x78)
>>>> As far as I can tell the client is able to recover and continue
>>>> the test. However, this error is not supposed to happen in normal
>>>> operation.
>>>> This is with a Mellanox CX4 in RoCEv1 mode, v4.12-rc2.
>>> 
>>> Is this a regression?
>> 
>> I can't answer that question with authority, because I just
>> started trying out NFS/RDMA on RoCE with mlx5. But Robert has
>> reported very similar symptoms with iSER on v4.9. It appears
>> to have been around for a while, if these are the same.
>> 
>> 
>>> What kernel version are you running?
>> 
>> v4.12-rc2.
>> 
>> 
>>> FW revision?
>> 
>> 12.18.2000
>> 
>> 
>>> Is the below commit applied?
>> 
>> This commit does not appear to be applied to my kernel.
>> 
>> 
>>> commit 6e8484c5cf07c7ee632587e98c1a12d319dacb7c
>>> Author: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Date:   Sun May 28 10:53:11 2017 +0300
>>> 
>>>   RDMA/mlx5: set UMR wqe fence according to HCA cap
>>> 
>>>   Cache the needed umr_fence and set the wqe ctrl segmennt
>>>   accordingly.
>>> 
>>>   Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>   Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>   Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>>>   Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> 
>>> This is the only thing that changed in that area
>>> lately...
>>> 
>>> Can you try without it?
>> 
>> I haven't tried with it. I can pull it and see if it helps.
> 
> Chuck,
> any updates using my patch above (actually you need this 1410a90ae449061b7e1ae19d275148f36948801b as a pre condition) ?

My client is at v4.13-rc3 now, and I haven't seen this issue recur
recently.


>> I have tried:
>> 
>> - with and without IOMMU enabled
>> - with RoCE v1 and v2
>> - with instrumentation:
>> 
>> This can happen to any MR at any time after any number of
>> uses. It does not appear to be "sticky" (ie, xprtrdma
>> recovery from a memory management error clears the problem
>> successfully by releasing the MR and allocating a new one).
>> 
> 
> I'm not so familiar with NFS/RDMA IO path yet, but are you using remote invalidation from server side or you run local invlidation ?
> which side initiates the RDMA_READ/WRITE operations ?

Remote Invalidation should be in use, but I haven't confirmed that.

The storage target (the NFS server) issues the RDMA Read and
RDMA Write operations.


>> So it feels like a f/w or driver problem to me, at this
>> point.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
