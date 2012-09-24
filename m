From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/8] libibverbs: Infra-structure changes to support
 verbs extension
Date: Mon, 24 Sep 2012 20:39:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8F003@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7ED@ORSMSX101.amr.corp.intel.com>
 <20120924202314.GA9472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120924202314.GA9472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'll let Yishai and Tzahi respond in more detail, but see below.

> >  void ibv_register_driver(const char *name, ibv_driver_init_func init_func);
> > +void verbs_register_driver(const char *name, ibv_driver_init_func
> > init_func);
> 
> This should be using a new init_func signature.
> 
> typedef struct verbs_device *(*ibv_driver_init_func_ex)(const char
> *uverbs_sys_path,
> 	                                                int abi_version);
> 
> To document/check that calls through that path are guarenteed to
> return an extended struct with the size member.
> 
> > +struct verbs_device {
> > +	struct ibv_device device; /* Must be first */
> > +	size_t	sz;
> > +	size_t	size_of_context;
> > +	int	(*init_context)(struct verbs_device *device,
> > +				struct ibv_context *ctx, int cmd_fd);
> > +	void	(*uninit_context)(struct verbs_device *device,
> > +				struct ibv_context *ctx);
> > +	/* future fields added here */
> > +};
> 
> Relying on the return value of alloc_context to tell if this is a
> new/old verbs_device means there is no way to tell from a ibv_device *
> pointer if it is extended or not.
> 
> IMHO, it is better if the driver always returns a working legacy
> alloc_context and libverbs will set it to 0 if the new verbs_register
> entry point is used and verbs extension is supported. Drivers that call
> into verbs_register must supply init_context.
> 
> This makes compatability with old verbs easier, and means you can
> detect if the verbs_device is present based only on an 'ibv_device
> *' pointer, this is more flexible going forward.

ibverbs could always export an extended device through a compatibility layer, similar to what I added in patch 2.

> 
> > +static inline struct verbs_device *verbs_get_device(
> > +					const struct ibv_device *dev)
> > +{
> > +	return container_of(dev, struct verbs_device, device);
> > +}
> 
> This needs to return null when an extended device is not present, see
> above.

I don't think we even need to expose this function at this point.  It's only used internally.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
