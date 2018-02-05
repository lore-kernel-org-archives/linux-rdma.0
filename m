From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 16:16:37 -0600
Message-ID: <026c01d39ece$fd9cf550$f8d6dff0$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <20180201084944.GH2055@mtr-leonro.local> <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com> <20180204150553.GH27780@mtr-leonro.local> <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com> <20180205200020.GH11446@mellanox.com> <026201d39ebf$d1f087a0$75d196e0$@opengridcomputing.com> <20180205203608.GJ11446@mellanox.com> <026a01d39ec3$5cc48270$164d8750$@opengridcomputing.com> <20180205211618.GL11446@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205211618.GL11446-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, Feb 05, 2018 at 02:53:23PM -0600, Steve Wise wrote:
> 
> > Even if we create a device-unique ID for each restrack object, to make
it
> > useful to for userspace analysis would require exposing that ID in the
> > various user object structures (or via query methods).   EG having
> > pd->res_id, cq->res_id, etc...
> 
> As I said, we have that, it is the fd, handle # tuple and most verbs
> objects expose the handle # in the user visible part of the object
> struct..

Can you please show me an example of the handle # for some object like PD or
CQ?  This doesn't address kernel users' object, though, correct?

Thanks,

Steve.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
