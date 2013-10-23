From: "Jan Beulich" <jbeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Wed, 23 Oct 2013 16:45:37 +0100
Message-ID: <5267FD3102000078000A56A1@nat28.tlf.novell.com>
References: <20131021115740.GN20913@ics.muni.cz>
 <52652534.2040303@oracle.com>
 <526545E002000078000FC5F1@nat28.tlf.novell.com>
 <52652E95.3020305@oracle.com> <20131021140607.GQ20913@ics.muni.cz>
 <20131021141855.GA4211@phenom.dumpdata.com>
 <5265560602000078000FC73E@nat28.tlf.novell.com>
 <20131021144407.GC4560@phenom.dumpdata.com>
 <5265609802000078000FC7B7@nat28.tlf.novell.com>
 <20131023153645.GA28011@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131023153645.GA28011-6K5HmflnPlqSPmnEAIUT9EEOCMrvLtNR@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> 10/23/13 5:37 PM >>>
>On Mon, Oct 21, 2013 at 04:12:56PM +0100, Jan Beulich wrote:
>> > Were you suggesting a lookup when we scan the PCI devices? (xen_add_device)?
>> 
>> That was for PVH, and is obviously fragile, as there can be MMIO
>> regions not matched by any PCI device's BAR. We could hope for
>> all of them to be below 4Gb, but I think (based on logs I got to see
>> recently from a certain vendor's upcoming systems) this isn't going
>> to work out.
>
>This is the patch I had in mind that I think will fix these issues. But
>I would appreciate testing it and naturally send me the dmesg if possible.

So this indeed is only about PCI devices (i.e. not taking into account the
comment I made earlier [above]).

Further, a brute force loop over all balloon pages seems like a pretty
bad thing to do when the balloon is rather big.

And finally - did you check that the bus notification happens after resource
assignment?

Jan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
