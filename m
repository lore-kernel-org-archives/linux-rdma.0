From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Mon, 12 Jun 2017 13:34:21 -0500
Message-ID: <20170612183421.GA12152@ctung-MOBL3.amr.corp.intel.com>
References: <20170611083931.13686-1-leon@kernel.org>
 <20170611083931.13686-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170611083931.13686-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 11, 2017 at 11:39:27AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> RDMA netlink has complicated infrastructure to add and remove netlink
> clients to NETLINK_RDMA family. This complicates the code and not in
> use because not many clients are available (3 clients) and most of them
> (2 clients) are statically compiled together with netlink.c.
> 
> The following patch refactors RDMA netlink and opens door for the future
> patches which will be able to get rid of a lot of dead iwcm* code.

With portmapper functionality moving from individual drivers into iw_cm,
this code can be simplified as you have done here.  There is no need for
a client list, the array will suffice.

Reviewed-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
