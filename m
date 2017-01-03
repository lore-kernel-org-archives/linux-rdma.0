From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCHv2 1/4] IB/core: add port state cache
Date: Tue, 3 Jan 2017 12:18:50 -0700
Message-ID: <20170103191850.GD26706@obsidianresearch.com>
References: <CAMGffEmYeYeRVk84GY1CWekNHF7_V4Lo4PDxoGb5wAd8-Tnn7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMGffEmYeYeRVk84GY1CWekNHF7_V4Lo4PDxoGb5wAd8-Tnn7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 02, 2017 at 01:17:36PM +0100, Jinpu Wang wrote:
> +++ b/include/rdma/ib_verbs.h
> @@ -1781,6 +1781,7 @@ struct ib_cache {
>      struct ib_pkey_cache  **pkey_cache;
>      struct ib_gid_table   **gid_cache;
>      u8                     *lmc_cache;
> +    enum ib_port_state     *port_state_cache;
>  };

I think at this point the these per-port arrays should be moved into a
struct..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
