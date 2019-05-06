From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Mon, 6 May 2019 16:56:57 -0300
Message-ID: <20190506195657.GA30261@ziepe.ca>
References: <20190411181314.19465-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190411181314.19465-1-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 11, 2019 at 02:13:13PM -0400, jglisse@redhat.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> Just fixed Kconfig and build when ODP was not enabled, other than that
> this is the same as v3. Here is previous cover letter:
> 
> Git tree with all prerequisite:
> https://cgit.freedesktop.org/~glisse/linux/log/?h=rdma-odp-hmm-v4
> 
> This patchset convert RDMA ODP to use HMM underneath this is motivated
> by stronger code sharing for same feature (share virtual memory SVM or
> Share Virtual Address SVA) and also stronger integration with mm code to
> achieve that. It depends on HMM patchset posted for inclusion in 5.2 [2]
> and [3].
> 
> It has been tested with pingpong test with -o and others flags to test
> different size/features associated with ODP.
> 
> Moreover they are some features of HMM in the works like peer to peer
> support, fast CPU page table snapshot, fast IOMMU mapping update ...
> It will be easier for RDMA devices with ODP to leverage those if they
> use HMM underneath.
> 
> Quick summary of what HMM is:
>     HMM is a toolbox for device driver to implement software support for
>     Share Virtual Memory (SVM). Not only it provides helpers to mirror a
>     process address space on a device (hmm_mirror). It also provides
>     helper to allow to use device memory to back regular valid virtual
>     address of a process (any valid mmap that is not an mmap of a device
>     or a DAX mapping). They are two kinds of device memory. Private memory
>     that is not accessible to CPU because it does not have all the expected
>     properties (this is for all PCIE devices) or public memory which can
>     also be access by CPU without restriction (with OpenCAPI or CCIX or
>     similar cache-coherent and atomic inter-connect).
> 
>     Device driver can use each of HMM tools separatly. You do not have to
>     use all the tools it provides.
> 
> For RDMA device i do not expect a need to use the device memory support
> of HMM. This device memory support is geared toward accelerator like GPU.
> 
> 
> You can find a branch [1] with all the prerequisite in. This patch is on
> top of rdma-next with the HMM patchset [2] and mmu notifier patchset [3]
> applied on top of it.
> 
> [1] https://cgit.freedesktop.org/~glisse/linux/log/?h=rdma-odp-hmm-v4
> [2] https://lkml.org/lkml/2019/4/3/1032
> [3] https://lkml.org/lkml/2019/3/26/900

Jerome, please let me know if these dependent series are merged during
the first week of the merge window.

This patch has been tested and could go along next week if the
dependencies are met.

Thanks,
Jason
