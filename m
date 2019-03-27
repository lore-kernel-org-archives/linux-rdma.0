From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 0/5] IB/hfi1: Fixes for 5.1 rc cycle
Date: Wed, 27 Mar 2019 14:58:06 -0300
Message-ID: <20190327175806.GA32589@ziepe.ca>
References: <20190318165205.23550.97894.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190318165205.23550.97894.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 18, 2019 at 09:54:55AM -0700, Dennis Dalessandro wrote:
> Here is a set of small fixes that we would like to land in the rc cycle
> for 5.1. One of them is marked as stable.
> 
> The first patch fixes an unnecessary stack trace due to incorrect WQ flags. The
> next three fix issues uncovered due to TID RDMA which was brought in for 5.1.
> The last one is a bug in VNIC.
> 
> 
> Kaike Wan (4):
>       IB/hfi1: Failed to drain send queue when QP is put into error state
>       IB/hfi1: Clear the IOWAIT pending bits when QP is put into error state
>       IB/hfi1: Eliminate opcode tests on mr deref
>       IB/hfi1: Fix the allocation of RSM table

Applied these ones to for-rc

> Mike Marciniszyn (1):
>       IB/hfi1: Fix WQ_MEM_RECLAIM warning

Let us see how the discussion goes here

Thanks,
Jason
