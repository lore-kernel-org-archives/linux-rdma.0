From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
 multicast packet
Date: Tue, 1 May 2018 12:05:31 -0600
Message-ID: <20180501180531.GB17027@ziepe.ca>
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
 <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, Don Hiatt <don.hiatt@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 01, 2018 at 05:35:36AM -0700, Dennis Dalessandro wrote:
> @@ -719,7 +719,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
>  
>  	lrh0 |= (sc5 & 0xf) << 12 | sl << 4;
>  
> -	bth0 = pkey | (IB_OPCODE_CNP << 24);
> +	bth0 = (u32)pkey | (IB_OPCODE_CNP << 24);

What do you think this cast does??

void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
                    u32 remote_qpn, u32 pkey, u32 slid, u32 dlid,
                    u8 sc5, const struct ib_grh *old_grh)
{


Jason
