From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 1/6] IB Netlink Infrastructure
Date: Tue, 14 Dec 2010 11:34:01 -0700
Message-ID: <20101214183401.GC2506@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
 <1292257370-24391-2-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1292257370-24391-2-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 13, 2010 at 06:22:45PM +0200, Nir Muchtar wrote:

> +int ibnl_add_client(int index, int nops,
> +		    int (*cb_table[])(struct sk_buff *skb,
> +				      struct netlink_callback *nlcb))

If you are going this way, then I think it would be better to have
netlink_dump_start be optional - not many calls need it.

ibnl_add_client(const struct ibnl_desc *desc);

struct inl_op
{
  int (*dump_start)(sk_buff *skb,struct netlink_callback *nlcb);
  int (*get)(...);
};
struct ibnl_desc
{
   int index;
   int ops;
   const struct ibnl_op *ops;
};

Or something.

In any event cb_table[] needs to be const.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
