From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/6] rdmacm: Use C11 stdatomic for all atomics
Date: Wed, 15 Mar 2017 17:18:37 -0600
Message-ID: <20170315231837.GA23082@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1489615927-12117-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <1489618538.2660.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489618538.2660.14.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 15, 2017 at 10:55:52PM +0000, Bart Van Assche wrote:
> On Wed, 2017-03-15 at 16:12 -0600, Jason Gunthorpe wrote:
> > @@ -1013,7 +1012,7 @@ int close(int socket)
> >  			return ret;
> >  	}
> >  
> > -	if (atomic_dec(&fdi->refcnt))
> > +	if (atomic_fetch_sub(&fdi->refcnt, 1))
> >  		return 0;
> >  
> >  	idm_clear(&idm, socket);
> > @@ -898,7 +898,7 @@ static int rs_create_ep(struct rsocket *rs)
> >  
> >  static void rs_release_iomap_mr(struct rs_iomap_mr *iomr)
> >  {
> > -	if (atomic_dec(&iomr->refcnt))
> > +	if (atomic_fetch_sub(&iomr->refcnt, 1))
> >  		return;
> >  
> >  	dlist_remove(&iomr->entry);
> 
> Hello Jason,
> 
> In the gcc documentation I read that __sync_sub_and_fetch() (used to
> implement atomic_dec()) returns the new value. In the C11 standard I read
> that atomic_fetch_sub() returns the old value. Do you agree with this?

Indeed, you are right, I will sqush in this patch, thanks

diff --git a/librdmacm/cma.h b/librdmacm/cma.h
index 645d1e43576279..2f5f86cf498918 100644
--- a/librdmacm/cma.h
+++ b/librdmacm/cma.h
@@ -69,12 +69,12 @@ static inline void fastlock_destroy(fastlock_t *lock)
 }
 static inline void fastlock_acquire(fastlock_t *lock)
 {
-	if (atomic_fetch_add(&lock->cnt, 1) > 1)
+	if (atomic_fetch_add(&lock->cnt, 1) > 0)
 		sem_wait(&lock->sem);
 }
 static inline void fastlock_release(fastlock_t *lock)
 {
-	if (atomic_fetch_sub(&lock->cnt, 1) > 0)
+	if (atomic_fetch_sub(&lock->cnt, 1) > 1)
 		sem_post(&lock->sem);
 }
 
diff --git a/librdmacm/preload.c b/librdmacm/preload.c
index bd1bcb1d701015..82cb0c03850b05 100644
--- a/librdmacm/preload.c
+++ b/librdmacm/preload.c
@@ -1012,7 +1012,7 @@ int close(int socket)
 			return ret;
 	}
 
-	if (atomic_fetch_sub(&fdi->refcnt, 1))
+	if (atomic_fetch_sub(&fdi->refcnt, 1) != 1)
 		return 0;
 
 	idm_clear(&idm, socket);
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 4fbe7aaa938610..9a71035fbeed8b 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -898,7 +898,7 @@ static int rs_create_ep(struct rsocket *rs)
 
 static void rs_release_iomap_mr(struct rs_iomap_mr *iomr)
 {
-	if (atomic_fetch_sub(&iomr->refcnt, 1))
+	if (atomic_fetch_sub(&iomr->refcnt, 1) != 1)
 		return;
 
 	dlist_remove(&iomr->entry);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
