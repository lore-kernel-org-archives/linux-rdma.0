From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/2] IB/mad: Agent registration is process context only
Date: Tue, 12 Jun 2018 14:38:28 -0600
Message-ID: <20180612203828.GH6314@ziepe.ca>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180608174218.32455-2-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 08, 2018 at 10:42:17AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Document this (it's implicitly true due to sleeping operations already
> in use in both registration and deregistration).  Use this fact to use
> spin_lock_irq instead of spin_lock_irqsave.  This improves performance
> slightly.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  drivers/infiniband/core/mad.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

In the mean time, this patch is straightfoward, applied to the interm
for-next..

Jason
