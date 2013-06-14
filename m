From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: recommend setting for dev_loss_tmo and fast_io_fail_tmo
Date: Fri, 14 Jun 2013 15:33:15 +0200
Message-ID: <51BB1B9B.7080206@acm.org>
References: <CACaajQuhmd8ExRHvQQBES43FNDWKGHxEb0DjmxWJ1K2=ybUuKQ@mail.gmail.com> <51BA07DA.40703@acm.org> <CACaajQvBL_DvBXTaMOisuXUBzezpiQN6fSaio-VCOYYWpiaBHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQvBL_DvBXTaMOisuXUBzezpiQN6fSaio-VCOYYWpiaBHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/13/13 20:21, Vasiliy Tolstov wrote:
> P.S. In case of kernel 3.9.5 does i need you backported ib_srp driver
> or i can use mainline kernel drivers for faster reconnects?
> P.P.S. Can you provide me subject of e-mail or link to patches to
> switch off dev_loss_tmo?

Hello Vasiliy,

Does this mean that you are not subscribed to the linux-rdma mailing 
list ? A patch series that allows faster reconnects and that allows to 
disable dev_loss_tmo is currently under review. See e.g. 
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg15628.html.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
