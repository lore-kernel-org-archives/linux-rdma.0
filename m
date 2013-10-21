From: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 10:44:07 -0400
Message-ID: <20131021144407.GC4560@phenom.dumpdata.com>
References: <20131021115740.GN20913@ics.muni.cz>
 <52652534.2040303@oracle.com>
 <526545E002000078000FC5F1@nat28.tlf.novell.com>
 <52652E95.3020305@oracle.com>
 <20131021140607.GQ20913@ics.muni.cz>
 <20131021141855.GA4211@phenom.dumpdata.com>
 <5265560602000078000FC73E@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5265560602000078000FC73E-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 21, 2013 at 03:27:50PM +0100, Jan Beulich wrote:
> >>> On 21.10.13 at 16:18, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > On Mon, Oct 21, 2013 at 04:06:07PM +0200, Lukas Hejtmanek wrote:
> >>         Region 2: Memory at 380fff000000 (64-bit, prefetchable) [size=8M]
> >...
> > --- a/arch/x86/xen/setup.c
> > +++ b/arch/x86/xen/setup.c
> > @@ -92,6 +92,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
> >  
> >                 __set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
> >         }
> > +       /* Anything past the balloon area is marked as identity. */
> > +       for (pfn = xen_max_p2m_pfn; pfn < MAX_DOMAIN_PAGES; pfn++)
> > +               __set_phys_to_machine(pfn, IDENTITY_FRAME(pfn));
> 
> Hardly - MAX_DOMAIN_PAGES derives from
> CONFIG_XEN_MAX_DOMAIN_MEMORY, which in turn is unrelated
> to where MMIO might be. Should you perhaps simply start from

Looks like your mailer ate some words.

> an all 1:1 mapping, inserting the RAM translations as you find
> them?


Yeah, as this code can be called for the regions under 4GB. Definitly
needs more analysis.

Were you suggesting a lookup when we scan the PCI devices? (xen_add_device)?

> 
> Jan
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
