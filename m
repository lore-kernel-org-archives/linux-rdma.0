From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: linux 3.8.6 and srp backports
Date: Mon, 8 Apr 2013 14:18:29 +0400
Message-ID: <CACaajQvFgAHL6bzk-Umt8HkhDyzO-jO8aV-hL5+j2=sTEWMoUw@mail.gmail.com>
References: <CACaajQu0OHOz0Ok-SkxHWPpTBEfRjNFGrPF8z5HX0bdq+sgXeQ@mail.gmail.com>
 <51627E94.9010104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51627E94.9010104-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2013/4/8 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
> Unfortunately not all patches present in the ib_srp-backport project are
> already upstream. If you want to avoid that in a multipath setup sooner or
> later failover or failback fails with a SCSI device in the offline state you
> will still need the ib_srp-backport project. I'm currently working on
> converting that project into a new patch series intended for inclusion in
> the mainline kernel.

Thanks. I'm already check and approve that i need you github branch
=). Thanks for great work!


--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
