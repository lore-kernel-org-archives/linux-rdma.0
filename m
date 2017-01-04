From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/core: create struct ib_port_cache
Date: Wed, 4 Jan 2017 11:36:41 -0700
Message-ID: <20170104183641.GD783@obsidianresearch.com>
References: <CAMGffEn7QsNVhDcV10Qwc-U7em3L47eOgc0CS1oRxXSFAfLGkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMGffEn7QsNVhDcV10Qwc-U7em3L47eOgc0CS1oRxXSFAfLGkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 04, 2017 at 03:01:38PM +0100, Jinpu Wang wrote:

> -struct ib_cache {
> -	rwlock_t                lock;
> -	struct ib_event_handler event_handler;
> +struct ib_port_cache {
>  	struct ib_pkey_cache  **pkey_cache;
>  	struct ib_gid_table   **gid_cache;
>  	u8                     *lmc_cache;
>  	enum ib_port_state     *port_state_cache;
>  };
>  
> +struct ib_cache {
> +	rwlock_t                lock;
> +	struct ib_event_handler event_handler;
> +	struct ib_port_cache    port_cache;
> +};

That isn't really what I ment..

struct ib_port_cache {
   enum ib_port_state port_state;
   struct ib_pkey_cache *pkey;
   struct ib_gid_table *gid;
   u8 lmc;
};

struct ib_cache {
   struct ib_port_cache *ports;
};

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
