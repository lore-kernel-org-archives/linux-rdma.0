From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 14:14:56 +0100
Message-ID: <526544F002000078000FC5DF@nat28.tlf.novell.com>
References: <20131021115740.GN20913@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131021115740.GN20913-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>> On 21.10.13 at 13:57, Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org> wrote:
> I'm trying to get SR-IOV working under Xen (4.2). It almost works except
> memory bug. This is easily reproducible just in Dom0. 

So without any SR-IOV then, I suppose?

> [23502.645455] mlx4_core 0000:06:00.0: mlx4_ib: Port 1 logical link is up
> [23550.181907] <mlx4_ib> check_flow_steering_support: Device managed flow 
> steering is unavailable for IB port in multifunction env.
> [23550.183822] swap_free: Unused swap offset entry 00000001
> [23550.183868] BUG: Bad page map in process ibv_devinfo  pte:00000200 
> pmd:1b7df4067
> [23550.183939] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          
> (null) mapping:ffff8801b83c0480 index:380fe0882
> [23550.184022] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]

Looking at ib_uverbs_mmap() and its necessary (for mlx4)
descendant mlx4_ib_mmap() I see that the latter calls
io_remap_pfn_range(), but afaict there's nowhere _PAGE_IOMAP
would get set here (as opposed to
arch/x86/pci/i386.c:pci_mmap_page_range() for example). Could
you check whether adding that flag helps? (I'm copying the kernel
maintainers so that they could correct me if I'm wrong here - it
would seem to me that this could equally be the reason for why
there are other reports of certain things not working as expected
in domains with more than 4Gb.)

You could also consider trying an openSUSE kernel - there, other
than upstream, there's no need for each and every caller of
io_remap_pfn_range() to take care of setting _PAGE_IOMAP (and
I vaguely recall having discussed this a couple of years back with
Konrad et al).

Jan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
