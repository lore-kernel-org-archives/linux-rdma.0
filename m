From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Thu, 23 May 2019 15:39:59 -0400
Message-ID: <20190523193959.GA5658@redhat.com>
References: <20190522174852.GA23038@redhat.com>
 <20190522235737.GD15389@ziepe.ca>
 <20190523150432.GA5104@redhat.com>
 <20190523154149.GB12159@ziepe.ca>
 <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca>
 <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca>
 <20190523182458.GA3571@redhat.com>
 <20190523191038.GG12159@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190523191038.GG12159@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 04:10:38PM -0300, Jason Gunthorpe wrote:
> 
> On Thu, May 23, 2019 at 02:24:58PM -0400, Jerome Glisse wrote:
> > I can not take mmap_sem in range_register, the READ_ONCE is fine and
> > they are no race as we do take a reference on the hmm struct thus
> 
> Of course there are use after free races with a READ_ONCE scheme, I
> shouldn't have to explain this.

Well i can not think of anything again here the mm->hmm can not
change while driver is calling hmm_range_register() so if you
want i can remove the READ_ONCE() this does not change anything.


> If you cannot take the read mmap sem (why not?), then please use my
> version and push the update to the driver through -mm..

Please see previous threads on why it was a failure.

Cheers,
Jérôme
