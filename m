From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] nfsrdma fails to write big file,
Date: Wed, 24 Feb 2010 18:02:01 -0600
Message-ID: <4B85BDF9.8020009@opengridcomputing.com>
References: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58@mtiexch01.mti.com><4B82D1B4.2030902@opengridcomputing.com>	<9FA59C95FFCBB34EA5E42C1A8573784F02662EA8@mtiexch01.mti.com>	<9FA59C95FFCBB34EA5E42C1A8573784F02663166@mtiexch01.mti.com> <4B85ACD2.9040405@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B85ACD2.9040405-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh Siddheshwar <siddheshwar.mahesh-xsfywfwIY+M@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Vu,

Based on the mapping code, it looks to me like the worst case is 
RPCRDMA_MAX_SEGS * 2 + 1 as the multiplier. 
However, I think in practice, due to the way that iov are built, the 
actual max is 5 (frmr for head + pagelist plus invalidates for same plus 
one for the send itself). Why did you think the max was 6?

Thanks,
Tom

Tom Tucker wrote:
> Vu,
>
> Are you changing any of the default settings? For example rsize/wsize, 
> etc... I'd like to reproduce this problem if I can.
>
> Thanks,
>
> Tom
>
> Vu Pham wrote:
>   
>> Tom,
>>
>> Did you make any change to have bonnie++, dd of a 10G file and vdbench
>> concurrently run & finish?
>>
>> I keep hitting the WQE overflow error below.
>> I saw that most of the requests have two chunks (32K chunk and
>> some-bytes chunk), each chunk requires an frmr + invalidate wrs;
>> However, you set ep->rep_attr.cap.max_send_wr = cdata->max_requests and
>> then for frmr case you do
>> ep->rep_atrr.cap.max_send_wr *=3; which is not enough. Moreover, you
>> also set ep->rep_cqinit = max_send_wr/2 for send completion signal which
>> causes the wqe overflow happened faster.
>>
>> After applying the following patch, I have thing vdbench, dd, and copy
>> 10g_file running overnight
>>
>> -vu
>>
>>
>> --- ofa_kernel-1.5.1.orig/net/sunrpc/xprtrdma/verbs.c   2010-02-24
>> 10:41:22.000000000 -0800
>> +++ ofa_kernel-1.5.1/net/sunrpc/xprtrdma/verbs.c        2010-02-24
>> 10:03:18.000000000 -0800
>> @@ -649,8 +654,15 @@
>>         ep->rep_attr.cap.max_send_wr = cdata->max_requests;
>>         switch (ia->ri_memreg_strategy) {
>>         case RPCRDMA_FRMR:
>> -               /* Add room for frmr register and invalidate WRs */
>> -               ep->rep_attr.cap.max_send_wr *= 3;
>> +               /* 
>> +                * Add room for frmr register and invalidate WRs
>> +                * Requests sometimes have two chunks, each chunk
>> +                * requires to have different frmr. The safest
>> +                * WRs required are max_send_wr * 6; however, we
>> +                * get send completions and poll fast enough, it
>> +                * is pretty safe to have max_send_wr * 4. 
>> +                */
>> +               ep->rep_attr.cap.max_send_wr *= 4;
>>                 if (ep->rep_attr.cap.max_send_wr > devattr.max_qp_wr)
>>                         return -EINVAL;
>>                 break;
>> @@ -682,7 +694,8 @@
>>                 ep->rep_attr.cap.max_recv_sge);
>>
>>         /* set trigger for requesting send completion */
>> -       ep->rep_cqinit = ep->rep_attr.cap.max_send_wr/2 /*  - 1*/;
>> +       ep->rep_cqinit = ep->rep_attr.cap.max_send_wr/4;
>> +       
>>         switch (ia->ri_memreg_strategy) {
>>         case RPCRDMA_MEMWINDOWS_ASYNC:
>>         case RPCRDMA_MEMWINDOWS:
>>
>>
>>
>>
>>
>>   
>>     
>>> -----Original Message-----
>>> From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org [mailto:ewg-
>>> bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Vu Pham
>>> Sent: Monday, February 22, 2010 12:23 PM
>>> To: Tom Tucker
>>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mahesh Siddheshwar;
>>> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>> Subject: Re: [ewg] nfsrdma fails to write big file,
>>>
>>> Tom,
>>>
>>> Some more info on the problem:
>>> 1. Running with memreg=4 (FMR) I can not reproduce the problem
>>> 2. I also see different error on client
>>>
>>> Feb 22 12:16:55 mellanox-2 rpc.idmapd[5786]: nss_getpwnam: name
>>> 'nobody'
>>> does not map into domain 'localdomain'
>>> Feb 22 12:16:55 mellanox-2 kernel: QP 0x70004b: WQE overflow
>>> Feb 22 12:16:55 mellanox-2 kernel: QP 0x6c004a: WQE overflow
>>> Feb 22 12:16:55 mellanox-2 kernel: QP 0x6c004a: WQE overflow
>>> Feb 22 12:16:55 mellanox-2 kernel: RPC: rpcrdma_ep_post: ib_post_send
>>> returned -12 cq_init 48 cq_count 32
>>> Feb 22 12:17:00 mellanox-2 kernel: RPC:       rpcrdma_event_process:
>>> send WC status 5, vend_err F5
>>> Feb 22 12:17:00 mellanox-2 kernel: rpcrdma: connection to
>>> 13.20.1.9:20049 closed (-103)
>>>
>>> -vu
>>>
>>>     
>>>       
>>>> -----Original Message-----
>>>> From: Tom Tucker [mailto:tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
>>>> Sent: Monday, February 22, 2010 10:49 AM
>>>> To: Vu Pham
>>>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mahesh Siddheshwar;
>>>> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>>> Subject: Re: [ewg] nfsrdma fails to write big file,
>>>>
>>>> Vu Pham wrote:
>>>>       
>>>>         
>>>>> Setup:
>>>>> 1. linux nfsrdma client/server with OFED-1.5.1-20100217-0600,
>>>>>         
>>>>>           
>>>> ConnectX2
>>>>       
>>>>         
>>>>> QDR HCAs fw 2.7.8-6, RHEL 5.2.
>>>>> 2. Solaris nfsrdma server svn 130, ConnectX QDR HCA.
>>>>>
>>>>>
>>>>> Running vdbench on 10g file or *dd if=/dev/zero of=10g_file bs=1M
>>>>> count=10000*, operation fail, connection get drop, client cannot
>>>>> re-establish connection to server.
>>>>> After rebooting only the client, I can mount again.
>>>>>
>>>>> It happens with both solaris and linux nfsrdma servers.
>>>>>
>>>>> For linux client/server, I run memreg=5 (FRMR), I don't see
>>>>>         
>>>>>           
>> problem
>>   
>>     
>>>> with
>>>>       
>>>>         
>>>>> memreg=6 (global dma key)
>>>>>
>>>>>
>>>>>         
>>>>>           
>>>> Awesome. This is the key I think.
>>>>
>>>> Thanks for the info Vu,
>>>> Tom
>>>>
>>>>
>>>>       
>>>>         
>>>>> On Solaris server snv 130, we see problem decoding write request
>>>>>         
>>>>>           
>> of
>>   
>>     
>>>> 32K.
>>>>       
>>>>         
>>>>> The client send two read chunks (32K & 16-byte), the server fail
>>>>>         
>>>>>           
>> to
>>   
>>     
>>>> do
>>>>       
>>>>         
>>>>> rdma read on the 16-byte chunk (cqe.status = 10 ie.
>>>>> IB_WC_REM_ACCCESS_ERROR); therefore, server terminate the
>>>>>         
>>>>>           
>>> connection.
>>>     
>>>       
>>>> We
>>>>       
>>>>         
>>>>> don't see this problem on nfs version 3 on Solaris. Solaris server
>>>>>         
>>>>>           
>>>> run
>>>>       
>>>>         
>>>>> normal memory registration mode.
>>>>>
>>>>> On linux client, I see cqe.status = 12 ie. IB_WC_RETRY_EXC_ERR
>>>>>
>>>>> I added these notes in bug #1919 (bugs.openfabrics.org) to track
>>>>>         
>>>>>           
>>> the
>>>     
>>>       
>>>>> issue.
>>>>>
>>>>> thanks,
>>>>> -vu
>>>>> _______________________________________________
>>>>> ewg mailing list
>>>>> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>>>> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>>>>>
>>>>>         
>>>>>           
>>> _______________________________________________
>>> ewg mailing list
>>> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>>>     
>>>       
>> _______________________________________________
>> ewg mailing list
>> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>>   
>>     
>
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
