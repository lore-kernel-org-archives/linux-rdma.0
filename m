From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Sat, 01 Mar 2014 18:23:57 +0100
Message-ID: <531217AD.3030807@acm.org>
References: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com> <CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ@mail.gmail.com> <CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg@mail.gmail.com> <CAJZOPZKydkaoru0XyT1nHQ5t9BGJQxbq1r4RcGZ0Gq9E9VGs=A@mail.gmail.com> <CACaajQs9ANqLX7m=TcR2wT6wkiS-M5uVvAnQrvGWPmukZnLqcg@mail.gmail.com> <CACaajQuRzBy3oV+-3+NjyE9muGKPN3YQUd5wnkkcoak0GSP=uw@mail.gmail.com> <CACaajQtKvihFu6X-+9N3VvVKK4Jw3eADBOENhuM+-4s8s=PsUQ@mail.gmail.com> <CACaajQuQ+mbwhp4jxUt+9r4Rq=14oBUqC-=xx6J3EGpAfecG-Q@mail.gmail.com> <5311D799.2090607@acm.org> <CACaajQuPrAFNAR8d4NphuVRH+pVGC-Yv=afS1cbkrg=48M8ROg@mail.gmail.com> <CACaajQuXn5+-KQh_XtB3bb-1q9C+5ezAEh26C1TYT=5ncYJvCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQuXn5+-KQh_XtB3bb-1q9C+5ezAEh26C1TYT=5ncYJvCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/01/14 18:16, Vasiliy Tolstov wrote:
> 2014-03-01 20:55 GMT+04:00 Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>:
>> Thanks, but as i understand, 3.10 lts and need to get this updates..
>> But thanks! I'm try to search changelogs for 3.11.
> 
> Hmm. May me i miss something, but i can't see in changelogs for 3.11
> (all) fixes for this error.

I have seen this issue myself with the 3.0 mlx4_en driver but do not see
it anymore with the latest version of this driver. I do not know which
patch fixes this issue. But I have been wondering whether it could have
been the following patch:

commit 0cc5c8bf11852dec3225fda2f53a599243095d23

net/mlx4_en: Fix a race between napi poll function and RX ring cleanup

The RX rings were cleaned while there was still possible RX traffic
completion handling. Change the sequence of events so that the port is
closed and the QPs are being stopped before RX cleanup.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
