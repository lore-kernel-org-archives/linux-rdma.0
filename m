From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: linux 3.8.6 and srp backports
Date: Mon, 08 Apr 2013 10:23:48 +0200
Message-ID: <51627E94.9010104@acm.org>
References: <CACaajQu0OHOz0Ok-SkxHWPpTBEfRjNFGrPF8z5HX0bdq+sgXeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQu0OHOz0Ok-SkxHWPpTBEfRjNFGrPF8z5HX0bdq+sgXeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/08/13 10:00, Vasiliy Tolstov wrote:
> Hello. Some times ago, when i'm use kernel 3.6 i'm use
> https://github.com/bvanassche/ib_srp-backport/ for srp drivers on my
> linux server.
> Now i'm using 3.8.6, does i need something from
> https://github.com/bvanassche/ib_srp-backport/ or all patches already
> applied in upstream?

Unfortunately not all patches present in the ib_srp-backport project are 
already upstream. If you want to avoid that in a multipath setup sooner 
or later failover or failback fails with a SCSI device in the offline 
state you will still need the ib_srp-backport project. I'm currently 
working on converting that project into a new patch series intended for 
inclusion in the mainline kernel.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
