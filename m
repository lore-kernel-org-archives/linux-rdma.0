From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/5] IB: Query port through the core instead of
 directly calling the driver handler
Date: Wed, 25 Jan 2017 16:29:55 +0200
Message-ID: <CAJ3xEMjfxPs85OQP2v2MvYzU9ajUELs7_3r0nA-=TTa-tp-hSQ@mail.gmail.com>
References: <20170119054102.20135-1-leon@kernel.org> <20170119054102.20135-6-leon@kernel.org>
 <20170124205938.GA5524@ssaleem-MOBL4.amr.corp.intel.com> <20170125123920.GO6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170125123920.GO6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 25, 2017 at 2:39 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Tue, Jan 24, 2017 at 02:59:38PM -0600, Shiraz Saleem wrote:
>
>
> > > --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
> > > +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
> > > @@ -499,6 +499,7 @@ static int set_guid_rec(struct ib_device *ibdev,
> > >     struct list_head *head =
> > >             &dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
> > >
> > > +   memset(&attr, 0, sizeof(struct ib_port_attr));
> > >     err = __mlx4_ib_query_port(ibdev, port, &attr, 1);
> >
> > So why not call ib_query_port here as opposed to driver handler? As stated in your subject line.
>
> This is call to mlx4 internal implementation of ib_query_port. This
> implementation takes an additional parameter. In this case it is "1",
> while call to ib_query_port will call to this function with "0".

The mlx4 IB driver is used all of native, SRIOV PF and SRIOV VF instances.

Under SRIOV, the port has network view and host view. This internal query port
call (and the other one you commented on) is done in a network view by the PF.

The calls that come from the IB core are done with host view.

As such I had to retain these two internal calls.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
