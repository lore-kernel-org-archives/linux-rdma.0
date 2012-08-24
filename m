From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rsockets and fork
Date: Fri, 24 Aug 2012 11:22:04 -0700
Message-ID: <CAL1RGDW+QSXnfa5yvEsb7XqXMVbVVU6sz7BEKRPmc0tSYi8m9Q@mail.gmail.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
 <502A9039.4090505@us.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
 <1344968289.2101.36.camel@oc1677441337.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com>
 <1345239625.1128.20.camel@oc1677441337.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A89F70@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237346A89F90@ORSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237346A8A7A8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8A7A8-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 22, 2012 at 4:35 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> I'm haven't identified the specific problem with fork support, but I did see this in libmlx4:
>
> mlx4_alloc_context()
> {
>         ...
>         context->uar = mmap(NULL, to_mdev(ibdev)->page_size, PROT_WRITE,
>                             MAP_SHARED, cmd_fd, 0);
>         if (context->uar == MAP_FAILED)
>                 goto err_free;
>
>         if (resp.bf_reg_size) {
>                 context->bf_page = mmap(NULL, to_mdev(ibdev)->page_size,
>                                         PROT_WRITE, MAP_SHARED, cmd_fd,
>                                         to_mdev(ibdev)->page_size);
>         ...
> }
>
> I don't know for certain that these mmap() calls cause an issue, but the preload library socket() function calls rsocket(), which loads and initializes libibverbs.  This calls mlx4_alloc_context() before fork() has been called.

I don't think those mmap()s should be an issue with fork.... they are
mapping adapter PCI space into userspace, but it should work across
fork.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
