From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Fri, 29 Apr 2016 12:07:19 -0700
Message-ID: <a3d2d231-5687-8d7a-f786-fcde7612eccb@oracle.com>
References: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com>
 <3fb4e75f-ff14-34e2-b6d3-6b6046812845@oracle.com>
 <72E8335B-282B-4DCC-AE4F-FE7E50ED5A08@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <72E8335B-282B-4DCC-AE4F-FE7E50ED5A08-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/29/2016 9:58 AM, Chuck Lever wrote:
>
>> On Apr 29, 2016, at 12:44 PM, Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>
>>
>>
>> On 4/29/2016 9:24 AM, Chuck Lever wrote:
>>> I've found some new behavior, recently, while testing the
>>> v4.6-rc Linux NFS/RDMA client and server.
>>>
>>> When certain kernel memory debugging CONFIG options are
>>> enabled, 1MB NFS WRITEs can sometimes result in a
>>> IB_WC_LOC_PROT_ERR. I usually turn on most of them because
>>> I want to see any problems, so I'm not sure which option
>>> in particular is exposing the issue.
>>>
>>> When debugging is enabled on the server, and the underlying
>>> device is using FRWR to register the sink buffer, an RDMA
>>> Read occasionally completes with LOC_PROT_ERR.
>>>
>>> When debugging is enabled on the client, and the underlying
>>> device uses FRWR to register the target of an RDMA Read, an
>>> ingress RDMA Read request sometimes gets a Syndrome 99
>>> (REM_OP_ERR) acknowledgement, and a subsequent RDMA Receive
>>> on the client completes with LOC_PROT_ERR.
>>>
>>> I do not see this problem when kernel memory debugging is
>>> disabled, or when the client is using FMR, or when the
>>> server is using physical addresses to post its RDMA Read WRs,
>>> or when wsize is 512KB or smaller.
>>>
>>> I have not found any obvious problems with the client logic
>>> that registers NFS WRITE buffers, nor the server logic that
>>> constructs and posts RDMA Read WRs.
>>>
>> One possibility here could be the mismatch in posted WR for
>> send/receive. Can you check if for certain cases you are
>> posting receive WRs which can't handle whats send is putting
>> on the wire.
>
> I've confirmed that the client is posting only 1024-byte
> Receive buffers, and that the ib_sge for each Receive
> operation is the same before and after the Receive is
> posted (ie, the Receive ib_sge is valid and is not
> getting overwritten somehow).
>
> The wire traffic contains Send Only requests of 230 or so
> bytes. If an ingress Send is too large, the Receive should
> complete with IB_WC_LOC_LEN_ERR, not IB_WC_LOC_PROT_ERR.
>
You are right. What I described is IB_WC_LOC_LEN_ERR scenario
and not IB_WC_LOC_PROT_ERR.

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
