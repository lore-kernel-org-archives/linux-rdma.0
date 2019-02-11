From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH][next] RDMA/bnxt_re: fix or'ing of data into an
 uninitialized struct member
Date: Mon, 11 Feb 2019 15:35:28 -0700
Message-ID: <20190211223528.GA7770@ziepe.ca>
References: <20190211133415.9020-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211133415.9020-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 01:34:15PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The struct member comp_mask has not been initialized however a bit
> pattern is being bitwise or'd into the member and hence other bit
> fields in comp_mask may contain any garbage from the stack. Fix this
> by making the bitwise or into an assignment.
> 
> Fixes: 95b86d1c91ad ("RDMA/bnxt_re: Update kernel user abi to pass chip context")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next thanks

Jason
