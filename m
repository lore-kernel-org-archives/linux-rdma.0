From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Tue, 8 Dec 2015 14:21:33 -0700
Message-ID: <20151208212133.GC14378@obsidianresearch.com>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449595982-20781-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 12:33:02PM -0500, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> In an insecure IB fabric, the default pkey in a port is 0xffff, where each
> node is allowed to talk to any other node in the fabric, including the SA
> node. However, in a secure fabric, to limit member access, not all nodes
> can have the full-member default pkey 0xffff. A typical configuration is
> to let SA node have pkey 0xffff while all other nodes have pkey 0x7fff; in
> addition, each node can be assigned some other full-member pkeys, such as
> 0x8001 and 0x8002, so that it can be assigned to different partitions.
> In this case, each node can access SA, and yet limits its other access to
> only those nodes in its assigned partitions. In such a secure fabric,
> however, ibacm will not work by interpreting "default" in its default
> address file as 0xffff.

ipoib always uses the 0 pkey index to create the default ipoib
interface. (see eg, update_parent_pkey)

When operating securely the SA should place the pkey for default ipoib
operation in pkey index 0, and place 0x7FFF in another index. I run
alot of networks exactly like this and it works very well.

This ensures that ipoib works out of the box without additional
configuration.

> +	/* Determine the default pkey index for SA access first.
> +	 *   Order of preference: 0xffff, 0x7fff, first pkey.

No, IBA says that only the default pkey should be used to talk to the
SA, every port needs 0x7FFF or the full mebership version. Do not
search for the first pkey.

> +	 * Determine the default pkey for parsing address file as well.
> +	 *   order of preference: first full-member non-management pkey,
> +	 *   0xffff, first pkey.
> +	 */

This really should just be the 0 index pkey, which exactly matches how
IPoIB determines the default pkey, which is what matters when talking
rdmacm..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
