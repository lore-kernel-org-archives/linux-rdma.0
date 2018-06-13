From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 1/2] IDR: Expose the XArray lock
Date: Wed, 13 Jun 2018 11:30:57 -0600
Message-ID: <20180613173057.GA27281@ziepe.ca>
References: <20180613123403.25233-1-willy@infradead.org>
 <20180613123403.25233-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613123403.25233-2-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 13, 2018 at 05:34:02AM -0700, Matthew Wilcox wrote:
> Allow users of the IDR to use the XArray lock for their own
> synchronisation purposes.  The IDR continues to rely on the caller to
> handle locking, but this lets the caller use the lock embedded in the
> IDR data structure instead of allocating their own lock.
> 
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
>  include/linux/idr.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/idr.h b/include/linux/idr.h
> index e856f4e0ab35..109d7a3c8d56 100644
> +++ b/include/linux/idr.h
> @@ -98,6 +98,17 @@ static inline void idr_set_cursor(struct idr *idr, unsigned int val)
>   * period).
>   */
>  
> +#define idr_lock(idr)		xa_lock(&(idr)->idr_xa)
> +#define idr_unlock(idr)		xa_unlock(&(idr)->idr_xa)
> +#define idr_lock_bh(idr)	xa_lock_bh(&(idr)->idr_xa)
> +#define idr_unlock_bh(idr)	xa_unlock_bh(&(idr)->idr_xa)
> +#define idr_lock_irq(idr)	xa_lock_irq(&(idr)->idr_xa)
> +#define idr_unlock_irq(idr)	xa_unlock_irq(&(idr)->idr_xa)
> +#define idr_lock_irqsave(idr, flags) \
> +				xa_lock_irqsave(&(idr)->idr_xa, flags)
> +#define idr_unlock_irqrestore(idr, flags) \
> +				xa_unlock_irqrestore(&(idr)->idr_xa, flags)
> +
>  void idr_preload(gfp_t gfp_mask);

Hmm, what do I need to apply this?

drivers/infiniband/core/mad.c: In function ‘ib_register_mad_agent’:
drivers/infiniband/core/mad.c:387:34: error: ‘struct idr’ has no member named ‘idr_xa’; did you mean ‘idr_rt’?
  idr_lock(&ib_mad_clients);
                                  ^     
                                  idr_rt

Linus's master (be779f03d563981)  doesn't seem to have idr_xa?

Jason
