From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/3] RDMA_CM: Netlink Callbacks
Date: Mon, 15 Nov 2010 08:10:19 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B85920B0@orsmsx501.amr.corp.intel.com>
References: <4CE00A85.8060402@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE00A85.8060402-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org" <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm sure there will be more discussion on the general approach, but some comments on a few implementation details below.

> +EXPORT_SYMBOL(cma_get_stats_size);

All other exported calls use the prefix 'rdma_cm'.  Same comment for cma_get_stats

> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index 4fae903..a3cd1c7 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -133,6 +133,28 @@ struct rdma_cm_id {
>  	u8			 port_num;
>  };
> 
> +struct rdma_cm_id_stats {
> +	enum rdma_node_type nt;
> +	int port_num;
> +	int bound_dev_if;
> +	struct sockaddr local_addr;
> +	struct sockaddr remote_addr;

need to use sockaddr_storage

> +	enum rdma_port_space ps;
> +	int cma_state;

The enum cma_state should probably be moved from cma.c to a header file if it will be accessed external to the rdma_cm.

> +	int qp_num;

u32 or be32?

> +	pid_t pid;
> +};

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
