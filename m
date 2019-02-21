From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/hfi1: Add missing break in switch statement
Date: Thu, 21 Feb 2019 14:09:02 -0700
Message-ID: <20190221210902.GA25062@ziepe.ca>
References: <20190221010233.GA29228@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190221010233.GA29228@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kaike Wan <kaike.wan@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 20, 2019 at 07:02:33PM -0600, Gustavo A. R. Silva wrote:
> Fix the following warning by adding a missing break:
> 
> drivers/infiniband/hw/hfi1/tid_rdma.c: In function ‘hfi1_tid_rdma_wqe_interlock’:
> drivers/infiniband/hw/hfi1/tid_rdma.c:3251:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    switch (prev->wr.opcode) {
>    ^~~~~~
> drivers/infiniband/hw/hfi1/tid_rdma.c:3259:2: note: here
>   case IB_WR_RDMA_READ:
>   ^~~~
> 
> Warning level 3 was used: -Wimplicit-fallthrough=3
> 
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
> 
> Fixes: c6c231175ccd ("IB/hfi1: Add interlock between TID RDMA WRITE and other requests")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Kaike Wan <Kaike.wan@intel.com>
> --
>  drivers/infiniband/hw/hfi1/tid_rdma.c | 1 +
>  1 file changed, 1 insertion(+)

Applied to for-next, thanks

Jason
