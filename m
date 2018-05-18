From: Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH for-next 5/5] IB/isert: Fix for lib/dma_debug check_sync
 warning
Date: Fri, 18 May 2018 13:50:17 -0400
Message-ID: <78d118e0-890f-e368-9190-94e475204740@redhat.com>
References: <20180516012947.12474.2286.stgit@scvm10.sc.intel.com>
 <20180516013137.12474.10259.stgit@scvm10.sc.intel.com>
 <20180516200441.GN25661@ziepe.ca>
 <4039808d-7997-8b95-f1b9-d3d1d181f00e@intel.com>
 <20180517151057.GC10842@ziepe.ca>
 <5372c148-a07c-64bb-5608-9ec64a90ef73@redhat.com>
 <20180518090030.GA24436@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180518090030.GA24436@lst.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 05/18/2018 05:00 AM, Christoph Hellwig wrote:
> On Thu, May 17, 2018 at 07:01:30PM -0400, Don Dutile wrote:
>> Additionally, I believe dma-debug has a bug:
>>   -- doing a check on an op when there is no op in the dma-ops struct is not correct:
> 
> No, that is a feature.
> 
>> Note: above: debug_dma_sync is called indep of whether an op function exists.
>> For hfi1 & qib & rxe -- which use dma-virt-ops for non-IOMMU-enabled configs,
>> the sync_syngle_for_cpu ops does not exist, yet debug_dma_sync is still called.
> 
> Yes, if you call dma ops you better make sure you respect the invariants.
> 
> This is the only way to get the code right for the 90% case where people
> develop on x86 with cache coherent DMA but do calls that only exist
> on non-coherent implementations.
> 
So, if I re-state the above correctly, it's not an issue on x86 (a cache-coherent arch, where we saw
this message occurred), but it would be on a non-cache-coherent arch.
The 'feature' warns the caller even when run on an arch that its not a true issue/warning.

So, to Jason's question as for-rc, no, unless someone has a case of running RDMA on a non-cache-coherent arch... which seems counter-intuitive -- high speed RDMA on low-speed/cache-incorehent arch.

Christoph:
Would you object to a patch that more clearly states the above, i.e., still generates the warning but delineates that it's not an error on the given arch, but potentially other arch's?

I'm getting a fairly decent set of lib/dma-debug bz's atm (since I backported latest dma-map refactoring
& all of lib/dma-debug to RHEL-7), and I'd like to easily discern what needs to be fixed asap, e.g., not checking return value of dma_map(),  vs warnings (that will still be bz'd) I don't have to prioritize over more pressing bz's.
Having the warning provide a bit more info in that area, as suggested above, would help.

Thanks for review & feedback.

- Don
