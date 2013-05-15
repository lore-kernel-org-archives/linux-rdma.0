From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Wed, 15 May 2013 12:47:30 +0200
Message-ID: <519367C2.3000107@profitbricks.com>
References: <5167EDC8.3030909@profitbricks.com> <CACaajQs0PswMb5KhpSkE1=_Sd1SwX2BznZP9x1FCkEk6ukJYrA@mail.gmail.com> <5183A355.5090401@acm.org> <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ@mail.gmail.com> <51876D79.50003@profitbricks.com> <51877B71.3080202@acm.org> <518A7233.9070400@profitbricks.com> <CACaajQun61QAM0qqwadWECSFO7UxUaOrdO1-0vGLPQBjdwdMyw@mail.gmail.com> <519266CA.2010306@acm.org> <CACaajQt2V1Y-fQFmXyyAJk57KahbMwBqvEGoF7sug5F1hYyWGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQt2V1Y-fQFmXyyAJk57KahbMwBqvEGoF7sug5F1hYyWGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15.05.2013 07:12, Vasiliy Tolstov wrote:
> 2013/5/14 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
>> The ability to close a session from the initiator side went upstream in
>> kernel 3.8 (/sys/class/srp_remote_ports/port-<h>:<n>/delete). Regarding
>> faster reconnects: please keep in mind that after a cable pull it can easily
>> takes 20 seconds before link training and initialization by the subnet
>> manager have finished. It's not possible to make an initiator reconnect in
>> less time than what the hardware and subnet manager need to bring the link
>> back.
> 
> 
> Thanks. What about close session from target side? For example i need
> to close the srp session and block all access from specific initiator?

AFAIK the session is blocked as long as an initiator is connected. The
only possibility besides disconnecting the initiators is to disable the
target completely. Then, it sends a DREQ (disconnection request) to the
initiators. These know then that the target is disconnected and send a
DREP (disconnection reply). In our patches we also activate the
reconnect in this situation as we do that to orderly reboot a storage
system (e.g. due to an issue). The storage system comes up again,
exports the same volumes and the initiators can reconnect.

Cheers,
Sebastian

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
