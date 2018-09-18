From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/4] IB: decrease large contigous allocation
Date: Tue, 18 Sep 2018 08:46:23 -0600
Message-ID: <20180918144623.GI11367@ziepe.ca>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 18, 2018 at 04:03:42PM +0300, Jan Dakinevich wrote:
> The size of mlx4_ib_device became too large to be allocated as whole contigous 
> block of memory. Currently it takes about 55K. On architecture with 4K page it 
> means 3rd order.
> 
> This patch series makes an attempt to split mlx4_ib_device into several parts 
> and allocate them with less expensive kvzalloc

Why split it up? Any reason not to just allocate the whole thing with
kvzalloc?

Jason
