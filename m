From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 14:18:56 +0100
Message-ID: <526545E002000078000FC5F1@nat28.tlf.novell.com>
References: <20131021115740.GN20913@ics.muni.cz>
 <52652534.2040303@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52652534.2040303-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: konrad wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>> On 21.10.13 at 14:59, konrad wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> It is a bug in the drivers I believe. The issue is that the mapping 
> created for the second mmap
> call is done without VM_IO and on an PFN that is RAM (and not the BAR). 

So while putting together the reply that I had sent to Lukas a
minute ago I was actually hunting for that VM_IO -> _PAGE_IOMAP
translation, and wasn't able to find it anywhere. As you say it
nevertheless exists - what am I overlooking (and why would then
pci_mmap_page_range() nevertheless have to set _PAGE_IOMAP
by hand)?

Jan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
