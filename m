From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Date: Mon, 24 Jun 2019 18:06:02 +0000
Message-ID: <20190624180558.GL7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-12-leon@kernel.org>
 <20190624120338.GD5479@mellanox.com>
 <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
Content-Language: en-US
Content-ID: <CB263FBA6C9D2E498943F803633251F5@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 07:55:32PM +0300, Yishai Hadas wrote:

> > > +	/* Explicit filtering to kernel events which may occur frequently *=
/
> > > +	if (event_type =3D=3D MLX5_EVENT_TYPE_CMD ||
> > > +	    event_type =3D=3D MLX5_EVENT_TYPE_PAGE_REQUEST)
> > > +		return NOTIFY_OK;
> > > +
> > > +	table =3D container_of(nb, struct mlx5_devx_event_table, devx_nb.nb=
);
> > > +	dev =3D container_of(table, struct mlx5_ib_dev, devx_event_table);
> > > +	is_unaffiliated =3D is_unaffiliated_event(dev->mdev, event_type);
> > > +
> > > +	if (!is_unaffiliated)
> > > +		obj_type =3D get_event_obj_type(event_type, data);
> > > +	event =3D xa_load(&table->event_xa, event_type | (obj_type << 16));
> > > +	if (!event)
> > > +		return NOTIFY_DONE;
> >=20
> > event should be in the rcu as well
>=20
> Do we really need this ? I didn't see a flow that really requires
> that.

I think there are no frees left? Even so it makes much more sense to
include the event in the rcu as if we ever did need to kfree it would
have to be via rcu

> > > +	while (list_empty(&ev_queue->event_list)) {
> > > +		spin_unlock_irq(&ev_queue->lock);
> > > +
> > > +		if (filp->f_flags & O_NONBLOCK)
> > > +			return -EAGAIN;
> > > +
> > > +		if (wait_event_interruptible(ev_queue->poll_wait,
> > > +			    (!list_empty(&ev_queue->event_list) ||
> > > +			     ev_queue->is_destroyed))) {
> > > +			return -ERESTARTSYS;
> > > +		}
> > > +
> > > +		if (list_empty(&ev_queue->event_list) &&
> > > +		    ev_queue->is_destroyed)
> > > +			return -EIO;
> >=20
> > All these tests should be under the lock.
>=20
> We can't call wait_event_interruptible() above which may sleep under the
> lock, correct ? are you referring to the list_empty() and
> is_destroyed ?

yes

> By the way looking in uverb code [1], similar code which is not done unde=
r
> the lock as of here..
>=20
> [1] https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/cor=
e/uverbs_main.c#L244

Also not a good idea

> > Why don't we return EIO as soon as is-destroyed happens? What is the
> > point of flushing out the accumulated events?
>=20
> It follows the above uverb code/logic that returns existing events even i=
n
> that case, also the async command events in this file follows that logic,=
 I
> suggest to stay consistent.

Don't follow broken uverbs stuff...

> > Maybe the event should be re-added on error? Tricky.
>=20
> What will happen if another copy_to_user may then fail again (loop ?) ...
> not sure that we want to get into this tricky handling ...
>=20
> As of above, It follows the logic from uverbs at that area.
> https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uv=
erbs_main.c#L267

again it is wrong...

There is no loop if you just stick the item back on the head of the
list and exit, which is probably the right thing to do..

> > > @@ -2374,6 +2705,17 @@ static int devx_hot_unplug_async_cmd_event_fil=
e(struct ib_uobject *uobj,
> > >   static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj=
,
> > >   					    enum rdma_remove_reason why)
> > >   {
> > > +	struct devx_async_event_file *ev_file =3D
> > > +		container_of(uobj, struct devx_async_event_file,
> > > +			     uobj);
> > > +	struct devx_async_event_queue *ev_queue =3D &ev_file->ev_queue;
> > > +
> > > +	spin_lock_irq(&ev_queue->lock);
> > > +	ev_queue->is_destroyed =3D 1;
> > > +	spin_unlock_irq(&ev_queue->lock);
> > > +
> > > +	if (why =3D=3D RDMA_REMOVE_DRIVER_REMOVE)
> > > +		wake_up_interruptible(&ev_queue->poll_wait);
> >=20
> > Why isn't this wakeup always done?
>=20
> Maybe you are right and this can be always done to wake up any readers as
> the 'is_destroyed' was set.
>=20
> By the way, any idea why it was done as such in uverbs [1] for similar fl=
ow
> ? also the command events follows that.

I don't know, it is probably pointless too.

If we don't need it here then we shouldn't have it.

These random pointless ifs bother me as we have to spend time trying
to figure out that they are pointless down the road.

Jason
