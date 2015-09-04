From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Fri, 4 Sep 2015 14:42:44 -0600
Message-ID: <20150904204244.GA20758@obsidianresearch.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
 <55E9FDA9.3090709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55E9FDA9.3090709-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 04, 2015 at 04:23:05PM -0400, Doug Ledford wrote:
> On 09/03/2015 10:56 AM, Haggai Eran wrote:
> > This series adds userspace support for on-demand paging. The first patch adds
> > support for the new extended query device verb. Patch 2 adds the capability and
> > interface bits related to on-demand paging, and patch 3 adds example code to
> > the rc_pingpong program to use on-demand paging.
> 
> I've reviewed this series and I'm OK with it.  However, it's currently
> blocked.  We need to fix the API mess that was created when the
> create/destroy flow verbs were added.  I've gone back through the code,
> and I'm pretty sure I know what Jason's objection to the create/destroy
> flow implementation was.  In particular, we weren't supposed to have this:
> 
>  struct verbs_context {
>         /*  "grows up" - new fields go here */
> +       int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
> +       int (*lib_ibv_destroy_flow) (struct ibv_flow *flow);
> +       struct ibv_flow * (*drv_ibv_create_flow) (struct ibv_qp *qp,
> +                                                 struct ibv_flow_attr
> +                                                 *flow_attr);
> +       struct ibv_flow * (*lib_ibv_create_flow) (struct ibv_qp *qp,
> +                                                 struct ibv_flow_attr
> +                                                 *flow_attr);
> 
> There was only supposed to be ibv_create_flow and ibv_destroy_flow, not
> this silly separate drv/lib versions that just amount to wasted space
> and confusion.
> 
> Our choices are: 1) Leave this in place but don't do any more extensions
> this way, knowing full well that this is wrong but preserving ABI or

We should drop the code so people don't copy it.

Replace the one that isn't used with a 'void * __compat_foo_Bar' and
if necessary have the common setup in ibverbs copy a non-null
__compat_ into lib_.

This will compile-break drivers using the wrong scheme, the driver
should be changed.

Using a new driver with a old verbs means only the flow API doesn't
work, old driver with new verbs is stil OK. Drop a dependency in the
mlx4 package. Safe breakage in an obscure scenario..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
