From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp: use multiple CPU cores more effectively
Date: Mon, 02 Aug 2010 14:36:49 -0400
Message-ID: <1280774209.2451.10.camel@lap75545.ornl.gov>
References: <201008021015.40472.bvanassche@acm.org> <4C56C336.4040009@vlnb.net>
 <AANLkTinBTv5SZJ_H9C15CWZ5hYGFe38840zy78+N-wbO@mail.gmail.com>
 <4C570B7F.2010306@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4C570B7F.2010306-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-08-02 at 22:16 +0400, Vladislav Bolkhovitin wrote:
> Bart Van Assche, on 08/02/2010 07:57 PM wrote:
> >>>
> >>> block size  number of    IOPS        IOPS      IOPS
> >>>   in bytes    threads     without     with      with
> >>>    ($bs)     ($numjobs)  this patch  thread=n  thread=y
> >>>     512           1        25,400      25,400    23,100
> >>>     512         128       122,000     122,000   153,000
> >>>    4096           1        25,000      25,000    22,700
> >>>    4096         128       122,000     121,000   157,000
> >>>   65536           1        14,300      14,400    13,600
> >>>   65536           4        36,700      36,700    36,600
> >>> 524288           1         3,470       3,430     3,420
> >>> 524288           4         5,020       5,020     4,990

> I'm interested to see how much your changes affected processing latency, 
> i.e. to measure execution latency before and after changes. You can't do 
> that with several threads, because latency = 1/bandwidth only if you 
> always have only one command at time. So, all those sophisticated 
> measurements can't substitute a plane old:

If my assumption that --numjobs=1 puts fio into a single-threaded mode
is correct, it seems that using this patch hurts individual command
latency, at least in a gross sense. The table listed above shows a ~9%
hit for single-threaded 0.5 KB and 4 KB requests, ~4.8% for 64 KB
requests, and ~1.4% for 512 KB requests. It seems to win @ lots of
requests and small block sizes, but still seems to hurt performance at
larger request sizes, though it seems they were tested with smaller
thread counts.

I've not reviewed the patch yet, but that's how I read the table above.
I'm assuming latency is hurt by the need to schedule the kernel thread,
but the batching helps increase the IOPS for low request sizes.

Bart, you could also try xdd as a benchmark tool.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
