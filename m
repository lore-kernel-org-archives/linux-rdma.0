From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: ib_post_send execution time
Date: Thu, 23 Oct 2014 11:45:05 -0700
Message-ID: <CAL1RGDVS2h4wJrxsYwjMH6cOz2jXCuUiY-OjZPjQrSu1btkHmw@mail.gmail.com>
References: <CAEv+Kc1mioxX+pUky3a9Wfd8HzzOTAqyjw0tgdf4Qu2956hOaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEv+Kc1mioxX+pUky3a9Wfd8HzzOTAqyjw0tgdf4Qu2956hOaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgenii Smirnov <evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 23, 2014 at 10:21 AM, Evgenii Smirnov
<evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> I am trying to achieve high packet per second throughput with 2-byte
> messages over Infiniband from kernel using IB_SEND verb. The most I
> can get so far is 3.5 Mpps. However, ib_send_bw utility from perftest
> package is able to send 2-byte packets with rate of 9 Mpps.
> After some profiling I found that execution of ib_post_send function
> in kernel takes about 213 ns in average, for the user-space function
> ibv_post_send takes only about 57 ns.
> As I understand, these functions do almost same operations. The work
> request fields and queue pair parameters are also the same. Why do
> they have such big difference in execution times?


Interesting.  I guess it would be useful to look at perf top / and or
get a perf report with "perf report -a -g" when running your high PPS
workload, and see where the time is wasted.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
