From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: Change for phy clock divisor
Date: Thu, 8 Dec 2011 10:27:17 -0700
Message-ID: <6616CDC1126C644EA43A3D26F120DDFA02617A0498@azsmsx504.amr.corp.intel.com>
References: <20111207222406.GA4012@TENIKOLO-MOBL>
 <CAG4TOxMjjT3+NJZFito656=O+cVDw_FXWAZ-vyjWsPF415+5vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxMjjT3+NJZFito656=O+cVDw_FXWAZ-vyjWsPF415+5vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the patch we modify a register, which controls the divisor of the core clock for the MDIO bus clock (MDC).
The maximum standard value of the MDC is 2.5MHz, currently it is set to 3.5MHz.
We want to comply to the spec.

-----Original Message-----
From: roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Roland Dreier
Subject: Re: [PATCH] RDMA/nes: Change for phy clock divisor

<Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Change the MDIO bus clock to frequency 2.5MHz

Any comment on why you want to change the bus clock?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
