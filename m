From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Work completions generated after a queue pair has made the	transition
 to an error state
Date: Wed, 13 Oct 2010 15:51:10 +0200
Message-ID: <4CB5B94E.4080802@voltaire.com>
References: <AANLkTimcxsymqmzoki=quCH+a2sq_fPb4YOmf3gqrzqh@mail.gmail.com>	<1286909435.27343.93.camel@chromite.mv.qlogic.com>	<AANLkTi=72Y+coH1Ke4U-Xk7Eaqpw5pipWRqXEQr7dOau@mail.gmail.com> <20101012202221.GD1617@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101012202221.GD1617@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> Completions with non-zero (error) status and a wr_id / opcode 
> combination were received that were never queued by the application.
> In case of error the opcode of the completed operation is not provided. I am not sure why.
Eli, there's nothing in the IB spec that mandates the WC.opcode of a non 
successful work request to be valid, the only WC fields that must be 
valid are the work-request ID (cookie) and the status code, I believe 
that hardware vendors would also make sure to have the vendor id valid...

Bart, reading your initial posting, I was under the impression that the 
wr_id is something your app didn't post, so in that respect I take back 
my response, so, of-course, when you program to IB you can't assume 
anything on WC.opcode of an error-ed WR.

Or.


>
>>>> Note: some work requests were queued with and some without the flag
>>>> IB_SEND_SIGNALED. I'm not sure however whether that has anything to do
>>>> with the observed behavior.
> If you have WRs for which you did not set IB_SEND_SIGNALED, they are
> not considered completed before a comletion entry is pushed to the CQ
> that correspnds to that send queue. I am not sure if it means that all
> the WR in the send queue should be completed with error.
>>>> This behavior is easy to reproduce. If I interpret the InfiniBand
>>>> Architecture Specification correctly, this behavior is non-compliant.
>>>>
>>>> Has anyone been looking into this before ?
>>> I haven't seen it. It isn't supposed to happen.
>>>
>>> What hardware and software are you using and how do you
>>> reproduce it?
>> Hello Ralph and Or,
>>
>> The way I reproduce that behavior is by modifying the state of a queue
>> pair into IB_QPS_ERR while RDMA is ongoing. The application, which is
>> multithreaded, performs RDMA by calling ib_post_recv() and
>> ib_post_send() (opcodes IB_WR_SEND, IB_WR_RDMA_READ and
>> IB_WR_RDMA_WRITE). This has been observed with the mlx4 driver, a
>> ConnectX HCA and firmware version 2.7.0.
>>
>> Bart.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
