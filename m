From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/hfi1: Do not warn on lid conversions for OPA
Date: Wed, 29 Nov 2017 11:43:24 -0700
Message-ID: <20171129184324.GF4011@ziepe.ca>
References: <20171129125943.31113.29038.stgit@phlsvslse11.ph.intel.com>
 <20171129125948.31113.59826.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171129125948.31113.59826.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 29, 2017 at 07:59:49AM -0500, Mike Marciniszyn wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Upstream commit 4988be5813ff2afdc0d8bfa315ef34a577d3efbf.
> 
> On OPA devices opa_local_smp_check will receive 32Bit LIDs when the LID
> is Extended. In such cases, it is okay to lose the upper 16 bits of the
> LID as this information is obtained elsewhere. Do not issue a warning
> when calling ib_lid_cpu16() in this case by masking out the upper 16Bits.

The concept for the 32 bit lids was to keep it 32 bit inside the
kernel, ingress_key_table_fail puts the lid into
err_info_constraint.slid which is already 32 bits, so this cannot be
the right place for this.

These truncations should only appear at the uapi boundary.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
