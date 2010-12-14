From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 6/6] RDMA CM: Netlink Client
Date: Tue, 14 Dec 2010 11:45:14 -0700
Message-ID: <20101214184514.GE2506@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
 <1292257370-24391-7-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1292257370-24391-7-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 13, 2010 at 06:22:50PM +0200, Nir Muchtar wrote:
> +			if (ibnl_put_attr(skb, nlh,
> +					  sizeof id->route.addr.src_addr,
> +					  &id->route.addr.src_addr,
> +					  IBNL_RDMA_CM_ATTR_SRC_ADDR)) {
> +				goto out;
> +			}

The sizeof the attribute should be sizeof(sockaddr_in) or
sizeof(sockaddr_in6), not sizeof(sockaddr_storage).

Other rdma_cm code uses this sort of construct:

        memcpy(&resp.src_addr, addr, addr->sa_family == AF_INET ?
                                     sizeof(struct sockaddr_in) :
                                     sizeof(struct sockaddr_in6));

But I can't belive there isn't a kernel function for the length of 
a sockaddr...

> +struct rdma_cm_id_stats {
> +	u8 nt;
> +	u8 port_num;
> +	u32 bound_dev_if;
> +	u32 ps;
> +	u8 cm_state;
> +	u32 qp_num;
> +	pid_t pid;
> +};

Careful of alignment issues and and type issues:

struct rdma_cm_id_stats {
  u32 bound_dev_if;
  u32 resereved_for_ib_bound_dev_ib;
  u32 port_space;
  u32 creator_pid;
  u8 nt;  // Use a better name
  u8 port_num;
  u8 cm_state;
  u8 reserved;
};

Rather than pid I think it is better to include enough information to
cross reference the RDMA_CM fd aginst /proc/../fd. Ie to get the pid(s)
you trundle through proc looking for that signature. Isn't that what
ss does?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
