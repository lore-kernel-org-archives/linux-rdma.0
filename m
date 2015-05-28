From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Thu, 28 May 2015 09:13:41 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
References: <CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA@mail.gmail.com> <CAJ3xEMinNsQrmQ7atAVkshefBDBQ1HRuGbOT_cJ4RxEj4dWUPA@mail.gmail.com> <20150526160624.GA11800@obsidianresearch.com> <CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
 <20150526185315.GF11800@obsidianresearch.com> <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com> <20150526220724.GC4502@obsidianresearch.com> <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com> <20150527184856.GA16059@obsidianresearch.com>
 <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5566BDE4.50709-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 May 2015, Or Gerlitz wrote:

> The use case is very clear, low latency applications using UD or RAW PACKET
> QPs that needs to know the time it takes for different HW/SW layers to get
> their packets through. The verbs version of SO_TIMESTAMP and friends
> (Documentation/networking/timestamping*)-- Christoph, can you add some info on
> common use-cases for this?

Well timestamp information is widely in the financial industry to track
latency and also for fairness. Exchanges/Brokers etc often must guarantee
that the packet received first is not processed after packets received
later. Packet timestamps in many ways affect processing and are also used
for error checking etc.

What we have to do without this is to use RDTSC to get a timestamp but the
packet reception / sending time then is inaccurate due to the instructions that
have to be executed before and after. And there is additional overhead due
to that processing.

> I bet that > 20 upstream Eth NIC drivers supports time-stamping, so there's no
> reason that a modern HCA will not support it too.

Right. Ethernet timekeeping support and timestamping has become fairly
standard. Even the onboard one do that these days.

> > does not implement a standardized feature,
>
> This is standard in Eth NIC, return the time-stamp of when the packet
> arrived/sent

It needs desperately to be in the standard.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
