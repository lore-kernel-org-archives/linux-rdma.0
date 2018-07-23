From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IPoIB: use kvzalloc to allocate an array of bucket
 pointers
Date: Mon, 23 Jul 2018 15:38:51 -0600
Message-ID: <20180723213851.GA22162@ziepe.ca>
References: <1531144263-24717-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531144263-24717-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Yuval Shaia <yuval.shaia@oracle.com>, Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Kees Cook <keescook@chromium.org>, Evgenii Smirnov <evgenii.smirnov@profitbricks.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 09, 2018 at 04:51:03PM +0300, Jan Dakinevich wrote:
> This table by default takes 32KiB which is 3rd memory order. Meanwhile,
> this memory is not aimed for DMA operation and could be safely allocated
> by vmalloc.
> 
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to for-next, thanks

Jason
