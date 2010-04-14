From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibnetdisc: fix outstanding SMPs countung
Date: Wed, 14 Apr 2010 09:52:47 -0700
Message-ID: <0EEE4F40-F1DD-46A6-B756-3C46DA06B403@llnl.gov>
References: <20100218124933.c018a23d.weiny2@llnl.gov> <20100413163836.GM10830@me> <20100413133826.00a8afc5.weiny2@llnl.gov> <20100413134446.72eb336a.weiny2@llnl.gov> <20100414102335.GT10830@me>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100414102335.GT10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Apr 14, 2010, at 3:23 AM, Sasha Khapyorsky wrote:

> On 13:44 Tue 13 Apr     , Ira Weiny wrote:
>>
>>> This changes the logic.  "num_smps_outstanding" is NOT the number  
>>> on the wire, but it appears you have made it so.
>
> Actually yes, it made it so.
>
>>> This is the number which will cause process_smp_queue to continue  
>>> being called.
>>>
>>> If you are going to do this I think you need to change  
>>> process_mads as well as process_one_recv.  We discussed  
>>> process_one_recv in the error case.
>
> process_one_recv() failure breaks the loop anyway.
>
>>> What were you trying to fix?
>>
>> Ok, I think I see.  We should move cl_qmap_insert to after a  
>> successful umad_send and putting total_smps here is ok.  But  
>> num_smps_outstanding should be put back I think.
>
> But then it blocks process_mads() to loop forever after single
> send_smp() failure (with all empty queues and umad_recv() running
> without timeout).

But moving the cl_qmap_insert below the send call fixes that.   
However, it does cause a memory leak because the smp is no longer in  
the smp_queue_head list.  It needs to be put back on that list to be  
retried with a limit on the retries (to prevent what you are saying  
here.)  Are you seeing a hang?

I have seen a hang when running "iblinkinfo -S <guid>".  However, the  
problem is not with send_smp.  I am seeing the mad going on the wire  
and returning (according to madeye) but I am not receiving it from  
umad_recv.  I don't know why.  If I run with 1 outstanding mad it  
works???

Ira

>
> Sasha

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
