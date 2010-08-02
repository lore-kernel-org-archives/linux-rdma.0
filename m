From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: [PATCH] IB/srp: use multiple CPU cores more effectively
Date: Mon, 02 Aug 2010 22:16:31 +0400
Message-ID: <4C570B7F.2010306@vlnb.net>
References: <201008021015.40472.bvanassche@acm.org>	<4C56C336.4040009@vlnb.net> <AANLkTinBTv5SZJ_H9C15CWZ5hYGFe38840zy78+N-wbO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinBTv5SZJ_H9C15CWZ5hYGFe38840zy78+N-wbO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche, on 08/02/2010 07:57 PM wrote:
>>> SRP I/O with small block sizes causes a high CPU load. Processing IB
>>> completions on the context of a kernel thread instead of in interrupt context
>>> allows to process up to 25% more I/O operations per second. This patch does
>>> add a kernel parameter 'thread' that allows to specify whether to process IB
>>> completions in interrupt context or in kernel thread context. Also, the IB
>>> receive notification processing loop is rewritten as proposed earlier by Ralph
>>> Campbell (see also https://patchwork.kernel.org/patch/89426/). As the
>>> measurement results below show, rewriting the IB receive notification
>>> processing loop did not have a measurable impact on performance. Processing
>>> IB receive notifications in thread context however does have a measurable
>>> impact: workloads with I/O depth one are processed at most 10% slower and
>>> workloads with larger I/O depths are processed up to 25% faster.
>>>
>>> block size  number of    IOPS        IOPS      IOPS
>>>   in bytes    threads     without     with      with
>>>    ($bs)     ($numjobs)  this patch  thread=n  thread=y
>>>     512           1        25,400      25,400    23,100
>>>     512         128       122,000     122,000   153,000
>>>    4096           1        25,000      25,000    22,700
>>>    4096         128       122,000     121,000   157,000
>>>   65536           1        14,300      14,400    13,600
>>>   65536           4        36,700      36,700    36,600
>>> 524288           1         3,470       3,430     3,420
>>> 524288           4         5,020       5,020     4,990
>>>
>>> performance test used to gather the above results:
>>>    fio --bs=${bs} --ioengine=sg --buffered=0 --size=128M --rw=read \
>>>        --thread --numjobs=${numjobs} --loops=100 --group_reporting \
>>>        --gtod_reduce=1 --name=${dev} --filename=${dev}
>>> other ib_srp kernel module parameters: srp_sg_tablesize=128
>>
>> How about results of "dd Xflags=direct" in different modes to find out the lowest
>> latency the driver can process 512 and 4K packets? Sorry, I don't trust fio, when
>> it comes to precise latency measurements.
>
> It would be interesting to compare such results, but unfortunately, dd
> does not provide a way to perform I/O from multiple threads
> simultaneously. I have tried to run multiple dd processes in parallel,
> but that resulted in much lower IOPS results than a comparable
> multithreaded fio test.

I'm interested to see how much your changes affected processing latency, 
i.e. to measure execution latency before and after changes. You can't do 
that with several threads, because latency = 1/bandwidth only if you 
always have only one command at time. So, all those sophisticated 
measurements can't substitute a plane old:

dd if=/dev/sdX of=/dev/null bs=512 iflag=direct
and
dd if=/dev/zero of=/dev/sdX bs=512 oflag=direct

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
