From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Wed, 15 May 2013 09:12:57 +0400
Message-ID: <CACaajQt2V1Y-fQFmXyyAJk57KahbMwBqvEGoF7sug5F1hYyWGw@mail.gmail.com>
References: <5167EDC8.3030909@profitbricks.com> <CACaajQs0PswMb5KhpSkE1=_Sd1SwX2BznZP9x1FCkEk6ukJYrA@mail.gmail.com>
 <5183A355.5090401@acm.org> <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ@mail.gmail.com>
 <51876D79.50003@profitbricks.com> <51877B71.3080202@acm.org>
 <518A7233.9070400@profitbricks.com> <CACaajQun61QAM0qqwadWECSFO7UxUaOrdO1-0vGLPQBjdwdMyw@mail.gmail.com>
 <519266CA.2010306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519266CA.2010306-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/5/14 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
> The ability to close a session from the initiator side went upstream in
> kernel 3.8 (/sys/class/srp_remote_ports/port-<h>:<n>/delete). Regarding
> faster reconnects: please keep in mind that after a cable pull it can easily
> takes 20 seconds before link training and initialization by the subnet
> manager have finished. It's not possible to make an initiator reconnect in
> less time than what the hardware and subnet manager need to bring the link
> back.


Thanks. What about close session from target side? For example i need
to close the srp session and block all access from specific initiator?

--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
