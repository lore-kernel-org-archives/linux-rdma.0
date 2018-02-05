From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 13:00:20 -0700
Message-ID: <20180205200020.GH11446@mellanox.com>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
 <20180201084944.GH2055@mtr-leonro.local>
 <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com>
 <20180204150553.GH27780@mtr-leonro.local>
 <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 05, 2018 at 09:33:07AM -0600, Steve Wise wrote:

> Perhaps we add a device-unique (or globally unique) identifier as part of
> the restrack struct and use that for GET/SET?

What use is an ID if the user can't associate that with something
meaningful?

For userspace, a tuple of the filehandle and existing the per-file
handle # would make some sense as a unique ID, but userspace is going
to have a pointer not necessarily the handle number :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
