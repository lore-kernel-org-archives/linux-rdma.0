From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/ucm: fix UCM link error
Date: Tue, 21 Aug 2018 21:18:13 -0600
Message-ID: <20180822031813.GA1313@ziepe.ca>
References: <20180821142100.2250647-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180821142100.2250647-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 21, 2018 at 04:20:44PM +0200, Arnd Bergmann wrote:
> Building UCM with CONFIG_INFINIBAND_USER_ACCESS=m results in a
> set of link errors including:
> 
> drivers/infiniband/core/ucm.o: In function `ib_ucm_event_handler':
> ucm.c:(.text+0x6dc): undefined reference to `ib_copy_path_rec_to_user'
> drivers/infiniband/core/ucma.o: In function `ucma_event_handler':
> ucma.c:(.text+0xdc0): undefined reference to `ib_copy_ah_attr_to_user'
> 
> To get it to build-test again, this makes the option itself a
> tristate, which lets Kconfig figure out the dependency correctly.
> 
> Fixes: 486edfb1039d ("IB/ucm: Fix compiling ucm.c")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/infiniband/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-rc

But that fixes line isn't right is it?

Should it be

commit 7a8690ed6f5346f6738971892205e91d39b6b901
Author: Leon Romanovsky <leonro@mellanox.com>
Date:   Wed May 23 08:22:11 2018 +0300

    RDMA/ucm: Mark UCM interface as BROKEN

Which added the config in the first place??

Thanks,
Jason

> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 1d6f5710d1df..176b943dfec9 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -35,7 +35,7 @@ config INFINIBAND_USER_ACCESS
>  	  rdma-core <https://github.com/linux-rdma/rdma-core>.
>  
>  config INFINIBAND_USER_ACCESS_UCM
> -	bool "Userspace CM (UCM, DEPRECATED)"
> +	tristate "Userspace CM (UCM, DEPRECATED)"
>  	depends on BROKEN || COMPILE_TEST
>  	depends on INFINIBAND_USER_ACCESS
>  	help
