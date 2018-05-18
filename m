From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-next 5/5] IB/isert: Fix for lib/dma_debug
        check_sync warning
Date: Fri, 18 May 2018 11:00:30 +0200
Message-ID: <20180518090030.GA24436@lst.de>
References: <20180516012947.12474.2286.stgit@scvm10.sc.intel.com> <20180516013137.12474.10259.stgit@scvm10.sc.intel.com> <20180516200441.GN25661@ziepe.ca> <4039808d-7997-8b95-f1b9-d3d1d181f00e@intel.com> <20180517151057.GC10842@ziepe.ca> <5372c148-a07c-64bb-5608-9ec64a90ef73@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5372c148-a07c-64bb-5608-9ec64a90ef73@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Don Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 17, 2018 at 07:01:30PM -0400, Don Dutile wrote:
> Additionally, I believe dma-debug has a bug:
>  -- doing a check on an op when there is no op in the dma-ops struct is not correct:

No, that is a feature.

> Note: above: debug_dma_sync is called indep of whether an op function exists.
> For hfi1 & qib & rxe -- which use dma-virt-ops for non-IOMMU-enabled configs,
> the sync_syngle_for_cpu ops does not exist, yet debug_dma_sync is still called.

Yes, if you call dma ops you better make sure you respect the invariants.

This is the only way to get the code right for the 90% case where people
develop on x86 with cache coherent DMA but do calls that only exist
on non-coherent implementations.
