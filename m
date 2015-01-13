From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v1 06/10] svcrdma: Plant reader function in struct svcxprt_rdma
Date: Tue, 13 Jan 2015 09:40:59 -0600
Message-ID: <54B53C8B.3090601@opengridcomputing.com>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192245.4901.89614.stgit@klimt.1015granger.net> <54B2B69E.2010503@dev.mellanox.co.il> <6A78707C-A371-412F-8E9A-24937318A01D@oracle.com> <002201d02e82$08d16070$1a742150$@opengridcomputing.com> <A84D07C5-1879-49ED-A181-6FFC76B4864B@oracle.com> <006b01d02e84$907f5890$b17e09b0$@opengridcomputing.com> <54B3FA35.4030003@opengridcomputing.com> <54B4EDE9.2050300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B4EDE9.2050300-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Linux NFS Mailing List' <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/13/2015 4:05 AM, Sagi Grimberg wrote:
> On 1/12/2015 6:45 PM, Steve Wise wrote:
>> On 1/12/2015 10:26 AM, Steve Wise wrote:
>>>
>>>> -----Original Message-----
>>>> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>>>> Sent: Monday, January 12, 2015 10:20 AM
>>>> To: Steve Wise
>>>> Cc: Sagi Grimberg; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux NFS Mailing List
>>>> Subject: Re: [PATCH v1 06/10] svcrdma: Plant reader function in
>>>> struct svcxprt_rdma
>>>>
>>>>
>>>> On Jan 12, 2015, at 11:08 AM, Steve Wise
>>>> <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>>>>
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>>>>>> Sent: Sunday, January 11, 2015 6:41 PM
>>>>>> To: Sagi Grimberg; Steve Wise
>>>>>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux NFS Mailing List
>>>>>> Subject: Re: [PATCH v1 06/10] svcrdma: Plant reader function in
>>>>>> struct svcxprt_rdma
>>>>>>
>>>>>>
>>>>>> On Jan 11, 2015, at 12:45 PM, Sagi Grimberg
>>>>>> <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>>>>
>>>>>>> On 1/9/2015 9:22 PM, Chuck Lever wrote:
>>>>>>>> The RDMA reader function doesn't change once an svcxprt is
>>>>>>>> instantiated. Instead of checking sc_devcap during every incoming
>>>>>>>> RPC, set the reader function once when the connection is accepted.
>>>>>>> General question(s),
>>>>>>>
>>>>>>> Any specific reason why to use FRMR in the server side? And why 
>>>>>>> only
>>>>>>> for reads and not writes? Sorry if these are dumb questions...
>>>>>> Steve Wise presented patches a few months back to add FRMR, he
>>>>>> would have to answer this. Steve has a selection of iWARP adapters
>>>>>> and maybe could provide some idea of performance impact. I have
>>>>>> only CX-[23] here.
>>>>>>
>>>>> The rdma rpc server has always tried to use FRMR for rdma reads as
>>>>> far as I recall.  The patch I submitted refactored the design
>>> in
>>>>> order to make it more efficient and to fix some bugs.   Unlike IB,
>>>>> the iWARP  protocol only allows 1 target/sink SGE in an rdma
>>> read
>>>>> request message, so an FRMR is used to create that single
>>>>> target/sink SGE allowing 1 read to be submitted instead of many.
>>>> How does this work when the client uses PHYSICAL memory registration?
>>> Each page would require a separate rdma read WR.  That is why we use
>>> FRMRs. :)
>>
>> Correction, each physical scatter gather entry would require a separate
>> read WR.  There may be contiguous chunks of physical mem that can be
>> described with one RDMA SGE...
>
>
> OK, thanks for clarifying that for me.
>
> From the code, I think that FRMR is used also if the buffer can
> fit in a single SGE. Wouldn't it be better to skip the Fastreg WR in
> this case?
>

Perhaps.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
