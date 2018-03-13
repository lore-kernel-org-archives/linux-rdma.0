From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH] 40iw: include linux/irq.h
Date: Tue, 13 Mar 2018 08:20:00 -0500
Message-ID: <20180313132000.GA18400@ssaleem-MOBL4.amr.corp.intel.com>
References: <20180313120644.2619889-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180313120644.2619889-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Artemy Kovalyov <artemyko@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 13, 2018 at 01:06:20PM +0100, Arnd Bergmann wrote:
> We get a build failure on ARM unless the header is included explicitly:
> 
> drivers/infiniband/hw/i40iw/i40iw_verbs.c: In function 'i40iw_get_vector_affinity':
> drivers/infiniband/hw/i40iw/i40iw_verbs.c:2747:9: error: implicit declaration of function 'irq_get_affinity_mask'; did you mean 'irq_create_affinity_masks'? [-Werror=implicit-function-declaration]
>   return irq_get_affinity_mask(msix_vec->irq);
>          ^~~~~~~~~~~~~~~~~~~~~
>          irq_create_affinity_masks
> drivers/infiniband/hw/i40iw/i40iw_verbs.c:2747:9: error: returning 'int' from a function with return type 'const struct cpumask *' makes pointer from integer without a cast [-Werror=int-conversion]
>   return irq_get_affinity_mask(msix_vec->irq);
> 
> Fixes: 7e952b19eb63 ("i40iw: Implement get_vector_affinity API")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks like you beat me to it. 0-day caught this on rdma-nxt and I was going to send the fix today. 

Typo in the subject. 40iw --> i40iw. Othwerwise, looks good.

Thanks for the patch, Arnd!

Shiraz
