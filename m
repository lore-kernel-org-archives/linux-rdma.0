From: Andrea Parri <andrea.parri@amarulasolutions.com>
Subject: Re: [PATCH 5/5] IB/hfi1: Fix improper uses of smp_mb__before_atomic()
Date: Tue, 14 May 2019 16:48:06 +0200
Message-ID: <20190514144806.GA14962@andrea>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
 <14063C7AD467DE4B82DEDB5C278E8663BE6AADCE@FMSMSX108.amr.corp.intel.com>
 <20190429231657.GA2733@andrea>
 <20190509211221.GA4966@andrea>
 <0a78eded-6c08-8d32-ec31-d62d6feb2118@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0a78eded-6c08-8d32-ec31-d62d6feb2118@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: "Ruhl, Michael J" <michael.j.ruhl@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 14, 2019 at 08:32:52AM -0400, Dennis Dalessandro wrote:
> On 5/9/2019 5:12 PM, Andrea Parri wrote:
> >On Tue, Apr 30, 2019 at 01:16:57AM +0200, Andrea Parri wrote:
> >>Hi Mike,
> >>
> >>>>This barrier only applies to the read-modify-write operations; in
> >>>>particular, it does not apply to the atomic_read() primitive.
> >>>>
> >>>>Replace the barrier with an smp_mb().
> >>>
> >>>This is one of a couple of barrier issues that we are currently looking into.
> >>>
> >>>See:
> >>>
> >>>[PATCH for-next 6/9] IB/rdmavt: Add new completion inline
> >>>
> >>>We will take a look at this one as well.
> >>
> >>Thank you for the reference and for looking into this,
> >
> >So, I'm planning to just drop this patch; or can I do something to help?
> >
> >Please let me know.
> 
> Mike was looking into this, and I've got a handful of patches from him to
> review. He's unavailable for a while but if it's not included in the patches
> I've got we'll get something out shortly. So yes I think we can hold off on
> this patch for now. Thanks.

Thank you for the confirmation, Dennis.  I'll hold off on this one.

  Andrea
