From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/ucma: Use struct_size() helper
Date: Fri, 7 Jun 2019 15:05:08 -0300
Message-ID: <20190607180508.GA29136@ziepe.ca>
References: <20190604154222.GA8938@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190604154222.GA8938@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 04, 2019 at 10:42:22AM -0500, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace the following form:
> 
> sizeof(*resp) + (i * sizeof(struct ib_path_rec_data))
> 
> with:
> 
> struct_size(resp, path_data, i)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/infiniband/core/ucma.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to for-next, thanks

Jason
