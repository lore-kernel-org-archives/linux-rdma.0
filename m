From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 0/4] IB/hfi1: Couple more for the RC cycle
Date: Thu, 20 Sep 2018 19:26:26 -0600
Message-ID: <20180921012626.GA13768@ziepe.ca>
References: <20180920195649.20625.38869.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920195649.20625.38869.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Lukasz Odzioba <lukasz.odzioba@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 20, 2018 at 12:58:34PM -0700, Dennis Dalessandro wrote:
> Hi Doug and Jason,
> 
> Mike and Ira have identified some fixes that they would like to see land in the
> RC, these are serious problems and are marked as stable.
> 
> Changes since v1:
> Update Lukasz' email address and fix subject tag.
> 
> ---
> 
> Ira Weiny (1):
>       IB/hfi1: Fix SL array bounds check
> 
> Michael J. Ruhl (3):
>       IB/hfi1: Invalid user input can result in crash
>       IB/hfi1: Fix context recovery when PBC has an UnsupportedVL
>       IB/hfi1: Fix destroy_qp hang after a link down

Applied to for-rc, thanks

Jason
