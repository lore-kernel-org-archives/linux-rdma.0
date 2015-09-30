From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband:Remove unneeded function definitions and
 declarations in the file, mad.c
Date: Wed, 30 Sep 2015 06:00:38 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CBA25A8@CRSMSX101.amr.corp.intel.com>
References: <1443575136-14181-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443575136-14181-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> This removes the definitions and declarations of the functions
> ib_register_mad_snoop and register_snoop_agent in the file mad.c due to have
> no more callers and thus can be removed to reduce code size of this particular
> file.

I don't disagree with removing the snoop code, however, I don't believe this goes far enough.  I have a similar patch which removes the snoop interface completely.  It has a medium level of testing.

I'll send it to the list for review.  If you concur with the larger removal, I'd be happy to add your signed-off by line.

Thanks,
Ira

> 
> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c | 98 -------------------------------------------
>  1 file changed, 98 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 4b5c723..e5978e1 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -444,104 +444,6 @@ static inline int is_snooping_recvs(int
> mad_snoop_flags)
>  		 IB_MAD_SNOOP_RMPP_RECVS*/));
>  }
> 
> -static int register_snoop_agent(struct ib_mad_qp_info *qp_info,
> -				struct ib_mad_snoop_private
> *mad_snoop_priv)
> -{
> -	struct ib_mad_snoop_private **new_snoop_table;
> -	unsigned long flags;
> -	int i;
> -
> -	spin_lock_irqsave(&qp_info->snoop_lock, flags);
> -	/* Check for empty slot in array. */
> -	for (i = 0; i < qp_info->snoop_table_size; i++)
> -		if (!qp_info->snoop_table[i])
> -			break;
> -
> -	if (i == qp_info->snoop_table_size) {
> -		/* Grow table. */
> -		new_snoop_table = krealloc(qp_info->snoop_table,
> -					   sizeof mad_snoop_priv *
> -					   (qp_info->snoop_table_size + 1),
> -					   GFP_ATOMIC);
> -		if (!new_snoop_table) {
> -			i = -ENOMEM;
> -			goto out;
> -		}
> -
> -		qp_info->snoop_table = new_snoop_table;
> -		qp_info->snoop_table_size++;
> -	}
> -	qp_info->snoop_table[i] = mad_snoop_priv;
> -	atomic_inc(&qp_info->snoop_count);
> -out:
> -	spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
> -	return i;
> -}
> -
> -struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
> -					   u8 port_num,
> -					   enum ib_qp_type qp_type,
> -					   int mad_snoop_flags,
> -					   ib_mad_snoop_handler
> snoop_handler,
> -					   ib_mad_recv_handler recv_handler,
> -					   void *context)
> -{
> -	struct ib_mad_port_private *port_priv;
> -	struct ib_mad_agent *ret;
> -	struct ib_mad_snoop_private *mad_snoop_priv;
> -	int qpn;
> -
> -	/* Validate parameters */
> -	if ((is_snooping_sends(mad_snoop_flags) && !snoop_handler) ||
> -	    (is_snooping_recvs(mad_snoop_flags) && !recv_handler)) {
> -		ret = ERR_PTR(-EINVAL);
> -		goto error1;
> -	}
> -	qpn = get_spl_qp_index(qp_type);
> -	if (qpn == -1) {
> -		ret = ERR_PTR(-EINVAL);
> -		goto error1;
> -	}
> -	port_priv = ib_get_mad_port(device, port_num);
> -	if (!port_priv) {
> -		ret = ERR_PTR(-ENODEV);
> -		goto error1;
> -	}
> -	/* Allocate structures */
> -	mad_snoop_priv = kzalloc(sizeof *mad_snoop_priv, GFP_KERNEL);
> -	if (!mad_snoop_priv) {
> -		ret = ERR_PTR(-ENOMEM);
> -		goto error1;
> -	}
> -
> -	/* Now, fill in the various structures */
> -	mad_snoop_priv->qp_info = &port_priv->qp_info[qpn];
> -	mad_snoop_priv->agent.device = device;
> -	mad_snoop_priv->agent.recv_handler = recv_handler;
> -	mad_snoop_priv->agent.snoop_handler = snoop_handler;
> -	mad_snoop_priv->agent.context = context;
> -	mad_snoop_priv->agent.qp = port_priv->qp_info[qpn].qp;
> -	mad_snoop_priv->agent.port_num = port_num;
> -	mad_snoop_priv->mad_snoop_flags = mad_snoop_flags;
> -	init_completion(&mad_snoop_priv->comp);
> -	mad_snoop_priv->snoop_index = register_snoop_agent(
> -						&port_priv->qp_info[qpn],
> -						mad_snoop_priv);
> -	if (mad_snoop_priv->snoop_index < 0) {
> -		ret = ERR_PTR(mad_snoop_priv->snoop_index);
> -		goto error2;
> -	}
> -
> -	atomic_set(&mad_snoop_priv->refcount, 1);
> -	return &mad_snoop_priv->agent;
> -
> -error2:
> -	kfree(mad_snoop_priv);
> -error1:
> -	return ret;
> -}
> -EXPORT_SYMBOL(ib_register_mad_snoop);
> -
>  static inline void deref_mad_agent(struct ib_mad_agent_private
> *mad_agent_priv)  {
>  	if (atomic_dec_and_test(&mad_agent_priv->refcount))
> --
> 2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
