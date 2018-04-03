From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/ocrdma_hw: Remove redundant checks and goto labels
Date: Tue, 3 Apr 2018 13:37:50 -0600
Message-ID: <20180403193750.GA24735@ziepe.ca>
References: <20180330153858.GA14385@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180330153858.GA14385@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 30, 2018 at 10:38:58AM -0500, Gustavo A. R. Silva wrote:
> Check on return values and goto label mbx_err are unnecessary.
> 
> Addresses-Coverity-ID: 1271151 ("Identical code for different branches")
> Addresses-Coverity-ID: 1268788 ("Identical code for different branches")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)

Applied to for-next, thanks

Jason
