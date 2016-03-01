From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/core: Support accessing SA in
 virtualized environment
Date: Tue, 1 Mar 2016 10:44:01 -0700
Message-ID: <20160301174401.GC25176@obsidianresearch.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
 <1456851143-138332-4-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456851143-138332-4-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 06:52:16PM +0200, Eli Cohen wrote:
> Per the ongoing standardisation process, when virtual HCAs are present
> in a network, traffic is routed based on a destination GID. In order to
> access the SA we use the well known SA GID.

Should we be merging patches based on on-going standards work?

> +		ah_attr.ah_flags = IB_AH_GRH;
> +		ah_attr.grh.dgid.global.subnet_prefix = cpu_to_be64(IB_SA_WELL_KNOWN_GID_PREFIX);
> +		ah_attr.grh.dgid.global.interface_id = cpu_to_be64(IB_SA_WELL_KNOWN_GUID);

I'm surprised this hard wired to fe80::2 - surely this should use
the current subnet prefix? There should be no traffic prefixed with
fe80:: if a subnet is configured with another prefix.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
