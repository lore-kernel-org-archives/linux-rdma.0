From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 1/1] RDMA/odp: convert to use HMM for ODP
Date: Wed, 20 Feb 2019 17:29:24 -0500
Message-ID: <20190220222924.GE29398@redhat.com>
References: <20190129165839.4127-1-jglisse@redhat.com>
 <20190129165839.4127-2-jglisse@redhat.com>
 <f48ed64f-22fe-c366-6a0e-1433e72b9359@mellanox.com>
 <20190212161123.GA4629@redhat.com>
 <20190220222020.GE8415@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190220222020.GE8415@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Aviad Yehezkel <aviadye@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 20, 2019 at 10:20:27PM +0000, Jason Gunthorpe wrote:
> On Tue, Feb 12, 2019 at 11:11:24AM -0500, Jerome Glisse wrote:
> > This is what serialize programming the hw and any concurrent CPU page
> > table invalidation. This is also one of the thing i want to improve
> > long term as mlx5_ib_update_xlt() can do memory allocation and i would
> > like to avoid that ie make mlx5_ib_update_xlt() and its sub-functions
> > as small and to the points as possible so that they could only fail if
> > the hardware is in bad state not because of memory allocation issues.
> 
> How can the translation table memory consumption be dynamic (ie use
> tables sized huge pages until the OS breaks into 4k pages) if the
> tables are pre-allocated?

The idea is to have HMM handle DMA mapping so from the DMA
mapping page table (wether you have an IOMMU or not) you
can build the device page table (leveraging contiguous DMA
address into huge dma page for the hardware). This can happen
before calling mlx5_ib_update_xlt(). Then mlx5_ib_update_xlt()
would only need to program the hardware.

> > > 
> > > > +
> > > > +static uint64_t odp_hmm_flags[HMM_PFN_FLAG_MAX] = {
> > > > +	ODP_READ_BIT,	/* HMM_PFN_VALID */
> > > > +	ODP_WRITE_BIT,	/* HMM_PFN_WRITE */
> > > > +	ODP_DEVICE_BIT,	/* HMM_PFN_DEVICE_PRIVATE */
> > > It seems that the mlx5_ib code in this patch currently ignores the 
> > > ODP_DEVICE_BIT (e.g., in umem_dma_to_mtt). Is that okay? Or is it 
> > > handled implicitly by the HMM_PFN_SPECIAL case?
> > 
> > This is because HMM except a bit for device memory as same API is
> > use for GPU which have device memory. I can add a comment explaining
> > that it is not use for ODP but there just to comply with HMM API.
> > 
> > > 
> > > > @@ -327,9 +287,10 @@ void put_per_mm(struct ib_umem_odp *umem_odp)
> > > >  	up_write(&per_mm->umem_rwsem);
> > > >  
> > > >  	WARN_ON(!RB_EMPTY_ROOT(&per_mm->umem_tree.rb_root));
> > > > -	mmu_notifier_unregister_no_release(&per_mm->mn, per_mm->mm);
> > > > +	hmm_mirror_unregister(&per_mm->mirror);
> > > >  	put_pid(per_mm->tgid);
> > > > -	mmu_notifier_call_srcu(&per_mm->rcu, free_per_mm);
> > > > +
> > > > +	kfree(per_mm);
> > > >  }
> > > Previously the per_mm struct was released through call srcu, but now it 
> > > is released immediately. Is it safe? I saw that hmm_mirror_unregister 
> > > calls mmu_notifier_unregister_no_release, so I don't understand what 
> > > prevents concurrently running invalidations from accessing the released 
> > > per_mm struct.
> > 
> > Yes it is safe, the hmm struct has its own refcount and mirror holds a
> > reference on it, the mm struct itself has a reference on the mm
> > struct.
> 
> The issue here is that that hmm_mirror_unregister() must be a strong
> fence that guarentees no callback is running or will run after
> return. mmu_notifier_unregister did not provide that.
> 
> I think I saw locking in hmm that was doing this..

So pattern is:
    hmm_mirror_register(mirror);

    // Safe for driver to call within HMM with mirror no matter what

    hmm_mirror_unregister(mirror)

    // Driver must no stop calling within HMM, it would be a use after
    // free scenario

Cheers,
Jérôme
