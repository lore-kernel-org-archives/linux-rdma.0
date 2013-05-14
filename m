From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Tue, 14 May 2013 18:31:06 +0200
Message-ID: <519266CA.2010306@acm.org>
References: <5167EDC8.3030909@profitbricks.com> <CACaajQs0PswMb5KhpSkE1=_Sd1SwX2BznZP9x1FCkEk6ukJYrA@mail.gmail.com> <5183A355.5090401@acm.org> <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ@mail.gmail.com> <51876D79.50003@profitbricks.com> <51877B71.3080202@acm.org> <518A7233.9070400@profitbricks.com> <CACaajQun61QAM0qqwadWECSFO7UxUaOrdO1-0vGLPQBjdwdMyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQun61QAM0qqwadWECSFO7UxUaOrdO1-0vGLPQBjdwdMyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/14/13 12:00, Vasiliy Tolstov wrote:
> if i need faster reconnects and ability to close session from
> initiator side under qlogic hardware, does it possible? Or this
> patches only covers mallanox cards?

The ability to close a session from the initiator side went upstream in 
kernel 3.8 (/sys/class/srp_remote_ports/port-<h>:<n>/delete). Regarding 
faster reconnects: please keep in mind that after a cable pull it can 
easily takes 20 seconds before link training and initialization by the 
subnet manager have finished. It's not possible to make an initiator 
reconnect in less time than what the hardware and subnet manager need to 
bring the link back.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
