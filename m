From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 11 Jan 2018 12:55:35 -0700
Message-ID: <20180111195535.GI30208@mellanox.com>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-2-leon@kernel.org>
 <1515700046.2752.52.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515700046.2752.52.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 07:47:27PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> > +struct rdma_restrack_entry {
> > +       struct list_head        list;
> > +
> > +       /*
> > +        * The entries are filled during rdma_restrack_add,
> > +        * can be attempted to be free during rdma_restrack_del.
> > +        *
> > +        * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
> > +        */
> > +       bool                    valid;
> > +
> > +       /*
> > +        * Sleepabale RCU to protect object data.
> > +        */
> > +       struct srcu_struct      srcu;
> > +
> > +       struct task_struct      *task;
> > +       char                    *task_comm;
> > +};
> 
> Please use the kernel-doc syntax to document the meaning of the names of the
> fields in this structure. It is e.g. nontrivial to guess what "task_comm" stands
> for. The presense of a task_struct pointer is also nontrivial.

And task_comm doesn't seem like a great name anymore, and should be
const char *, right ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
