From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Wed, 21 Oct 2015 13:21:03 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1510211319520.10833@east.gentwo.org>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com> <1444909482-17113-2-git-send-email-eranbe@mellanox.com> <56276095.6020803@dev.mellanox.co.il> <56276336.7000704@mellanox.com> <56279CA4.8040201@dev.mellanox.co.il>
 <CAJ3xEMgWcpKbKL3jhiK2RP=H6_iY0eriirAXn1TJaSG7u8frAA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgWcpKbKL3jhiK2RP=H6_iY0eriirAXn1TJaSG7u8frAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 21 Oct 2015, Or Gerlitz wrote:

> Again, the kernel stack consuming rate here was < 1 bit a year when
> averaging over time since this was introduced. So we should be doing
> well for the coming ~10-20 years with this 32 bit field, and we can
> easily extend it later, I verified that with Haggai, so yes, don't
> want 64 bits now.

Hmmm... We are running out of dev_cap flags on mlx4 already. They are 32
bits.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
