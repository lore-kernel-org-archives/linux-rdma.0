From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: [PATCH v2] IB/srp: use multiple CPU cores more effectively
Date: Wed, 04 Aug 2010 23:45:19 +0400
Message-ID: <4C59C34F.2000400@vlnb.net>
References: <201008031602.37294.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008031602.37294.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche, on 08/03/2010 06:02 PM wrote:
> SRP I/O with small block sizes causes a high CPU load. Processing IB
> completions on the context of a kernel thread instead of in interrupt context
> allows to process up to 25% more I/O operations per second. This patch does
> add a kernel parameter 'thread' that allows to specify whether to process IB
> completions in interrupt context or in kernel thread context. Also, the IB
> receive notification processing loop is rewritten as proposed earlier by Ralph
> Campbell (see also https://patchwork.kernel.org/patch/89426/). As the
> measurement results below show, rewriting the IB receive notification
> processing loop did not have a measurable impact on performance. Processing
> IB receive notifications in thread context however does have a measurable
> impact: workloads with I/O depth one are processed at most 10% slower and
> workloads with larger I/O depths are processed up to 25% faster.

I believe this is a wrong approach for this problem. You are 
workarounding it, not solving, and introducing a bad side effect of 
additional context switch per command, so increasing its processing 
latency. It doesn't matter that it can be switched off. Linux already 
has too many magic knobs where average user for long ago get lost.

If you want to spread requests post processing among several CPUs, you 
should consider real approaches for that:

1. Consider if it's possible to program hardware to spread IRQs for 
incoming packets among several CPU. At least some networking hardware 
allows that, so, I guess, IB also could.

2. Modify SCSI/block layer, so they perform the post processing not on 
the SIRQ level, but in the context of the processes which originated the 
corresponding request. This is, basically, what networking code is doing.

Thus, I'd say NACK to this patch. I don't like hackish workarounds 
instead of real solutions.

Sorry,
Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
