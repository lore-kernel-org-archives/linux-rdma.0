From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Wed, 22 May 2019 19:52:20 -0300
Message-ID: <20190522225220.GC15389@ziepe.ca>
References: <20190411181314.19465-1-jglisse@redhat.com>
 <20190506195657.GA30261@ziepe.ca>
 <20190521205321.GC3331@redhat.com>
 <20190522005225.GA30819@ziepe.ca>
 <20190522174852.GA23038@redhat.com>
 <20190522201247.GH6054@ziepe.ca>
 <20190522220419.GB20179@redhat.com>
 <20190522223906.GA15389@ziepe.ca>
 <20190522224211.GF20179@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522224211.GF20179@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 22, 2019 at 06:42:11PM -0400, Jerome Glisse wrote:

> > > The way race is avoided is because mm->hmm will either be NULL or
> > > point to another hmm struct before an existing hmm is free. 
> > 
> > There is no locking on mm->hmm so it is useless to prevent races.
> 
> There is locking on mm->hmm

Not in mm_get_hmm()

> > So we agree this patch is necessary? Can you test it an ack it please?
> 
> A slightly different patch than this one is necessary i will work on
> it tomorrow.

I think if you want something different you should give feedback on
this patch. You haven't rasied any defects with it.

Jason
