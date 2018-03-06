From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: remove redundant assignment to pointer 'rdi'
Date: Tue, 6 Mar 2018 16:34:19 -0700
Message-ID: <20180306233419.GA8328@ziepe.ca>
References: <20180301162354.17420-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180301162354.17420-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 01, 2018 at 04:23:54PM +0000, Colin Ian King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer rdi is being initialized with a value that is never read
> and re-assigned immediately after, hence the initialization is redundant
> and can be removed.
> 
> Cleans up clang warning:
> drivers/infiniband/sw/rdmavt/vt.c:94:23: warning: Value stored to 'rdi'
> during its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>  drivers/infiniband/sw/rdmavt/vt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to for-next, thanks

Jason
