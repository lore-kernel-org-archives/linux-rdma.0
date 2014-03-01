From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Sun, 2 Mar 2014 00:06:12 +0400
Message-ID: <CACaajQt_-pxQyLJoDTMTSJ_nnkNCJ5N0UQQZm1=32u4gA_B7KA@mail.gmail.com>
References: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com>
 <CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ@mail.gmail.com>
 <CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg@mail.gmail.com>
 <CAJZOPZKydkaoru0XyT1nHQ5t9BGJQxbq1r4RcGZ0Gq9E9VGs=A@mail.gmail.com>
 <CACaajQs9ANqLX7m=TcR2wT6wkiS-M5uVvAnQrvGWPmukZnLqcg@mail.gmail.com>
 <CACaajQuRzBy3oV+-3+NjyE9muGKPN3YQUd5wnkkcoak0GSP=uw@mail.gmail.com>
 <CACaajQtKvihFu6X-+9N3VvVKK4Jw3eADBOENhuM+-4s8s=PsUQ@mail.gmail.com>
 <CACaajQuQ+mbwhp4jxUt+9r4Rq=14oBUqC-=xx6J3EGpAfecG-Q@mail.gmail.com>
 <5311D799.2090607@acm.org> <CACaajQuPrAFNAR8d4NphuVRH+pVGC-Yv=afS1cbkrg=48M8ROg@mail.gmail.com>
 <CACaajQuXn5+-KQh_XtB3bb-1q9C+5ezAEh26C1TYT=5ncYJvCw@mail.gmail.com> <531217AD.3030807@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531217AD.3030807-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-03-01 21:23 GMT+04:00 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
> I have seen this issue myself with the 3.0 mlx4_en driver but do not see
> it anymore with the latest version of this driver. I do not know which
> patch fixes this issue. But I have been wondering whether it could have
> been the following patch:
>
> commit 0cc5c8bf11852dec3225fda2f53a599243095d23
>
> net/mlx4_en: Fix a race between napi poll function and RX ring cleanup
>
> The RX rings were cleaned while there was still possible RX traffic
> completion handling. Change the sequence of events so that the port is
> closed and the QPs are being stopped before RX cleanup.


Thanks! I'm try it.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
