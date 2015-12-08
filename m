From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 07/37] IB/rdmavt: Add query and modify port stubs
Date: Tue, 8 Dec 2015 10:06:11 +0200
Message-ID: <20151208080611.GH7313@leon.nu>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204327.8144.17959.stgit@phlsvslse11.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151207204327.8144.17959.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 07, 2015 at 03:43:28PM -0500, Dennis Dalessandro wrote:
> +/**
> + * rvt_query_port: Passes the query port call to the driver
> + * ibdev: Verbs IB dev
> + * port: port number
> + * props: structure to hold returned properties
> + *
> + * Returns 0 on success
> + */
...

> +/**
> + * rvt_modify_port
> + * @ibdev: Verbs IB dev
> + * @port: Port number
> + * @port_modify_mask: How to change the port
> + * @props: Structure to fill in
> + *
> + * Returns 0 on success
> + */

The comments are different in their format: one start from @ for
variables and another without @.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
