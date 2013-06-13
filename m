From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: recommend setting for dev_loss_tmo and fast_io_fail_tmo
Date: Thu, 13 Jun 2013 19:56:42 +0200
Message-ID: <51BA07DA.40703@acm.org>
References: <CACaajQuhmd8ExRHvQQBES43FNDWKGHxEb0DjmxWJ1K2=ybUuKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQuhmd8ExRHvQQBES43FNDWKGHxEb0DjmxWJ1K2=ybUuKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/13/13 17:52, Vasiliy Tolstov wrote:
> Hello. I'm using 3.9.5 and ib_srp_backport from github.
> What is recommended setting for dev_loss_tmo and fast_io_fail_tmo ?
> Now i have
> dev_loss_tmo = 60
> fast_io_fail_tmo = 40
>
> Does it right?
>
> I need to wait no more 100 seconds for failed path. (i'm use some xen
> vm on this host and it linux kernels not like to stuck more than 120
> seconds =))

Hello Vasily,

The default value for the reconnect_delay parameter in that version of 
the SRP initiator is 10 seconds. So if you want to give the SRP 
initiator a chance to try once to reconnect before failing I/O fast you 
can set the fast_io_fail_tmo parameter to e.g. 15 seconds. That should 
limit the time during which I/O is stuck to about 76 seconds (61 seconds 
IB RC timeout + 15 seconds for the fast I/O fail timeout). How to 
configure dev_loss_tmo depends on the configuration at the initiator 
side. If you are using initiator-side mirroring then it is a good idea 
to set dev_loss_tmo to a very large value in order to avoid /dev/sd* 
reassignment. Note: with the patch series I posted earlier this week it 
is possible to set dev_loss_tmo to "off", something that is not yet 
possible with the ib_srp-backport project.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
