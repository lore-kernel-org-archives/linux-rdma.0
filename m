From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/1] RDMA/odp: convert to use HMM for ODP
Date: Thu, 21 Feb 2019 15:59:37 -0700
Message-ID: <20190221225937.GS17500@ziepe.ca>
References: <20190129165839.4127-1-jglisse@redhat.com>
 <20190129165839.4127-2-jglisse@redhat.com>
 <f48ed64f-22fe-c366-6a0e-1433e72b9359@mellanox.com>
 <20190212161123.GA4629@redhat.com>
 <20190220222020.GE8415@mellanox.com>
 <20190220222924.GE29398@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190220222924.GE29398@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Aviad Yehezkel <aviadye@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 20, 2019 at 05:29:24PM -0500, Jerome Glisse wrote:
> > > 
> > > Yes it is safe, the hmm struct has its own refcount and mirror holds a
> > > reference on it, the mm struct itself has a reference on the mm
> > > struct.
> > 
> > The issue here is that that hmm_mirror_unregister() must be a strong
> > fence that guarentees no callback is running or will run after
> > return. mmu_notifier_unregister did not provide that.
> > 
> > I think I saw locking in hmm that was doing this..
> 
> So pattern is:
>     hmm_mirror_register(mirror);
> 
>     // Safe for driver to call within HMM with mirror no matter what
> 
>     hmm_mirror_unregister(mirror)
> 
>     // Driver must no stop calling within HMM, it would be a use after
>     // free scenario

This statement is the opposite direction

I want to know that HMM doesn't allow any driver callbacks to be
running after unregister - because I am going to kfree mirror and
other memory touched by the driver callbacks.

Jason
