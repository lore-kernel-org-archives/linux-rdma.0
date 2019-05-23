From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Thu, 23 May 2019 16:47:29 -0300
Message-ID: <20190523194729.GJ12159@ziepe.ca>
References: <20190522235737.GD15389@ziepe.ca>
 <20190523150432.GA5104@redhat.com>
 <20190523154149.GB12159@ziepe.ca>
 <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca>
 <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca>
 <20190523182458.GA3571@redhat.com>
 <20190523191038.GG12159@ziepe.ca>
 <20190523193959.GA5658@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190523193959.GA5658@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 03:39:59PM -0400, Jerome Glisse wrote:
> On Thu, May 23, 2019 at 04:10:38PM -0300, Jason Gunthorpe wrote:
> > 
> > On Thu, May 23, 2019 at 02:24:58PM -0400, Jerome Glisse wrote:
> > > I can not take mmap_sem in range_register, the READ_ONCE is fine and
> > > they are no race as we do take a reference on the hmm struct thus
> > 
> > Of course there are use after free races with a READ_ONCE scheme, I
> > shouldn't have to explain this.
> 
> Well i can not think of anything again here the mm->hmm can not
> change while driver is calling hmm_range_register() 

Oh of course! It is so confusing because the new code makes it look like
it could be changing...

> so if you want i can remove the READ_ONCE() this does not change
> anything.

Please just write it as:
  
  /* The caller must hold a valid struct hmm_mirror to call this api,
   * and a valid hmm_mirror guarantees mm->hmm is valid.
   */
  range->hmm = mm->hmm;
  kref_get(&range->hmm->kref);

All the READ_ONCE/kref_get_not_zero/!hmm just obfuscates the reality
that hmm is non-NULL and constant here or the caller is using the API
wrong.

kref_get will reliably oops or WARN_ON if it is misused which is a
fine amount of debugging.

Jason
