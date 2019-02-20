From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 15/19] RDMA/irdma: Add miscellaneous utility definitions
Date: Wed, 20 Feb 2019 09:53:55 -0700
Message-ID: <20190220165355.GG8429@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-16-shiraz.saleem@intel.com>
 <20190215174714.GE30706@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7A5A460B3@fmsmsx124.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A5A460B3@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 20, 2019 at 02:53:18PM +0000, Saleem, Shiraz wrote:
> >Subject: Re: [RFC v1 15/19] RDMA/irdma: Add miscellaneous utility definitions
> >
> >On Fri, Feb 15, 2019 at 11:11:02AM -0600, Shiraz Saleem wrote:
> >> From: Mustafa Ismail <mustafa.ismail@intel.com>
> >>
> >> Add miscellaneous utility functions and headers.
> >>
> 
> [....]
> 
> >
> >> +#define to_device(ptr)						\
> >> +	(&((struct pci_dev *)((ptr)->hw->dev_context))->dev)
> >
> >?? Seems like this wants to be container_of??
> 
> Yes.
> 
> >
> >> +/**
> >> + * irdma_insert_wqe_hdr - write wqe header
> >> + * @wqe: cqp wqe for header
> >> + * @header: header for the cqp wqe
> >> + */
> >> +static inline void irdma_insert_wqe_hdr(__le64 *wqe, u64 hdr) {
> >> +	wmb();   /* make sure WQE is populated before polarity is set */
> >> +	set_64bit_val(wqe, 24, hdr);
> >
> >Generally don't like seeing wmbs in drivers.. Are you sure this isn't supposed to
> >be smp_store_release(), or dma_wmb() perhaps?
> 
> Why is wmb() an issue in drivers?

There are many ways to get a barrier that are much clearer and
maintainable then some random wmb. Rarely do drivers actually need
wmb.

> >> +/**
> >> + * irdma_allocate_dma_mem - Memory alloc helper fn
> >> + * @hw:   pointer to the HW structure
> >> + * @mem:  ptr to mem struct to fill out
> >> + * @size: size of memory requested
> >> + * @alignment: what to align the allocation to  */ enum
> >> +irdma_status_code irdma_allocate_dma_mem(struct irdma_hw *hw,
> >> +					      struct irdma_dma_mem *mem,
> >> +					      u64 size,
> >> +					      u32 alignment)
> >> +{
> >> +	struct pci_dev *pcidev = (struct pci_dev *)hw->dev_context;
> >> +
> >> +	if (!mem)
> >> +		return IRDMA_ERR_PARAM;
> >> +
> >> +	mem->size = ALIGN(size, alignment);
> >> +	mem->va = dma_alloc_coherent(&pcidev->dev, mem->size,
> >> +				     (dma_addr_t *)&mem->pa, GFP_KERNEL);
> >> +	if (!mem->va)
> >> +		return IRDMA_ERR_NO_MEMORY;
> >> +
> >> +	return 0;
> >> +}
> >
> >More wrappers? Why?
> 
> I agree on your previous comment on wrapper for usecnt tracking but this does
> consolidate some common code and avoid duplication.

IRDMA_ERR_PARAM seems like an nonsense thing to do, and why does this
driver have its own custom error codes anyhow? Don't like it, it is
very stange. Once you strip that away there is no code to share.

Jason
