From: Steve Wise <larrystevenwise@gmail.com>
Subject: Re: [PATCH v2 iproute2-next 3/4] rdma: add 'link add/delete' commands
Date: Tue, 2 Apr 2019 09:33:35 -0500
Message-ID: <CADmRdJdkMm3DU5hMKyHswiv4UvDUxXKgu=eOwp7Fm_cf6tJogw@mail.gmail.com>
References: <cover.1553627811.git.larrystevenwise@gmail.com>
 <a1b4b7640efb89346c45db060e88bb66103b4f50.1553627811.git.larrystevenwise@gmail.com>
 <20190401063755.GG8348@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190401063755.GG8348@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 1, 2019 at 1:37 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Mar 26, 2019 at 02:18:29PM -0500, Steve Wise wrote:
> > Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
> > device to a netdev interface.
> >
> > EG:
> >
> > rdma link add rxe_eth0 type rxe netdev eth0
> > rdma link delete rxe_eth0
> >
> > Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
> > ---
> >  rdma/link.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  rdma/rdma.h |  2 ++
> >  2 files changed, 85 insertions(+)
> >
> > diff --git a/rdma/link.c b/rdma/link.c
> > index 89e81b84..982c2b16 100644
> > --- a/rdma/link.c
> > +++ b/rdma/link.c
> > @@ -9,6 +9,9 @@
> >  static int link_help(struct rd *rd)
> >  {
> >       pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
> > +     pr_out("Usage: %s link add NAME type TYPE netdev NETDEV\n",
> > +            rd->filename);
> > +     pr_out("Usage: %s link delete NAME\n", rd->filename);
> >       return 0;
> >  }
> >
> > @@ -336,10 +339,90 @@ static int link_show(struct rd *rd)
> >       return rd_exec_link(rd, link_one_show, true);
> >  }
> >
> > +static int link_add_netdev(struct rd *rd)
> > +{
> > +     rd->link_netdev = rd_argv(rd);
> > +     rd_arg_inc(rd);
> > +     return 0;
> > +}
> > +
> > +static int link_add_type(struct rd *rd)
> > +{
> > +     const struct rd_cmd cmds[] = {
> > +             { NULL,         link_help},
> > +             { "netdev",     link_add_netdev},
> > +             { 0 }
> > +     };
> > +     rd->link_type = rd_argv(rd);
> > +     rd_arg_inc(rd);
> > +     return rd_exec_cmd(rd, cmds, "parameter");
> > +}
> > +
> > +static int link_add(struct rd *rd)
> > +{
> > +     const struct rd_cmd cmds[] = {
> > +             { NULL,         link_help},
> > +             { "type",       link_add_type},
> > +             { 0 }
> > +     };
> > +
> > +     uint32_t seq;
> > +     char *name;
> > +     int ret;
> > +
> > +     if (rd_no_arg(rd)) {
> > +             pr_err("Please provide a link name to add.\n");
> > +             return -EINVAL;
> > +     }
> > +     name = rd_argv(rd);
> > +     rd_arg_inc(rd);
> > +
> > +     ret = rd_exec_cmd(rd, cmds, "parameter");
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!rd->link_type) {
> > +             pr_err("Please provide a link type name.\n");
> > +             return -EINVAL;
> > +     }
> > +     if (!rd->link_netdev) {
> > +             pr_err("Please provide a net device name.\n");
> > +             return -EINVAL;
> > +     }
>
> After a little bit more thinking, the checks above are supposed to be
> part of rd_exec_cmd() execution of chains. E.g if (!rd->link_type) needs
> to be inside link_add_type().
>

Ok.  I'll respin and add your reviewed-by tags.

Thanks,
Steve
