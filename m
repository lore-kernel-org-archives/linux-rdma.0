From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Thu, 16 May 2013 10:51:56 +0400
Message-ID: <CACaajQsgYvSJoFomUqNOdHHQPCrc1Jpp1DuckTX=M0n3ZXOyrw@mail.gmail.com>
References: <5167EDC8.3030909@profitbricks.com> <CACaajQs0PswMb5KhpSkE1=_Sd1SwX2BznZP9x1FCkEk6ukJYrA@mail.gmail.com>
 <5183A355.5090401@acm.org> <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ@mail.gmail.com>
 <51876D79.50003@profitbricks.com> <51877B71.3080202@acm.org>
 <518A7233.9070400@profitbricks.com> <CACaajQun61QAM0qqwadWECSFO7UxUaOrdO1-0vGLPQBjdwdMyw@mail.gmail.com>
 <519266CA.2010306@acm.org> <CACaajQt2V1Y-fQFmXyyAJk57KahbMwBqvEGoF7sug5F1hYyWGw@mail.gmail.com>
 <5193B040.5040802@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5193B040.5040802-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/5/15 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
> The traditional approach to block access from a specific initiator is to
> modify the LUN masking configuration at the target side dynamically. More
> information about LUN masking can be found in the scst.conf man page and in
> the srpt/README file. I will make a patch available for ib_srpt that allows
> to close a single session at a time.

Thanks for answers and Thanks for patch, i'm try it.


--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
