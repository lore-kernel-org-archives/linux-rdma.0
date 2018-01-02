From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: Linux kernel v4.15-rc4 and rdma_rxe
Date: Tue, 2 Jan 2018 08:29:05 -0800
Message-ID: <dd87887d-8641-c8fc-48f1-234e7cf67cb1@wdc.com>
References: <1513732236.2535.25.camel@wdc.com>
 <CAG9sBKP=i9ukbkj7x11oW=yLAz8u2RYHTMbf_Z1h3=nQ3pjfLw@mail.gmail.com>
 <1513983674.2579.27.camel@wdc.com>
 <CAG9sBKOOvvwG6yaQfWG=c04-LQ-Yvw8QbD-jzTm-zJYOFJeEVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKOOvvwG6yaQfWG=c04-LQ-Yvw8QbD-jzTm-zJYOFJeEVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/25/17 05:02, Moni Shoua wrote:
> 1. I will do my best to add more tests to RXE regression. However, it
> may take a while.
> 2. Differences in behavior doesn't necessarily mean that at least one
> implementation is wrong. In what you describe it is hard to understand
> what you think is wrong with RXE, If I understand it right the script
> tried to delete a directory that ib_srpt owns (configs or such?) and
> this operation waits for a completion. If this is right do you know
> who is expected to call complete()? It sound unlikely that rxe is the
> one.
> 3. Despite that, let's try this: when script hangs, can you run echo t
> > /proc/sysrq-trigger and see if you something in dmesg that can
> explain the hang? Maybe a trace that rdma_rxe is a part of it?

Hello Moni,

The ib_srpt driver uses zero-length writes to trigger the completion 
handler if either an RTU event is received or an RDMA channel is being 
closed. In the log I saw the message "queued zerolength write" appear 
but not "srpt_zerolength_write_done: wc->status = ..." when the hang was 
observed. That made me wonder whether the rxe driver perhaps suppresses 
completions for zero-length writes if the queue pair state is changed 
into IB_QPS_ERR? I think it is required by the IB spec to queue an error 
completion for pending work requests upon the transition to IB_QPS_ERR.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
