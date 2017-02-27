From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH] IB/qib: fix false-postive maybe-uninitialized warning
Date: Mon, 27 Feb 2017 21:22:45 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67C59B29@CRSMSX101.amr.corp.intel.com>
References: <20170227204343.3575126-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170227204343.3575126-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, infinipath <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Leon Romanovsky <leon@kernel.org>, "Chegondi, Harish" <harish.chegondi@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, "John, Jubin" <jubin.john@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 
> aarch64-linux-gcc-7 complains about code it doesn't fully understand:
> 
> drivers/infiniband/hw/qib/qib_iba7322.c: In function
> 'qib_7322_txchk_change':
> include/asm-generic/bitops/non-atomic.h:105:35: error: 'shadow' may be used
> uninitialized in this function [-Werror=maybe-uninitialized]
> 
> The code is right, and despite trying hard, I could not come up with a version
> that I liked better than just adding a fake initialization here to shut up the
> warning.
> 
> Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand
> adapters")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Sounds reasonable to me.

Acked-by: Ira Weiny <ira.weiny@intel.com>

>  drivers/infiniband/hw/qib/qib_iba7322.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c
> b/drivers/infiniband/hw/qib/qib_iba7322.c
> index 12c4208fd701..af9f596bb68b 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7322.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7322.c
> @@ -7068,7 +7068,7 @@ static void qib_7322_txchk_change(struct
> qib_devdata *dd, u32 start,
>  	unsigned long flags;
> 
>  	while (wait) {
> -		unsigned long shadow;
> +		unsigned long shadow = 0;
>  		int cstart, previ = -1;
> 
>  		/*
> --
> 2.9.0
