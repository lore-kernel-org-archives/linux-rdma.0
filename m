From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock held
Date: Wed, 10 Aug 2016 01:51:52 -0400
Message-ID: <20160810055151.GB32695@phlsvsds.ph.intel.com>
References: <1470755786-14054-1-git-send-email-ira.weiny@intel.com> <20160809181146.GE23921@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160809181146.GE23921@leon.nu>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 09, 2016 at 09:11:46PM +0300, Leon Romanovsky wrote:
> On Tue, Aug 09, 2016 at 11:16:26AM -0400, ira.weiny@intel.com wrote:
> > From: Mike Marciniszyn <mike.marciniszyn@intel.com>
> > 

[snip]

> > diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
> > index dbab9d9cc288..c35bef8dd5aa 100644
> > --- a/drivers/infiniband/hw/hfi1/debugfs.c
> > +++ b/drivers/infiniband/hw/hfi1/debugfs.c
> > @@ -223,28 +223,35 @@ DEBUGFS_SEQ_FILE_OPEN(ctx_stats)
> >  DEBUGFS_FILE_OPS(ctx_stats);
> >  
> >  static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
> > -__acquires(RCU)
> > +	__acquires(RCU)
> >  {
> >  	struct qp_iter *iter;
> >  	loff_t n = *pos;
> >  
> > -	rcu_read_lock();
> >  	iter = qp_iter_init(s->private);
> > +
> > +	/* stop calls rcu_read_unlock */
> > +	rcu_read_lock();
> 
> IMHO, it should be placed after your if(!iter) check below.

I know this seems weird but this makes the rcu locking "balanced".  Returning
NULL here still calls "stop" which is going to call rcu_read_unlock.  If we
move rcu_read_lock we need to maintain state to determine if we called lock or
not.  This is easier.  To me it does seem odd that the sequence operation does
not stop on its own when NULL is returned but that is the way it works.

> 
> > +
> >  	if (!iter)
> >  		return NULL;
> >  
> > -	while (n--) {
> > +	if (qp_iter_next(iter)) {
> > +		kfree(iter);
> > +		return NULL;
> > +	}
> > +	while (n--)
> >  		if (qp_iter_next(iter)) {
> >  			kfree(iter);
> >  			return NULL;
> >  		}
> 
> It looks like you forgot to remove the lines above.

Nope this replaces a call to qp_iter_next which was in qp_iter_init.

As the commit messages says we move the implict next's back into the respective
start functions.

Ira

> 
> > -	}
> >  
> >  	return iter;
> >  }
> >  
> >  static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
> >  				loff_t *pos)
> > +	__must_hold(RCU)
> >  {
> >  	struct qp_iter *iter = iter_ptr;
> >  
> > @@ -259,7 +266,7 @@ static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
> >  }
> >  
> >  static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
> > -__releases(RCU)
> > +	__releases(RCU)
> >  {
> >  	rcu_read_unlock();
> >  }
> > diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
> > index a5aa3517e7d5..4e4d8317c281 100644
> > --- a/drivers/infiniband/hw/hfi1/qp.c
> > +++ b/drivers/infiniband/hw/hfi1/qp.c
> > @@ -656,10 +656,6 @@ struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev)
> >  
> >  	iter->dev = dev;
> >  	iter->specials = dev->rdi.ibdev.phys_port_cnt * 2;
> > -	if (qp_iter_next(iter)) {
> > -		kfree(iter);
> > -		return NULL;
> > -	}
> >  
> >  	return iter;
> >  }
> > diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
> > index 5e75b43c596b..07059c08c170 100644
> > --- a/drivers/infiniband/hw/qib/qib_debugfs.c
> > +++ b/drivers/infiniband/hw/qib/qib_debugfs.c
> > @@ -189,27 +189,34 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
> >  DEBUGFS_FILE(ctx_stats)
> >  
> >  static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
> > +	__acquires(RCU)
> >  {
> >  	struct qib_qp_iter *iter;
> >  	loff_t n = *pos;
> >  
> > -	rcu_read_lock();
> >  	iter = qib_qp_iter_init(s->private);
> > +
> > +	/* stop calls rcu_read_unlock */
> > +	rcu_read_lock();
> > +
> 
> The same
> 
> >  	if (!iter)
> >  		return NULL;
> >  
> > -	while (n--) {
> > +	if (qib_qp_iter_next(iter)) {
> > +		kfree(iter);
> > +		return NULL;
> > +	}
> > +	while (n--)
> >  		if (qib_qp_iter_next(iter)) {
> >  			kfree(iter);
> >  			return NULL;
> >  		}
> > -	}
> > -
> 
> The same
> 
> >  	return iter;
> >  }
> >  
> >  static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
> >  				   loff_t *pos)
> > +	__must_hold(RCU)
> >  {
> >  	struct qib_qp_iter *iter = iter_ptr;
> >  
> > @@ -224,6 +231,7 @@ static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
> >  }
> >  
> >  static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
> > +	__releases(RCU)
> >  {
> >  	rcu_read_unlock();
> >  }
> > diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
> > index 9cc0aae1d781..f9b8cd2354d1 100644
> > --- a/drivers/infiniband/hw/qib/qib_qp.c
> > +++ b/drivers/infiniband/hw/qib/qib_qp.c
> > @@ -573,10 +573,6 @@ struct qib_qp_iter *qib_qp_iter_init(struct qib_ibdev *dev)
> >  		return NULL;
> >  
> >  	iter->dev = dev;
> > -	if (qib_qp_iter_next(iter)) {
> > -		kfree(iter);
> > -		return NULL;
> > -	}
> >  
> >  	return iter;
> >  }
> > -- 
> > 1.8.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
