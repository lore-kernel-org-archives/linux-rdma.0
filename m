From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] infiniband: remove unneeded header search paths
Date: Thu, 24 Jan 2019 21:27:52 -0800
Message-ID: <8563eb16-0740-536e-3c35-2ebcff76ba71@acm.org>
References: <1548391171-6407-1-git-send-email-yamada.masahiro@socionext.com>
 <1548391171-6407-2-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548391171-6407-2-git-send-email-yamada.masahiro@socionext.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 1/24/19 8:39 PM, Masahiro Yamada wrote:
> The included headers are located in include/target/. I was able to
> build these drivers without the extra header search paths.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
>   drivers/infiniband/ulp/isert/Makefile | 1 -
>   drivers/infiniband/ulp/srpt/Makefile  | 1 -
>   2 files changed, 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/isert/Makefile b/drivers/infiniband/ulp/isert/Makefile
> index c8bf242..a4a4766 100644
> --- a/drivers/infiniband/ulp/isert/Makefile
> +++ b/drivers/infiniband/ulp/isert/Makefile
> @@ -1,2 +1 @@
> -ccflags-y		:= -Idrivers/target -Idrivers/target/iscsi
>   obj-$(CONFIG_INFINIBAND_ISERT)	+= ib_isert.o
> diff --git a/drivers/infiniband/ulp/srpt/Makefile b/drivers/infiniband/ulp/srpt/Makefile
> index e3ee4bd..43fbde4 100644
> --- a/drivers/infiniband/ulp/srpt/Makefile
> +++ b/drivers/infiniband/ulp/srpt/Makefile
> @@ -1,2 +1 @@
> -ccflags-y			:= -Idrivers/target
>   obj-$(CONFIG_INFINIBAND_SRPT)	+= ib_srpt.o

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
