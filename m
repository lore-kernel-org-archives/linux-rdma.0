From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH rdma-next 13/19] RDMA/netlink: Add netlink device
 definitions to UAPI
Date: Wed, 21 Jun 2017 10:11:49 -0600
Message-ID: <20170621161149.GB10200@obsidianresearch.com>
References: <20170621060528.3752-1-leon@kernel.org>
 <20170621060528.3752-14-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621060528.3752-14-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Chien Tin Tung <chien.tin.tung@intel.com>, Steve Wise <swise@opengridcomputing.com>, Stephen Hemminger <stephen@networkplumber.org>, Jiri Pirko <jiri@mellanox.com>, Ariel Almog <ariela@mellanox.com>, Linux Netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 21, 2017 at 09:05:22AM +0300, Leon Romanovsky wrote:
>  	RDMA_NL_IWCM,
>  	RDMA_NL_RSVD,
>  	RDMA_NL_LS,	/* RDMA Local Services */
> +	/*
> +	 * RDMA_NL_I40IW not in use and it was added here by mistake,
> +	 * but we need to keep it anyway, because it is UAPI and for
> +	 * unknown reasons, someone in the field decided to replace "5"
> +	 * with this define.
> +	 */
>  	RDMA_NL_I40IW,

Since this doesn't do anything, never did anything, I think you should
just delete it. Anything in userspace that refers to this name is
unconditionally broken and a compile failure is the better choice.

Jason
