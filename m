From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/8] libibverbs: Infra-structure changes to support verbs
 extension
Date: Mon, 24 Sep 2012 14:23:14 -0600
Message-ID: <20120924202314.GA9472@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7ED@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8E7ED-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 20, 2012 at 09:43:05PM +0000, Hefty, Sean wrote:
  
>  void ibv_register_driver(const char *name, ibv_driver_init_func init_func);
> +void verbs_register_driver(const char *name, ibv_driver_init_func
> init_func);

This should be using a new init_func signature.

typedef struct verbs_device *(*ibv_driver_init_func_ex)(const char *uverbs_sys_path,
	                                                int abi_version);

To document/check that calls through that path are guarenteed to
return an extended struct with the size member.

> +struct verbs_device {
> +	struct ibv_device device; /* Must be first */
> +	size_t	sz;
> +	size_t	size_of_context;
> +	int	(*init_context)(struct verbs_device *device,
> +				struct ibv_context *ctx, int cmd_fd);
> +	void	(*uninit_context)(struct verbs_device *device,
> +				struct ibv_context *ctx);
> +	/* future fields added here */
> +};

Relying on the return value of alloc_context to tell if this is a
new/old verbs_device means there is no way to tell from a ibv_device *
pointer if it is extended or not.

IMHO, it is better if the driver always returns a working legacy
alloc_context and libverbs will set it to 0 if the new verbs_register
entry point is used and verbs extension is supported. Drivers that call
into verbs_register must supply init_context.

This makes compatability with old verbs easier, and means you can
detect if the verbs_device is present based only on an 'ibv_device
*' pointer, this is more flexible going forward.

> +static inline struct verbs_device *verbs_get_device(
> +					const struct ibv_device *dev)
> +{
> +	return container_of(dev, struct verbs_device, device);
> +}

This needs to return null when an extended device is not present, see
above.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
