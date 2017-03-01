From: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: clean ib tx ring periodically
Date: Wed, 01 Mar 2017 10:07:36 +0100
Message-ID: <1488359256.2607.2.camel@redhat.com>
References: <589591340739f0ceeea9ca449b6de3df01caadc4.1487259121.git.pabeni@redhat.com>
         <CAAk-MO_J2JL9YvNEV24LJik8qGKrBHBW+2NtzAOL+QEve1CMJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO_J2JL9YvNEV24LJik8qGKrBHBW+2NtzAOL+QEve1CMJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-01 at 09:28 +0200, Erez Shitrit wrote:
> On Thu, Feb 16, 2017 at 5:35 PM, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > The skbs transmitted via ipoib_send() are freed only if there are
> > 16 or more outstanding work requests or if the send queue is full.
> > 
> > If there is very little networking activity, the transmitted skbs
> > can be held by the device driver for an unlimited amount of time,
> > starving other subsystems.
> > 
> > E.g. assuming the ipv6 is enabled, with the following sequence:
> > 
> > systemctl start firewalld
> > modprobe ib_ipoib
> > ip addr add dev ib0 fc00::1/64
> > systemctl stop firewalld
> > 
> > a cpu will hang: rmmod conntrack will keep a core busy
> > spinning for nf_conntrack_untracked going to 0, since some ICMP6
> > ND packets are generated and transmitted when the ipv6 address
> > is attached to the device, and such packets get a notrack ct
> > entry.
> > 
> > This change address the issue introducing a periodic timer performing
> > "garbage collection" on the send ring at low frequency (once every
> > second).
> > 
> > This new timer runs independently from the currently used poll_timer,
> > so that no additional delay is introduced to clean the ring after
> > errors or ring full event.
> 
> Hi,
> 
> Adding a new timer is not the required solution, it is a w/a over the
> TX part in the ipoib driver.
> The real solution, IMHO, is to use the napi mechanism for the TX in a
> similar way as it done in the RX. (as it done in many network drivers)
> 
> We (Mellanox) are planning to send such solution in the next few days.

Thank you for jumping-in on this.

I think that the tx napi polling implementation for the ipoib driver is
not so straight-forward because, afaics, the ib completion callback is
intentionally avoided for tx - unless in exceptional scenarios -
possibly for performance reason.

Anyway, if you can fix this in a cleaner way, I'll be more than happy. 

Thank you,

Paolo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
