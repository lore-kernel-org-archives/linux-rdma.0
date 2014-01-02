From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Thu, 2 Jan 2014 14:18:23 +0000
Message-ID: <52C5752F.3080005@citrix.com>
References: <52652534.2040303@oracle.com>	<526545E002000078000FC5F1@nat28.tlf.novell.com>	<52652E95.3020305@oracle.com> <20131021140607.GQ20913@ics.muni.cz>	<20131021141855.GA4211@phenom.dumpdata.com>	<5265560602000078000FC73E@nat28.tlf.novell.com>	<20131021144407.GC4560@phenom.dumpdata.com>	<5265609802000078000FC7B7@nat28.tlf.novell.com>	<20131023153645.GA28011@phenom.dumpdata.com>	<5269A865.2010100@cantab.net>	<20131025142147.GB3742@phenom.dumpdata.com> <A9667DDFB95DB7438FA9D7D576C3D87E0A99CE00@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0A99CE00-0J0gbvR4kTg/UvCtAeCM4rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang, Yang Z" <yang.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, "Liu, Jijiang" <jijiang.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26/12/13 06:39, Zhang, Yang Z wrote:
> 
> Any conclusion for this issue? Our custom also saw the same issue
> that they want to map an MMIO to userspace address(through UIO
> approach), but current ->mmap function call remap_pfn_range without
> setting _PAGE_IOMAP and cause the host crashed. It seems all
> userspace device drivers that tries to map device's mmio will caused
> host crashed.
> 
> They are using 3.10 kernel.

My first attempt at fixing this was broken and I need to find time for
another look.

There were problems with pages that started out pre-ballooned.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
