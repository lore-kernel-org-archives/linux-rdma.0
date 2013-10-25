From: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Fri, 25 Oct 2013 10:21:47 -0400
Message-ID: <20131025142147.GB3742@phenom.dumpdata.com>
References: <52652534.2040303@oracle.com>
 <526545E002000078000FC5F1@nat28.tlf.novell.com>
 <52652E95.3020305@oracle.com>
 <20131021140607.GQ20913@ics.muni.cz>
 <20131021141855.GA4211@phenom.dumpdata.com>
 <5265560602000078000FC73E@nat28.tlf.novell.com>
 <20131021144407.GC4560@phenom.dumpdata.com>
 <5265609802000078000FC7B7@nat28.tlf.novell.com>
 <20131023153645.GA28011@phenom.dumpdata.com>
 <5269A865.2010100@cantab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5269A865.2010100-5LkwijKnu/2sTnJN9+BGXg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Vrabel <dvrabel-5LkwijKnu/2sTnJN9+BGXg@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 25, 2013 at 12:08:21AM +0100, David Vrabel wrote:
> On 23/10/13 16:36, Konrad Rzeszutek Wilk wrote:
> >On Mon, Oct 21, 2013 at 04:12:56PM +0100, Jan Beulich wrote:
> >>>>>On 21.10.13 at 16:44, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >>>On Mon, Oct 21, 2013 at 03:27:50PM +0100, Jan Beulich wrote:
> >>>>>>>On 21.10.13 at 16:18, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >>>>>On Mon, Oct 21, 2013 at 04:06:07PM +0200, Lukas Hejtmanek wrote:
> >>>>>>         Region 2: Memory at 380fff000000 (64-bit, prefetchable) [size=8M]
> >>>>>...
> >>>>>--- a/arch/x86/xen/setup.c
> >>>>>+++ b/arch/x86/xen/setup.c
> >>>>>@@ -92,6 +92,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
> >>>>>
> >>>>>                 __set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
> >>>>>         }
> >>>>>+       /* Anything past the balloon area is marked as identity. */
> >>>>>+       for (pfn = xen_max_p2m_pfn; pfn < MAX_DOMAIN_PAGES; pfn++)
> >>>>>+               __set_phys_to_machine(pfn, IDENTITY_FRAME(pfn));
> >>>>
> >>>>Hardly - MAX_DOMAIN_PAGES derives from
> >>>>CONFIG_XEN_MAX_DOMAIN_MEMORY, which in turn is unrelated
> >>>>to where MMIO might be. Should you perhaps simply start from
> >>>
> >>>Looks like your mailer ate some words.
> >>
> >>I don't think so - they're all there in the text you quoted.
> >>
> >>>>an all 1:1 mapping, inserting the RAM translations as you find
> >>>>them?
> >>>
> >>>
> >>>Yeah, as this code can be called for the regions under 4GB. Definitly
> >>>needs more analysis.
> >>>
> >>>Were you suggesting a lookup when we scan the PCI devices? (xen_add_device)?
> >>
> >>That was for PVH, and is obviously fragile, as there can be MMIO
> >>regions not matched by any PCI device's BAR. We could hope for
> >>all of them to be below 4Gb, but I think (based on logs I got to see
> >>recently from a certain vendor's upcoming systems) this isn't going
> >>to work out.
> >
> >This is the patch I had in mind that I think will fix these issues. But
> >I would appreciate testing it and naturally send me the dmesg if possible.
> 
> I think there is a simpler way to handle this.
> 
> If INVALID_P2M_ENTRY implies 1:1 and we arrange:

I am a bit afraid to make that assumption.
> 
> a) pfn_to_mfn() to return pfn if the mfn is missing in the p2m

The balloon pages are of missing type (initially). And they should
return INVALID_P2M_ENTRY at start - later on they will return the
scratch_page.

> b) mfn_to_pfn() to return mfn if p2m(m2p(mfn)) != mfn and there is
> no m2p override.

The toolstack can map pages that are are p2m(p2m(mfn)) != mfn and
have no m2p override.

> 
> Then:
> 
> a) The identity p2m entries can be removed.
> b) _PAGE_IOMAP becomes unnecessary.

You still need it for the toolstack to map other guests pages.
(xen_privcmd_map).

I think for right now to fix this issue going ahead and setting
1-1 in the P2M for affected devices (PCI and MCFG) is simpler, b/c:
 - We only do it when said device is in the guest (so if you launch
   and PCI PV guest you can still migrate it - after unplugging the
   device). Assuming all 1-1 regions might not be a healthy (I had
   a heck of time fixing all of the migration issues when I wrote
   the 1:1 code).
 - It will make PVH hypercall to mark I/O regions easier. Instead
   of it assuming that all non-RAM space is I/O regions it will be
   able to selectively setup the entries for said regions. I think
   that is what Jan suggested?
 - This is a bug - so lets fix it as a bug first.

Redoing the P2M is certainly an option but I am not signing
up for that this year. Let me post my two patches that fix
this for PCI devices and MCFG areas.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
