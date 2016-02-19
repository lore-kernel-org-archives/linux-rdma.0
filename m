From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Recovering from IBV_EVENT_DEVICE_FATAL in librdmacm application?
Date: Fri, 19 Feb 2016 14:39:12 -0500
Message-ID: <56C76F60.4020405@dev.mellanox.co.il>
References: <CAL1RGDXux9KFEUkBeegeiGGJdvKpGv_rRRs-cqNj1U6Nq0YSiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXux9KFEUkBeegeiGGJdvKpGv_rRRs-cqNj1U6Nq0YSiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/19/2016 1:03 PM, Roland Dreier wrote:
> As a side note, how does opensm handle this?  I haven't tried it yet,
> but from reading code I believe that libibumad will not correctly pass
> the ib_umad failure back up to opensm, and so opensm will be stuck
> with a dead /dev/infiniband/umadX file handle forever.  Is that
> assessment correct?

Yes, your assessment is correct.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
