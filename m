From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 3/3] IB/hfi1: Fix incorrect mixing of ERR_PTR and
 NULL return values
Date: Tue, 26 Jun 2018 14:37:54 -0600
Message-ID: <20180626203754.GE5381@ziepe.ca>
References: <20180620162612.13582.28777.stgit@scvm10.sc.intel.com>
 <20180620162904.13582.22527.stgit@scvm10.sc.intel.com>
 <cc4f30ab-3032-4220-ee41-2d547c8856fb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cc4f30ab-3032-4220-ee41-2d547c8856fb@intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 26, 2018 at 11:19:19AM -0400, Dennis Dalessandro wrote:
> On 6/20/2018 12:29 PM, Dennis Dalessandro wrote:
> >From: Michael J. Ruhl <michael.j.ruhl@intel.com>
> >
> >The __get_txreq() function can return a pointer, ERR_PTR(-EBUSY),
> >or NULL.  All of the relevant call sites look for IS_ERR, so the
> >NULL return would lead to a NULL pointer exception.
> >
> >Do not use the ERR_PTR mechanism for this function.
> >
> >Update all call sites to handle the return value correctly.
> >
> >Clean up error paths to reflect return value.
> >
> >cc: <stable@vger.kernel.org> # 4.9.x+
> >Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> >Reviewed-by: Kamenee Arumugam <kamenee.arumugam@intel.com>
> >Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> >Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> 
> Fixes: 45842abbb292 ("staging/rdma/hfi1: move txreq header code")

Okay, I applied this to for-rc

Thanks,
Jason
