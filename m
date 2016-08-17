From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFI] ucmatose: No effect to set service type for QoS
Date: Wed, 17 Aug 2016 16:29:25 -0400
Message-ID: <20160817202925.GD27477@phlsvsds.ph.intel.com>
References: <CAMGffEn=dQsBzV9SPsVTJdsppJ65n_FFiRRASyrjwnmMNmCuDQ@mail.gmail.com> <170f9d79-2351-d95f-9ed1-eddedc467d68@dev.mellanox.co.il> <CAMGffEmP_ouVu5v1cGGENqD9dssgtAqTg39-xa6--NaUkf1aVw@mail.gmail.com> <dbf070a3-e6c0-74b6-9127-7f77e0594b2f@dev.mellanox.co.il> <CAMGffE=NRqut_4USfa31gDbdao2u7AabJD0BS+tP5mSwtED1Cg@mail.gmail.com> <853d9a54-2c05-669a-835b-f87b29d6da38@dev.mellanox.co.il> <fff82d1f-5aa4-0a63-c4d9-cccb8bf582e1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fff82d1f-5aa4-0a63-c4d9-cccb8bf582e1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 12, 2016 at 09:03:55AM -0400, Hal Rosenstock wrote:

[snip]

> >>>
> >>> It also looks incomplete to me. What invokes rdma_set_service_level ? Is
> >>> it some option in ucma.c:ucma_set_option ?
> >>
> >> The main purpose is for our in house transport kernel module, 
> 
> One more thing:
> 
> How does transport module know which SL to request ?
> 
> In general, SL is based on SM configuration.
> 
> Service ID and QoS Class or Traffic Class are the "higher level" IB
> architected ways to obtain the SL.
>

I agree with Hal here.  ServiceID should be able to define which Path Records
(hence which SLs) are configured by the SM.  In rdmacm applications Service ID
is defined in the IBTA spec

     A11.5 IP PROTOCOL PORTS MAPPING INTO IBTA SERVICE IDS

So it seems if you configure the fabric to be in alignment with this mapping
all should work.

Ira

> 
> >> it
> >> supports all 3 connections
> >> (IPv4, IPv6, and native IB, IB is the default).
> > 
> >>> Current patch doesn't appear to me to be backward compatible. If
> >>> rdma_set_service_level is not called in flow, then SL should not be set
> >>> in SA PR query which is what happens today.
> >>
> >> Good point, I will add check only set SL if not 0,
> > 
> > 0 is a valid SL so an extra bit somewhere is needed to indicate whether
> > a specific SL is being requested.
> > 
> >> but if
> >> rdma_set_service_level is not called,
> >> SL should be 0 as before, shouldn't change SA PR query behavior, or I
> >> missed something?
> > 
> > Component mask for SL in SA PR query is not on currently so that means
> > it's wildcarded rather than 0.
> > 
> >>> Also, if SL is set in query, you probably don't need some of the other
> >>> fields that are being set.
> >>>
> >> Do you mean SL shouldn't be set with other fields, what's the side effect there?
> > 
> > Never mind. It's probably best to leave those other fields as is.
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
