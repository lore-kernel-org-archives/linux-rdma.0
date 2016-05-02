From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Mon, 2 May 2016 11:10:34 -0400
Message-ID: <B72A389F-FFF1-498C-A946-8AA72B7769F8@oracle.com>
References: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com> <57238F8C.70505@sandisk.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57238F8C.70505-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 29, 2016, at 12:45 PM, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> On 04/29/2016 09:24 AM, Chuck Lever wrote:
>> I've found some new behavior, recently, while testing the
>> v4.6-rc Linux NFS/RDMA client and server.
>> 
>> When certain kernel memory debugging CONFIG options are
>> enabled, 1MB NFS WRITEs can sometimes result in a
>> IB_WC_LOC_PROT_ERR. I usually turn on most of them because
>> I want to see any problems, so I'm not sure which option
>> in particular is exposing the issue.
>> 
>> When debugging is enabled on the server, and the underlying
>> device is using FRWR to register the sink buffer, an RDMA
>> Read occasionally completes with LOC_PROT_ERR.
>> 
>> When debugging is enabled on the client, and the underlying
>> device uses FRWR to register the target of an RDMA Read, an
>> ingress RDMA Read request sometimes gets a Syndrome 99
>> (REM_OP_ERR) acknowledgement, and a subsequent RDMA Receive
>> on the client completes with LOC_PROT_ERR.
>> 
>> I do not see this problem when kernel memory debugging is
>> disabled, or when the client is using FMR, or when the
>> server is using physical addresses to post its RDMA Read WRs,
>> or when wsize is 512KB or smaller.
>> 
>> I have not found any obvious problems with the client logic
>> that registers NFS WRITE buffers, nor the server logic that
>> constructs and posts RDMA Read WRs.
>> 
>> My next step is to bisect. But first, I was wondering if
>> this behavior might be related to the recent problems with
>> s/g lists seen with iSER/SRP? ie, is this a recognized
>> issue?
> 
> Hello Chuck,
> 
> A few days ago I observed similar behavior with the SRP protocol but only if I increase max_sect in /etc/srp_daemon.conf from the default to 4096. My setup was as follows:
> * Kernel 4.6.0-rc5 at the initiator side.
> * A whole bunch of kernel debugging options enabled at the initiator
>  side.
> * The following settings in /etc/modprobe.d/ib_srp.conf:
>  options ib_srp cmd_sg_entries=255 register_always=1
> * The following settings in /etc/srp_daemon.conf:
>  a queue_size=128,max_cmd_per_lun=128,max_sect=4096
> * Kernel 3.0.101 at the target side.
> * Kernel debugging disabled at the target side.
> * mlx4 driver at both sides.
> 
> Decreasing max_sge at the target side from 32 to 16 did not help. I have not yet had the time to analyze this further.

git bisect result:

d86bd1bece6fc41d59253002db5441fe960a37f6 is the first bad commit
commit d86bd1bece6fc41d59253002db5441fe960a37f6
Author: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Date:   Tue Mar 15 14:55:12 2016 -0700

    mm/slub: support left redzone

I checked out the previous commit and was not able to
reproduce, which gives some confidence that the bisect
result is valid.

I've also investigated the wire behavior a little more.
The server I'm using for testing has FRWR artificially
disabled, so it uses physical addresses for RDMA Read.
This limits it to max_sge_rd, or 30 pages for each Read
request.

The client sends a single 1MB Read chunk. The server
emits 8 30-page Read requests, and a ninth request for
the last 16 pages in the chunk.

The client's HCA responds to the 30-page Read requests
properly. But on the last Read request, it responds
with a Read First, 14 Read Middle responses, then an
ACK with Syndrome 99 (Remote Operation Error).

This suggests the last page in the memory region is
not accessible to the HCA.

This does not happen on the first NFS WRITE, but
rather one or two subsequent NFS WRITEs during the test.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
