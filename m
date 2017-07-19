From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issues with starting srp_daemon userspace for a 4.13 kernel
Date: Wed, 19 Jul 2017 15:40:06 -0400
Message-ID: <026eedf1-175d-b8df-8396-2bc378e7a5df@redhat.com>
References: <b74ff7c3-734b-71ae-6b67-9a8ccf255bf6@redhat.com>
 <20170718194846.GA6048@obsidianresearch.com>
 <ef6d29a5-9632-bd9b-1113-1de6671031cc@redhat.com>
 <1500408333.2664.6.camel@wdc.com>
 <5ca055dc-199f-ee29-fc99-126db132df10@redhat.com>
 <8357b19a-26f4-4c27-1b61-b122d4d1a9fd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8357b19a-26f4-4c27-1b61-b122d4d1a9fd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 07/18/2017 04:59 PM, Laurence Oberman wrote:
> 
> 
> On 07/18/2017 04:27 PM, Laurence Oberman wrote:
>>
>>
>> On 07/18/2017 04:05 PM, Bart Van Assche wrote:
>>> On Tue, 2017-07-18 at 16:01 -0400, Laurence Oberman wrote:
>>>> Yep, That patch seems to be in 4.12 and in 4.13 RC1.
>>>> 4.12 is working.
>>>> I am going to add some debug now as I really dont feel like a bisect
>>>> build unless I first try figure out the differences.
>>>
>>> Hello Laurence,
>>>
>>> Is SELinux enabled on your test setup? If so, can you repeat your test
>>> after having disabled it?
>>>
>>> Bart.
>>>
>>
>> Hi Bart
>> Thanks for replying.
>>
>> Its disabled (at least now it is.) although it should have also been 
>> disabled when I tested.
>>
>> I will re-run the test in case.
>>
>> [root@dhcp40-139 ~]# getenforce
>> Disabled
>>
>> Just waiting on a kernel build as I decided to start the bisect as it 
>> is not that many kernels between v12.x and v13 RC1.
>>
>> I will say there are lots of code changes in V4.13 showing stuff about 
>> the RTS in the QP states (Mostly in ROCE though)
>>
>> Thanks
>> Laurence
> 
> Hi Bart
> 
> [root@dhcp40-139 ~]# getenforce
> Disabled
> 
> [root@dhcp40-139 ~]# uname -a
> Linux dhcp40-139.desklab.eng.bos.redhat.com 4.13.0-rc1 #1 SMP Tue Jul 18 
> 09:15:03 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> [root@dhcp40-139 ~]# run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 
> -T 10 -t 7000 -ance -i mlx5_0 -p 1
> srp_daemon[14691]: failed to modify QP state to RTR
> srp_daemon[14691]: failed to modify QP state from RESET to RTS
> 
> OK, will do the bisect now
> 
> Thanks
> Laurence

So
After many kernels and testing through the bisect I got to the patch 
Jason called out

In other words this is the offender, not the fix, at least for 4.13.

[5ecce4c9b17bed4dc9cb58bfb10447307569b77b] RDMA/uverbs: Check port 
number supplied by user verbs cmds

commit 5ecce4c9b17bed4dc9cb58bfb10447307569b77b
Author: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Tue Jun 27 15:09:13 2017 +0300

     RDMA/uverbs: Check port number supplied by user verbs cmds

     The ib_uverbs_create_ah() ind ib_uverbs_modify_qp() calls receive
     the port number from user input as part of its attributes and assumes
     it is valid. Down on the stack, that parameter is used to access kernel
     data structures.  If the value is invalid, the kernel accesses memory
     it should not.  To prevent this, verify the port number before 
using it.

     BUG: KASAN: use-after-free in ib_uverbs_create_ah+0x6d5/0x7b0
     Read of size 4 at addr ffff880018d67ab8 by task syz-executor/313

     BUG: KASAN: slab-out-of-bounds in modify_qp.isra.4+0x19d0/0x1ef0
     Read of size 4 at addr ffff88006c40ec58 by task syz-executor/819

     Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
     Fixes: 189aba99e70 ("IB/uverbs: Extend modify_qp and support packet 
pacing")
     Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v2.6.14+
     Cc: <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
     Cc: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Cc: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Cc: Alex Polak <alexpo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Jason did I misunderstand you.
That you were saying this patch was the issue.
I thought you were saying this was the fix.

Also this patch is in 4.12.x and 4.12 works so clearly a 4.13.x
compatibility issue.

Apologies if I misunderstood.

If I revert this SRP behaves again on 4.13 RC1

So we will have to revert or fix this patch.
I will see if I can make progress on why it breaks 4.13

Thanks
Laurence




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
