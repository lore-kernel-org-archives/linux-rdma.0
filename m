From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Wed, 4 May 2016 15:59:09 -0400
Message-ID: <F6C79393-6174-49B3-ADBB-E40627DEE85D@oracle.com>
References: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com> <57238F8C.70505@sandisk.com> <B72A389F-FFF1-498C-A946-8AA72B7769F8@oracle.com> <57277B63.8030506@sandisk.com> <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com> <002801d1a5a1$4f192260$ed4b6720$@lge.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <002801d1a5a1$4f192260$ed4b6720$@lge.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On May 3, 2016, at 9:07 PM, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:
> 
> 
> 
>> -----Original Message-----
>> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>> Sent: Tuesday, May 03, 2016 11:57 PM
>> To: Joonsoo Kim
>> Cc: Bart Van Assche; Or Gerlitz; linux-rdma
>> Subject: Re: RDMA Read: Local protection error
>> 
>> 
>>> On May 2, 2016, at 12:08 PM, Bart Van Assche
>> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>>> 
>>> On 05/02/2016 08:10 AM, Chuck Lever wrote:
>>>>> On Apr 29, 2016, at 12:45 PM, Bart Van Assche
>> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>>>>> On 04/29/2016 09:24 AM, Chuck Lever wrote:
>>>>>> I've found some new behavior, recently, while testing the
>>>>>> v4.6-rc Linux NFS/RDMA client and server.
>>>>>> 
>>>>>> When certain kernel memory debugging CONFIG options are
>>>>>> enabled, 1MB NFS WRITEs can sometimes result in a
>>>>>> IB_WC_LOC_PROT_ERR. I usually turn on most of them because
>>>>>> I want to see any problems, so I'm not sure which option
>>>>>> in particular is exposing the issue.
>>>>>> 
>>>>>> When debugging is enabled on the server, and the underlying
>>>>>> device is using FRWR to register the sink buffer, an RDMA
>>>>>> Read occasionally completes with LOC_PROT_ERR.
>>>>>> 
>>>>>> When debugging is enabled on the client, and the underlying
>>>>>> device uses FRWR to register the target of an RDMA Read, an
>>>>>> ingress RDMA Read request sometimes gets a Syndrome 99
>>>>>> (REM_OP_ERR) acknowledgement, and a subsequent RDMA Receive
>>>>>> on the client completes with LOC_PROT_ERR.
>>>>>> 
>>>>>> I do not see this problem when kernel memory debugging is
>>>>>> disabled, or when the client is using FMR, or when the
>>>>>> server is using physical addresses to post its RDMA Read WRs,
>>>>>> or when wsize is 512KB or smaller.
>>>>>> 
>>>>>> I have not found any obvious problems with the client logic
>>>>>> that registers NFS WRITE buffers, nor the server logic that
>>>>>> constructs and posts RDMA Read WRs.
>>>>>> 
>>>>>> My next step is to bisect. But first, I was wondering if
>>>>>> this behavior might be related to the recent problems with
>>>>>> s/g lists seen with iSER/SRP? ie, is this a recognized
>>>>>> issue?
>>>>> 
>>>>> Hello Chuck,
>>>>> 
>>>>> A few days ago I observed similar behavior with the SRP protocol but
>> only if I increase max_sect in /etc/srp_daemon.conf from the default to
>> 4096. My setup was as follows:
>>>>> * Kernel 4.6.0-rc5 at the initiator side.
>>>>> * A whole bunch of kernel debugging options enabled at the initiator
>>>>> side.
>>>>> * The following settings in /etc/modprobe.d/ib_srp.conf:
>>>>> options ib_srp cmd_sg_entries=255 register_always=1
>>>>> * The following settings in /etc/srp_daemon.conf:
>>>>> a queue_size=128,max_cmd_per_lun=128,max_sect=4096
>>>>> * Kernel 3.0.101 at the target side.
>>>>> * Kernel debugging disabled at the target side.
>>>>> * mlx4 driver at both sides.
>>>>> 
>>>>> Decreasing max_sge at the target side from 32 to 16 did not help. I
>> have not yet had the time to analyze this further.
>>>> 
>>>> git bisect result:
>>>> 
>>>> d86bd1bece6fc41d59253002db5441fe960a37f6 is the first bad commit
>>>> commit d86bd1bece6fc41d59253002db5441fe960a37f6
>>>> Author: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
>>>> Date:   Tue Mar 15 14:55:12 2016 -0700
>>>> 
>>>>    mm/slub: support left redzone
>>>> 
>>>> I checked out the previous commit and was not able to
>>>> reproduce, which gives some confidence that the bisect
>>>> result is valid.
>>>> 
>>>> I've also investigated the wire behavior a little more.
>>>> The server I'm using for testing has FRWR artificially
>>>> disabled, so it uses physical addresses for RDMA Read.
>>>> This limits it to max_sge_rd, or 30 pages for each Read
>>>> request.
>>>> 
>>>> The client sends a single 1MB Read chunk. The server
>>>> emits 8 30-page Read requests, and a ninth request for
>>>> the last 16 pages in the chunk.
>>>> 
>>>> The client's HCA responds to the 30-page Read requests
>>>> properly. But on the last Read request, it responds
>>>> with a Read First, 14 Read Middle responses, then an
>>>> ACK with Syndrome 99 (Remote Operation Error).
>>>> 
>>>> This suggests the last page in the memory region is
>>>> not accessible to the HCA.
>>>> 
>>>> This does not happen on the first NFS WRITE, but
>>>> rather one or two subsequent NFS WRITEs during the test.
>>> 
>>> On an x86 system that patch changes the alignment of buffers > 8 bytes
>> from 16 bytes to 8 bytes (ARCH_SLAB_MINALIGN / ARCH_KMALLOC_MINALIGN).
>> There might be code in the mlx4 driver that makes incorrect assumptions
>> about the alignment of memory allocated by kmalloc(). Can someone from
>> Mellanox comment on the alignment requirements of the buffers allocated by
>> mlx4_buf_alloc()?
>>> 
>>> Thanks,
>>> 
>>> Bart.
>> 
>> Let's also bring this to the attention of the patch's author.
>> 
>> Joonsoo, any ideas about how to track this down? There have
>> been several reports on linux-rdma of unexplained issues when
>> SLUB debugging is enabled.
> 
> (Adding another e-mail address on CC, because I will not be in
> The office for a few days.)
> 
> Hello,
> 
> Hmm... we need to test if root cause is really alignment or not.
> Could you test below change? It will make alignment of (kmalloce) buffer
> to 16 bytes when debug option is enabled. If it will solve the issue,
> someone's alignment assumption is wrong and should be fixed at that site.
> If not, patch itself would be cause of the problem. In that case, I will
> look at it more.
> 
> Thanks.
> 
> -------------->8--------------
> diff --git a/mm/slub.c b/mm/slub.c
> index f41360e..6f9783c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3322,9 +3322,10 @@ static int calculate_sizes(struct kmem_cache *s, int
> forced_order)
>                 */
>                size += sizeof(void *);
> 
> -               s->red_left_pad = sizeof(void *);
> +               s->red_left_pad = sizeof(void *) * 2;
>                s->red_left_pad = ALIGN(s->red_left_pad, s->align);
>                size += s->red_left_pad;
> +               size = ALIGN(size, 16);
>        }
> #endif

I applied this patch and enabled SLUB debugging.
I was able to reproduce the "local protection error".


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
