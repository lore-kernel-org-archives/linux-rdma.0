From: "Jan Beulich" <jbeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Wed, 23 Oct 2013 17:35:33 +0100
Message-ID: <526808E502000078000A5701@nat28.tlf.novell.com>
References: <52652534.2040303@oracle.com>
 <526545E002000078000FC5F1@nat28.tlf.novell.com>
 <52652E95.3020305@oracle.com> <20131021140607.GQ20913@ics.muni.cz>
 <20131021141855.GA4211@phenom.dumpdata.com>
 <5265560602000078000FC73E@nat28.tlf.novell.com>
 <20131021144407.GC4560@phenom.dumpdata.com>
 <5265609802000078000FC7B7@nat28.tlf.novell.com>
 <20131023153645.GA28011@phenom.dumpdata.com>
 <5267FD3102000078000A56A1@nat28.tlf.novell.com>
 <20131023160433.GA28260@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131023160433.GA28260-6K5HmflnPlqSPmnEAIUT9EEOCMrvLtNR@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> 10/23/13 6:05 PM >>>
>On Wed, Oct 23, 2013 at 04:45:37PM +0100, Jan Beulich wrote:
> So this indeed is only about PCI devices (i.e. not taking into account the
> comment I made earlier [above]).
>
>Correct.
>What are some of those devices? It would help to understand what those are.

The simplest possible thing are MCFG ranges, which aren't required to be
present in the E820 map.

>> And finally - did you check that the bus notification happens after resource
>> assignment?
>
>They do occur during the normal resource assigment. But I presume you
>meant during resource re-assigment?

No, I meant only assignment - iirc, re-assignment is still unimplemented.

Jan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
