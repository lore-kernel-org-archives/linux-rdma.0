From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/rxe: check for allocation failure on elem
Date: Mon, 09 Oct 2017 09:16:35 -0400
Message-ID: <1507554995.46071.25.camel@redhat.com>
References: <20170908143745.2445-1-colin.king@canonical.com>
         <20170909125607.GA22465@mtr-leonro.local>
         <20170912144829.GR3405@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170912144829.GR3405@mtr-leonro.local>
Sender: kernel-janitors-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Colin King <colin.king@canonical.com>
Cc: Moni Shoua <monis@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-12 at 17:48 +0300, Leon Romanovsky wrote:
> On Sat, Sep 09, 2017 at 03:56:07PM +0300, Leon Romanovsky wrote:
> > On Fri, Sep 08, 2017 at 03:37:45PM +0100, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > The allocation for elem may fail (especially because we're using
> > > GFP_ATOMIC) so best to check for a null return.  This fixes a
> > > potential
> > > null pointer dereference when assigning elem->pool.
> > > 
> > > Detected by CoverityScan CID#1357507 ("Dereference null return
> > > value")
> > > 
> > > Fixes: 8700e3e7c485 ("Soft RoCE driver")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > ---
> > >  drivers/infiniband/sw/rxe/rxe_pool.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c
> > > b/drivers/infiniband/sw/rxe/rxe_pool.c
> > > index c1b5f38f31a5..3b4916680018 100644
> > > --- a/drivers/infiniband/sw/rxe/rxe_pool.c
> > > +++ b/drivers/infiniband/sw/rxe/rxe_pool.c
> > > @@ -404,6 +404,8 @@ void *rxe_alloc(struct rxe_pool *pool)
> > >  	elem = kmem_cache_zalloc(pool_cache(pool),
> > >  				 (pool->flags & RXE_POOL_ATOMIC)
> > > ?
> > >  				 GFP_ATOMIC : GFP_KERNEL);
> > > +	if (!elem)
> > > +		return NULL;
> > > 
> > 
> > It is not enough to simply return NULL, you also should release
> > "pool" too.
> 
> Colin,
> do you plan to fix the comment and resend it?

Since Colin is non-responsive in this thread, I went ahead and took his
patch, but then applied a fixup of my own:

commit a79c0f939da23740c12f43019720055aade89367 (HEAD -> k.o/for-next)
Author: Doug Ledford <dledford@redhat.com>
Date:   Mon Oct 9 09:11:32 2017 -0400

    IB/rxe: put the pool on allocation failure
    
    If the allocation of elem fails, it is not sufficient to simply check
    for NULL and return.  We need to also put our reference on the pool or
    else we will leave the pool with a permanent ref count and we will never
    be able to free it.
    
    Fixes: 4831ca9e4a8e (IB/rxe: check for allocation failure on elem)
    Suggested-by: Leon Romanovsky <leon@kernel.org>
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index 3b4916680018..b4a8acc7bb7d 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -394,23 +394,25 @@ void *rxe_alloc(struct rxe_pool *pool)
 
        kref_get(&pool->rxe->ref_cnt);
 
-       if (atomic_inc_return(&pool->num_elem) > pool->max_elem) {
-               atomic_dec(&pool->num_elem);
-               rxe_dev_put(pool->rxe);
-               rxe_pool_put(pool);
-               return NULL;
-       }
+       if (atomic_inc_return(&pool->num_elem) > pool->max_elem)
+               goto out_put_pool;
 
        elem = kmem_cache_zalloc(pool_cache(pool),
                                 (pool->flags & RXE_POOL_ATOMIC) ?
                                 GFP_ATOMIC : GFP_KERNEL);
        if (!elem)
-               return NULL;
+               goto out_put_pool;
 
        elem->pool = pool;
        kref_init(&elem->ref_cnt);
 
        return elem;
+
+out_put_pool:
+       atomic_dec(&pool->num_elem);
+       rxe_dev_put(pool->rxe);
+       rxe_pool_put(pool);
+       return NULL;
 }
 
 void rxe_elem_release(struct kref *kref)


-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

