From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Potential NULL pointer dereference in drivers/infiniband/core
Date: Tue, 21 Feb 2017 18:52:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0E99BB@ORSMSX109.amr.corp.intel.com>
References: <003d01d28c09$46d1e200$d475a600$@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003d01d28c09$46d1e200$d475a600$@cs.utah.edu>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaobo <shaobo-sDh8Nw2yj/+Vc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve,

Can you look at the iWarp code flow described below?

> My name is Shaobo He and I am a graduate student at University of Utah.
> I am applying a static analysis tool to the Linux device drivers and
> got an error trace of null pointer dereference in
> drivers/infiniband/core starting from function `ucma_accept`: it calls
> `rdma_accept` with the second argument being NULL. In `rdma_accept`,
> `cma_accept_iw` is called with the second argument also being NULL.
> Then in `cma_accept_iw`, `cma_modify_qp_rtr` can return 0 if `id_priv-
> >id.qp` is NULL, which can be suggested by an if statement in
> `rdma_accept`. Finally, the second argument `conn_param` of
> `cma_accept_iw` gets dereferenced. As you can see, the error trace is
> only plausible since it depends on certain conditions. Therefore, I was
> wondering if you could confirm it.

Based on a quick look, this looks like it's at least a problem in how conn_param is verified.  IB allows conn_param to be optional, whereas iWarp requires it.  Since this is coming from user space, we can crash.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
