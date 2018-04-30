From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 3/5] ib_srpt: depend on INFINIBAND_ADDR_TRANS
Date: Mon, 30 Apr 2018 17:35:00 -0600
Message-ID: <20180430233500.GI26909@ziepe.ca>
References: <20180425223340.206907-1-gthelen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180425223340.206907-1-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Thelen <gthelen@google.com>
Cc: Doug Ledford <dledford@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 25, 2018 at 03:33:39PM -0700, Greg Thelen wrote:
> INFINIBAND_SRPT code depends on INFINIBAND_ADDR_TRANS provided symbols.
> So declare the kconfig dependency.  This is necessary to allow for
> enabling INFINIBAND without INFINIBAND_ADDR_TRANS.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Cc: Tarick Bedeir <tarick@google.com>
>  drivers/infiniband/ulp/srpt/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/Kconfig b/drivers/infiniband/ulp/srpt/Kconfig
> index 31ee83d528d9..fb8b7182f05e 100644
> +++ b/drivers/infiniband/ulp/srpt/Kconfig
> @@ -1,6 +1,6 @@
>  config INFINIBAND_SRPT
>  	tristate "InfiniBand SCSI RDMA Protocol target support"
> -	depends on INFINIBAND && TARGET_CORE
> +	depends on INFINIBAND && INFINIBAND_ADDR_TRANS && TARGET_CORE

Isn't INFINIBAND && INFINIBAND_ADDR_TRANS a bit redundant? Can't have
INFINIBAND_ADDR_TRANS without INFINIBAND.

Jason
