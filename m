From: Knut Omang <knut.omang@oracle.com>
Subject: Re: [PATCH v2 4/5] rds: Add runchecks.cfg for net/rds
Date: Sun, 17 Dec 2017 02:57:22 +0100
Message-ID: <1513475842.31439.91.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <4dc9b2fc0ddd1eb91d9b8785ae4886c6b08f3ee5.1513430008.git-series.knut.omang@oracle.com>
         <20171216094525.5e9c985c@xeon-e3> <1513448673.4647.45.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513448673.4647.45.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-12-16 at 10:24 -0800, Joe Perches wrote:
> On Sat, 2017-12-16 at 09:45 -0800, Stephen Hemminger wrote:
> > On Sat, 16 Dec 2017 15:42:29 +0100 Knut Omang <knut.omang@oracle.com> wrote:
> > > +# Code simplification:
> > > +#
> > > +except ALLOC_WITH_MULTIPLY ib.c
> > > +except PREFER_PR_LEVEL ib_cm.c ib_recv.c ib_send.c rdma_transport.c threads.c
> transport.c
> > > +except UNNECESSARY_ELSE ib_fmr.c
> > > +except UNNECESSARY_PARENTHESES ib_rdma.c rdma.c recv.c send.c
> > > +except PRINTK_RATELIMITED ib_frmr.c
> > > +except EMBEDDED_FUNCTION_NAME ib_rdma.c
> > > +
> > > +# Style and readability:
> > > +#
> > > +except BRACES ib_cm.c ib_rdma.c ib_recv.c send.c transport.c
> > > +except OOM_MESSAGE ib.c tcp.c
> > > +except LONG_LINE_STRING ib.c ib_recv.c ib_send.c
> > > +except FUNCTION_ARGUMENTS ib.h ib_mr.h rds.h tcp.h
> > > +except OPEN_ENDED_LINE recv.c ib_recv.c
> > > +
> > > +# Candidates to leave as exceptions (don't fix):
> > > +except MULTIPLE_ASSIGNMENTS ib_send.c
> > > +except LONG_LINE_STRING connection.c
> > > +except OPEN_BRACE connection.c
> > > +
> > 
> > Why start letting subsystems have a free-pass?
> > Also this would mean that new patches to IB would continue the bad habits.
> 
> I agree with this comment at least for net/rds.
> 
> Most of these existing messages from checkpatch should
> probably be inspected and corrected where possible to
> minimize the style differences between this subsystem
> and the rest of the kernel.

Please get me right here, I want us to fix all or at least most the issues, unless there
are very good reasons for keeping some. But to fix a problem, partitioning it into easy
manageable and distributable pieces can often be a good idea. It also allows us to focus
on the most important or easiest issues first - my comments here are intended as
examples/guidance/classification.

> For instance, here's a trivial patch to substitute
> pr_<level> for printks and a couple braces next to
> these substitutions.

yes - I have about 10 such patches for RDMA and 10 for RDS 
fixing various issues "queued up" here - done while I worked on the logic:

https://github.com/knuto/linux/tree/runchecks

I just felt that mixing them up with the runchecks functionality itself would be wrong,
but wanted to throw in these two configuration files to give you some example of how it
can be used.

Thanks,
Knut

> btw:
> 
> in ib_cm, why is one call to ib_modify_qp emitted
> with a -ret and the other with a positive err?


> 
> ---
>  net/rds/ib_cm.c          | 21 ++++++++++-----------
>  net/rds/ib_recv.c        |  5 ++---
>  net/rds/ib_send.c        | 23 ++++++++++++-----------
>  net/rds/rdma_transport.c | 14 +++++++-------
>  net/rds/send.c           |  8 ++++----
>  net/rds/tcp_send.c       |  4 +---
>  net/rds/threads.c        |  6 ++----
>  net/rds/transport.c      | 12 ++++++------
>  8 files changed, 44 insertions(+), 49 deletions(-)
> 
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 80fb6f63e768..92694c9cb7c9 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -86,7 +86,7 @@ rds_ib_tune_rnr(struct rds_ib_connection *ic, struct ib_qp_attr *attr)
>  	attr->min_rnr_timer = IB_RNR_TIMER_000_32;
>  	ret = ib_modify_qp(ic->i_cm_id->qp, attr, IB_QP_MIN_RNR_TIMER);
>  	if (ret)
> -		printk(KERN_NOTICE "ib_modify_qp(IB_QP_MIN_RNR_TIMER): err=%d\n",
> -ret);
> +		pr_notice("ib_modify_qp(IB_QP_MIN_RNR_TIMER): err=%d\n", -ret);
>  }
>  
>  /*
> @@ -146,13 +146,12 @@ void rds_ib_cm_connect_complete(struct rds_connection *conn,
> struct rdma_cm_even
>  	qp_attr.qp_state = IB_QPS_RTS;
>  	err = ib_modify_qp(ic->i_cm_id->qp, &qp_attr, IB_QP_STATE);
>  	if (err)
> -		printk(KERN_NOTICE "ib_modify_qp(IB_QP_STATE, RTS): err=%d\n", err);
> +		pr_notice("ib_modify_qp(IB_QP_STATE, RTS): err=%d\n", err);
>  
>  	/* update ib_device with this local ipaddr */
>  	err = rds_ib_update_ipaddr(ic->rds_ibdev, conn->c_laddr);
>  	if (err)
> -		printk(KERN_ERR "rds_ib_update_ipaddr failed (%d)\n",
> -			err);
> +		pr_err("rds_ib_update_ipaddr failed (%d)\n", err);
>  
>  	/* If the peer gave us the last packet it saw, process this as if
>  	 * we had received a regular ACK. */
> @@ -594,8 +593,7 @@ static u32 rds_ib_protocol_compatible(struct rdma_cm_event *event)
>  
>  	/* Be paranoid. RDS always has privdata */
>  	if (!event->param.conn.private_data_len) {
> -		printk(KERN_NOTICE "RDS incoming connection has no private data, "
> -			"rejecting\n");
> +		pr_notice("RDS incoming connection has no private data, rejecting\n");
>  		return 0;
>  	}
>  
> @@ -609,11 +607,12 @@ static u32 rds_ib_protocol_compatible(struct rdma_cm_event *event)
>  		version = RDS_PROTOCOL_3_0;
>  		while ((common >>= 1) != 0)
>  			version++;
> -	} else
> -		printk_ratelimited(KERN_NOTICE "RDS: Connection from %pI4 using
> incompatible protocol version %u.%u\n",
> -				&dp->dp_saddr,
> -				dp->dp_protocol_major,
> -				dp->dp_protocol_minor);
> +	} else {
> +		pr_notice_ratelimited("RDS: Connection from %pI4 using incompatible
> protocol version %u.%u\n",
> +				      &dp->dp_saddr,
> +				      dp->dp_protocol_major,
> +				      dp->dp_protocol_minor);
> +	}
>  	return version;
>  }
>  
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index b4e421aa9727..9dfc8233c488 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -105,7 +105,7 @@ static int rds_ib_recv_alloc_cache(struct rds_ib_refill_cache
> *cache)
>  
>  	cache->percpu = alloc_percpu(struct rds_ib_cache_head);
>  	if (!cache->percpu)
> -	       return -ENOMEM;
> +		return -ENOMEM;
>  
>  	for_each_possible_cpu(cpu) {
>  		head = per_cpu_ptr(cache->percpu, cpu);
> @@ -399,8 +399,7 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill,
> gfp_t gfp)
>  	while ((prefill || rds_conn_up(conn)) &&
>  	       rds_ib_ring_alloc(&ic->i_recv_ring, 1, &pos)) {
>  		if (pos >= ic->i_recv_ring.w_nr) {
> -			printk(KERN_NOTICE "Argh - ring alloc returned pos=%u\n",
> -					pos);
> +			pr_notice("Argh - ring alloc returned pos=%u\n", pos);
>  			break;
>  		}
>  
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index 8557a1cae041..cb1ce8d06582 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -180,9 +180,8 @@ static struct rds_message *rds_ib_send_unmap_op(struct
> rds_ib_connection *ic,
>  		}
>  		break;
>  	default:
> -		printk_ratelimited(KERN_NOTICE
> -			       "RDS/IB: %s: unexpected opcode 0x%x in WR!\n",
> -			       __func__, send->s_wr.opcode);
> +		pr_notice_ratelimited("RDS/IB: %s: unexpected opcode 0x%x in WR!\n",
> +				      __func__, send->s_wr.opcode);
>  		break;
>  	}
>  
> @@ -730,8 +729,8 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
>  		 first, &first->s_wr, ret, failed_wr);
>  	BUG_ON(failed_wr != &first->s_wr);
>  	if (ret) {
> -		printk(KERN_WARNING "RDS/IB: ib_post_send to %pI4 "
> -		       "returned %d\n", &conn->c_faddr, ret);
> +		pr_warn("RDS/IB: ib_post_send to %pI4 returned %d\n",
> +			&conn->c_faddr, ret);
>  		rds_ib_ring_unalloc(&ic->i_send_ring, work_alloc);
>  		rds_ib_sub_signaled(ic, nr_sig);
>  		if (prev->s_op) {
> @@ -827,15 +826,16 @@ int rds_ib_xmit_atomic(struct rds_connection *conn, struct
> rm_atomic_op *op)
>  		 send, &send->s_atomic_wr, ret, failed_wr);
>  	BUG_ON(failed_wr != &send->s_atomic_wr.wr);
>  	if (ret) {
> -		printk(KERN_WARNING "RDS/IB: atomic ib_post_send to %pI4 "
> -		       "returned %d\n", &conn->c_faddr, ret);
> +		pr_warn("RDS/IB: atomic ib_post_send to %pI4 returned %d\n",
> +			&conn->c_faddr, ret);
>  		rds_ib_ring_unalloc(&ic->i_send_ring, work_alloc);
>  		rds_ib_sub_signaled(ic, nr_sig);
>  		goto out;
>  	}
>  
>  	if (unlikely(failed_wr != &send->s_atomic_wr.wr)) {
> -		printk(KERN_WARNING "RDS/IB: atomic ib_post_send() rc=%d, but
> failed_wqe updated!\n", ret);
> +		pr_warn("RDS/IB: atomic ib_post_send() rc=%d, but failed_wqe
> updated!\n",
> +			ret);
>  		BUG_ON(failed_wr != &send->s_atomic_wr.wr);
>  	}
>  
> @@ -967,15 +967,16 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, struct
> rm_rdma_op *op)
>  		 first, &first->s_rdma_wr.wr, ret, failed_wr);
>  	BUG_ON(failed_wr != &first->s_rdma_wr.wr);
>  	if (ret) {
> -		printk(KERN_WARNING "RDS/IB: rdma ib_post_send to %pI4 "
> -		       "returned %d\n", &conn->c_faddr, ret);
> +		pr_warn("RDS/IB: rdma ib_post_send to %pI4 returned %d\n",
> +			&conn->c_faddr, ret);
>  		rds_ib_ring_unalloc(&ic->i_send_ring, work_alloc);
>  		rds_ib_sub_signaled(ic, nr_sig);
>  		goto out;
>  	}
>  
>  	if (unlikely(failed_wr != &first->s_rdma_wr.wr)) {
> -		printk(KERN_WARNING "RDS/IB: ib_post_send() rc=%d, but failed_wqe
> updated!\n", ret);
> +		pr_warn("RDS/IB: ib_post_send() rc=%d, but failed_wqe updated!\n",
> +			ret);
>  		BUG_ON(failed_wr != &first->s_rdma_wr.wr);
>  	}
>  
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index fc59821f0a27..0ccb1cde4c52 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -131,7 +131,7 @@ int rds_rdma_cm_event_handler(struct rdma_cm_id *cm_id,
>  
>  	default:
>  		/* things like device disconnect? */
> -		printk(KERN_ERR "RDS: unknown event %u (%s)!\n",
> +		pr_err("RDS: unknown event %u (%s)!\n",
>  		       event->event, rdma_event_msg(event->event));
>  		break;
>  	}
> @@ -156,8 +156,8 @@ static int rds_rdma_listen_init(void)
>  			       RDMA_PS_TCP, IB_QPT_RC);
>  	if (IS_ERR(cm_id)) {
>  		ret = PTR_ERR(cm_id);
> -		printk(KERN_ERR "RDS/RDMA: failed to setup listener, "
> -		       "rdma_create_id() returned %d\n", ret);
> +		pr_err("RDS/RDMA: failed to setup listener, rdma_create_id() returned
> %d\n",
> +		       ret);
>  		return ret;
>  	}
>  
> @@ -171,15 +171,15 @@ static int rds_rdma_listen_init(void)
>  	 */
>  	ret = rdma_bind_addr(cm_id, (struct sockaddr *)&sin);
>  	if (ret) {
> -		printk(KERN_ERR "RDS/RDMA: failed to setup listener, "
> -		       "rdma_bind_addr() returned %d\n", ret);
> +		pr_err("RDS/RDMA: failed to setup listener, rdma_bind_addr() returned
> %d\n",
> +		       ret);
>  		goto out;
>  	}
>  
>  	ret = rdma_listen(cm_id, 128);
>  	if (ret) {
> -		printk(KERN_ERR "RDS/RDMA: failed to setup listener, "
> -		       "rdma_listen() returned %d\n", ret);
> +		pr_err("RDS/RDMA: failed to setup listener, rdma_listen() returned
> %d\n",
> +		       ret);
>  		goto out;
>  	}
>  
> diff --git a/net/rds/send.c b/net/rds/send.c
> index b52cdc8ae428..f9bc3d499576 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1130,15 +1130,15 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t
> payload_len)
>  	}
>  
>  	if (rm->rdma.op_active && !conn->c_trans->xmit_rdma) {
> -		printk_ratelimited(KERN_NOTICE "rdma_op %p conn xmit_rdma %p\n",
> -			       &rm->rdma, conn->c_trans->xmit_rdma);
> +		pr_notice_ratelimited("rdma_op %p conn xmit_rdma %p\n",
> +				      &rm->rdma, conn->c_trans->xmit_rdma);
>  		ret = -EOPNOTSUPP;
>  		goto out;
>  	}
>  
>  	if (rm->atomic.op_active && !conn->c_trans->xmit_atomic) {
> -		printk_ratelimited(KERN_NOTICE "atomic_op %p conn xmit_atomic %p\n",
> -			       &rm->atomic, conn->c_trans->xmit_atomic);
> +		pr_notice_ratelimited("atomic_op %p conn xmit_atomic %p\n",
> +				      &rm->atomic, conn->c_trans->xmit_atomic);
>  		ret = -EOPNOTSUPP;
>  		goto out;
>  	}
> diff --git a/net/rds/tcp_send.c b/net/rds/tcp_send.c
> index dc860d1bb608..0e23e9d06c7e 100644
> --- a/net/rds/tcp_send.c
> +++ b/net/rds/tcp_send.c
> @@ -153,9 +153,7 @@ int rds_tcp_xmit(struct rds_connection *conn, struct rds_message
> *rm,
>  			 * an incoming RST.
>  			 */
>  			if (rds_conn_path_up(cp)) {
> -				pr_warn("RDS/tcp: send to %pI4 on cp [%d]"
> -					"returned %d, "
> -					"disconnecting and reconnecting\n",
> +				pr_warn("RDS/tcp: send to %pI4 on cp [%d]returned %d,
> disconnecting and reconnecting\n",
>  					&conn->c_faddr, cp->cp_index, ret);
>  				rds_conn_path_drop(cp, false);
>  			}
> diff --git a/net/rds/threads.c b/net/rds/threads.c
> index f121daa402c8..499a0a8287cc 100644
> --- a/net/rds/threads.c
> +++ b/net/rds/threads.c
> @@ -74,10 +74,8 @@ EXPORT_SYMBOL_GPL(rds_wq);
>  void rds_connect_path_complete(struct rds_conn_path *cp, int curr)
>  {
>  	if (!rds_conn_path_transition(cp, curr, RDS_CONN_UP)) {
> -		printk(KERN_WARNING "%s: Cannot transition to state UP, "
> -				"current state is %d\n",
> -				__func__,
> -				atomic_read(&cp->cp_state));
> +		pr_warn("%s: Cannot transition to state UP, current state is %d\n",
> +			__func__, atomic_read(&cp->cp_state));
>  		rds_conn_path_drop(cp, false);
>  		return;
>  	}
> diff --git a/net/rds/transport.c b/net/rds/transport.c
> index 0b188dd0a344..a0d7ccecdec3 100644
> --- a/net/rds/transport.c
> +++ b/net/rds/transport.c
> @@ -46,12 +46,12 @@ void rds_trans_register(struct rds_transport *trans)
>  
>  	down_write(&rds_trans_sem);
>  
> -	if (transports[trans->t_type])
> -		printk(KERN_ERR "RDS Transport type %d already registered\n",
> -			trans->t_type);
> -	else {
> +	if (transports[trans->t_type]) {
> +		pr_err("RDS Transport type %d already registered\n",
> +		       trans->t_type);
> +	} else {
>  		transports[trans->t_type] = trans;
> -		printk(KERN_INFO "Registered RDS/%s transport\n", trans->t_name);
> +		pr_info("Registered RDS/%s transport\n", trans->t_name);
>  	}
>  
>  	up_write(&rds_trans_sem);
> @@ -63,7 +63,7 @@ void rds_trans_unregister(struct rds_transport *trans)
>  	down_write(&rds_trans_sem);
>  
>  	transports[trans->t_type] = NULL;
> -	printk(KERN_INFO "Unregistered RDS/%s transport\n", trans->t_name);
> +	pr_info("Unregistered RDS/%s transport\n", trans->t_name);
>  
>  	up_write(&rds_trans_sem);
>  }
> 
