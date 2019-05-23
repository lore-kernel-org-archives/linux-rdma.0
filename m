From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Thu, 23 May 2019 16:10:38 -0300
Message-ID: <20190523191038.GG12159@ziepe.ca>
References: <20190522005225.GA30819@ziepe.ca>
 <20190522174852.GA23038@redhat.com>
 <20190522235737.GD15389@ziepe.ca>
 <20190523150432.GA5104@redhat.com>
 <20190523154149.GB12159@ziepe.ca>
 <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca>
 <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca>
 <20190523182458.GA3571@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190523182458.GA3571@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org


On Thu, May 23, 2019 at 02:24:58PM -0400, Jerome Glisse wrote:
> I can not take mmap_sem in range_register, the READ_ONCE is fine and
> they are no race as we do take a reference on the hmm struct thus

Of course there are use after free races with a READ_ONCE scheme, I
shouldn't have to explain this.

If you cannot take the read mmap sem (why not?), then please use my
version and push the update to the driver through -mm..

Jason
