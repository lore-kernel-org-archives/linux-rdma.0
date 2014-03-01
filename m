From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Sat, 01 Mar 2014 13:50:33 +0100
Message-ID: <5311D799.2090607@acm.org>
References: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com> <CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ@mail.gmail.com> <CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg@mail.gmail.com> <CAJZOPZKydkaoru0XyT1nHQ5t9BGJQxbq1r4RcGZ0Gq9E9VGs=A@mail.gmail.com> <CACaajQs9ANqLX7m=TcR2wT6wkiS-M5uVvAnQrvGWPmukZnLqcg@mail.gmail.com> <CACaajQuRzBy3oV+-3+NjyE9muGKPN3YQUd5wnkkcoak0GSP=uw@mail.gmail.com> <CACaajQtKvihFu6X-+9N3VvVKK4Jw3eADBOENhuM+-4s8s=PsUQ@mail.gmail.com> <CACaajQuQ+mbwhp4jxUt+9r4Rq=14oBUqC-=xx6J3EGpAfecG-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQuQ+mbwhp4jxUt+9r4Rq=14oBUqC-=xx6J3EGpAfecG-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/28/14 19:35, Vasiliy Tolstov wrote:
> [292670.940309] WARNING: at
> /tmp/buildd/linux-3.10.11/net/sched/sch_generic.c:255
> dev_watchdog+0xe3/0x153()
> [292670.940359] NETDEV WATCHDOG: ib0 (mlx4_core): transmit queue 0 timed out

I'm not sure but I think there is a fix in kernel 3.11 for this issue.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
