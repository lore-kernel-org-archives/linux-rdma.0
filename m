From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [RFC v1 15/19] RDMA/irdma: Add miscellaneous utility definitions
Date: Wed, 20 Feb 2019 14:53:18 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A460B3@fmsmsx124.amr.corp.intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-16-shiraz.saleem@intel.com>
 <20190215174714.GE30706@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215174714.GE30706@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
List-Id: linux-rdma@vger.kernel.org

>Subject: Re: [RFC v1 15/19] RDMA/irdma: Add miscellaneous utility definitions
>
>On Fri, Feb 15, 2019 at 11:11:02AM -0600, Shiraz Saleem wrote:
>> From: Mustafa Ismail <mustafa.ismail@intel.com>
>>
>> Add miscellaneous utility functions and headers.
>>

[....]

>
>> +#define to_device(ptr)						\
>> +	(&((struct pci_dev *)((ptr)->hw->dev_context))->dev)
>
>?? Seems like this wants to be container_of??

Yes.

>
>> +/**
>> + * irdma_insert_wqe_hdr - write wqe header
>> + * @wqe: cqp wqe for header
>> + * @header: header for the cqp wqe
>> + */
>> +static inline void irdma_insert_wqe_hdr(__le64 *wqe, u64 hdr) {
>> +	wmb();   /* make sure WQE is populated before polarity is set */
>> +	set_64bit_val(wqe, 24, hdr);
>
>Generally don't like seeing wmbs in drivers.. Are you sure this isn't supposed to
>be smp_store_release(), or dma_wmb() perhaps?

Why is wmb() an issue in drivers?

>
>> +/**
>> + * irdma_inetaddr_event - system notifier for ipv4 addr events
>> + * @notfier: not used
>> + * @event: event for notifier
>> + * @ptr: if address
>> + */
>> +int irdma_inetaddr_event(struct notifier_block *notifier,
>> +			 unsigned long event,
>> +			 void *ptr)
>> +{
>> +	struct in_ifaddr *ifa = ptr;
>> +	struct net_device *event_netdev = ifa->ifa_dev->dev;
>> +	struct net_device *netdev;
>> +	struct net_device *upper_dev;
>> +	struct irdma_device *iwdev;
>> +	u32 local_ipaddr;
>> +
>> +	iwdev = irdma_find_netdev(event_netdev);
>
>This is all being changed too (and is probably wrongly locked here)

OK. We ll adapt it based on your new series. Thanks!

[...]

>
>> +/**
>> + * irdma_add_devusecount - add dev refcount
>> + * @iwdev: dev for refcount
>> + */
>> +void irdma_add_devusecount(struct irdma_device *iwdev) {
>> +	atomic64_inc(&iwdev->use_count);
>> +}
>> +
>> +/**
>> + * irdma_rem_devusecount - decrement refcount for dev
>> + * @iwdev: device
>> + */
>> +void irdma_rem_devusecount(struct irdma_device *iwdev) {
>> +	if (!atomic64_dec_and_test(&iwdev->use_count))
>> +		return;
>> +	wake_up(&iwdev->close_wq);
>> +}
>> +
>> +/**
>> + * irdma_add_pdusecount - add pd refcount
>> + * @iwpd: pd for refcount
>> + */
>> +void irdma_add_pdusecount(struct irdma_pd *iwpd) {
>> +	atomic_inc(&iwpd->usecount);
>> +}
>
>Why do we have these wrappers? Don't like wrappers liket his.
>
>Are you sure this should be an atomic, not a kref, refcount, etc?
>
>Very concerning to refcounting of HW object structures like this.. Most often when
>I see this in IB drivers it comes along with concurrency bugs in the destroy path.

The need for it is being re-visited and will likely go away.

>
>> +/**
>> + * irdma_allocate_dma_mem - Memory alloc helper fn
>> + * @hw:   pointer to the HW structure
>> + * @mem:  ptr to mem struct to fill out
>> + * @size: size of memory requested
>> + * @alignment: what to align the allocation to  */ enum
>> +irdma_status_code irdma_allocate_dma_mem(struct irdma_hw *hw,
>> +					      struct irdma_dma_mem *mem,
>> +					      u64 size,
>> +					      u32 alignment)
>> +{
>> +	struct pci_dev *pcidev = (struct pci_dev *)hw->dev_context;
>> +
>> +	if (!mem)
>> +		return IRDMA_ERR_PARAM;
>> +
>> +	mem->size = ALIGN(size, alignment);
>> +	mem->va = dma_alloc_coherent(&pcidev->dev, mem->size,
>> +				     (dma_addr_t *)&mem->pa, GFP_KERNEL);
>> +	if (!mem->va)
>> +		return IRDMA_ERR_NO_MEMORY;
>> +
>> +	return 0;
>> +}
>
>More wrappers? Why?

I agree on your previous comment on wrapper for usecnt tracking but this does
consolidate some common code and avoid duplication.

Shiraz 
