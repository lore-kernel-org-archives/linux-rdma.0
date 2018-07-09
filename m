From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] ib_srpt: use kvmalloc to allocate ring pointers
Date: Mon, 9 Jul 2018 16:16:39 -0600
Message-ID: <20180709221639.GA14259@ziepe.ca>
References: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc: Doug Ledford <dledford@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 09, 2018 at 04:51:08PM +0300, Jan Dakinevich wrote:
> An array of pointers to SRPT contexts in ib_device is over 30KiB even
> in default case, in which an amount of contexts is 4095. The patch
> is intended to weed out large contigous allocation for non-DMA memory.
> 
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied to for-next

Thanks,
Jason
