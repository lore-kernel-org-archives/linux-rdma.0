From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: Can someone help me understand the reason for this code in
 ib_isert.c?
Date: Tue, 21 Oct 2014 22:06:37 -0700
Message-ID: <1413954397.30983.33.camel@haakon3.risingtidesystems.com>
References: <462EF229174FDB4D92ACE4656EA5610051E2EEF9@CMEXMB1.ad.emulex.com>
	 <CAJ3xEMjmmt1guJO8rF6ChnTq-ZQbt9dpb_hwsNQCR65C79waRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjmmt1guJO8rF6ChnTq-ZQbt9dpb_hwsNQCR65C79waRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Moore <Chris.Moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2014-10-21 at 00:13 +0300, Or Gerlitz wrote:
> On Mon, Oct 20, 2014 at 6:29 PM, Chris Moore <Chris.Moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> > The following code is in isert_conn_setup_qp() in ib_isert.c:
> >
> >          /*
> >            * FIXME: Use devattr.max_sge - 2 for max_send_sge as
> >            * work-around for RDMA_READ..
> >            */
> >          attr.cap.max_send_sge = device->dev_attr.max_sge - 2;
> >
> > It's not clear from the comment what this is a work-around for, and I wasn't able
> > to figure it out from looking at logs.
>
> I believe this refers to some IBTA spec corner case which comes into
> play with the max_sges advertized by mlx4, Eli, can you shed some
> light (IBTA pointer) on that? is this the case (i.e dev_attr.max_sge
> isn't always achievable) with mlx5 too?
> 

It's for ConnectX-2 reporting max_sge=31 during development, while the
largest max_send_sge for stable large block RDMA reads was (is..?) 29
SGEs.

> > In trying to get isert working with ocrdma I ran into a problem where the code
> > thought there was only 1 send SGE available when in fact the device has 3.
> > Then I found the above work-around, which explained the problem.
> 
> Nic, any reason for attr.cap.max_send_sge = 1 not to work OK?
> 

IIRC, pre fastreg code supported max_send_sge=1 by limiting the transfer
size per RDMA read, and would issue subsequent RDMA read + offset from
completion up to the total se_cmd->data_length.

Not sure how this works with fastreg today.  Sagi..?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
