From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] drivers: infiniband: core: Remove extra parentheses
Date: Wed, 25 Jul 2018 14:37:33 -0600
Message-ID: <20180725203733.GA5678@ziepe.ca>
References: <20180725184356.3754-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180725184356.3754-1-rvarsha016@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, Nicholas Mc Guire <der.herr@hofr.at>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 25, 2018 at 08:43:56PM +0200, Varsha Rao wrote:
> Remove unnecessary parentheses to fix the clang warning of extraneous
> parentheses.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> ---
>  drivers/infiniband/core/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Curious, what configuration are you using clang with? I'd like to have
it run here..

Jason
