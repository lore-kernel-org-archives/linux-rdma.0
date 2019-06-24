From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 10/12] IB/mlx5: Enable subscription for
 device events over DEVX
Date: Mon, 24 Jun 2019 17:56:12 +0000
Message-ID: <20190624175609.GK7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-11-leon@kernel.org>
 <20190624115726.GC5479@mellanox.com>
 <33f9402b-ccae-b874-cc72-b6afb1fb8655@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <33f9402b-ccae-b874-cc72-b6afb1fb8655@dev.mellanox.co.il>
Content-Language: en-US
Content-ID: <E27C16DE2FED5648B7E727DBD1377AB0@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 07:13:14PM +0300, Yishai Hadas wrote:
> > > +	u32 xa_key_level1;
> > > +	u32 xa_key_level2;
> > > +	struct rcu_head	rcu;
> > > +	u64 cookie;
> > > +	bool is_obj_related;
> > > +	struct ib_uobject *fd_uobj;
> > > +	void *object;	/* May need direct access upon hot unplug */
> >=20
> > This should be a 'struct file *' and have a better name.
> >=20
>=20
> OK, will change.
>=20
> > And I'm unclear why we need to store both the ib_uobject and the
> > struct file for the same thing?
>=20
> Post hot unplug/unbind the uobj can't be accessed any more to reach the
> object as it will be set to NULL by ib_core layer [1].

struct file users need to get the uobject from the file->private_data
under a fget.

There is only place place that needed fd_uobj, and it was under the
fget section, so it should simply use private_data.

This is why you should only store the struct file and not the uobject.

> This was the comment that I have just put above in the code, I may improv=
e
> it with more details as pointed here.
>=20
> [1]
> https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/rd=
ma_core.c#L149

I'm wondering if this is a bug to do this for fds?

> > Since uobj->object =3D=3D flip && filp->private_data =3D=3D uobj, I hav=
e a
> > hard time to understand why we need both things, it seems to me that
> > if we get the fget on the filp then we can rely on the
> > filp->private_data to get back to the devx_async_event_file.
> >=20
>=20
> The idea was to not take an extra ref count on the file (i.e. fget) per
> subscription, this will let the release option to be called once the file
> will be closed by the application.

No extra ref is needed, the fget is already obtained in the only place
that needs fd_uobj.

> > > +	obj_event =3D xa_load(&event->object_ids, key_level2);
> > > +	if (!obj_event) {
> > > +		err =3D xa_reserve(&event->object_ids, key_level2, GFP_KERNEL);
> > > +		if (err)
> > > +			goto err_level1;
> > > +
> > > +		obj_event =3D kzalloc(sizeof(*obj_event), GFP_KERNEL);
> > > +		if (!obj_event) {
> > > +			err =3D -ENOMEM;
> > > +			goto err_level2;
> > > +		}
> > > +
> > > +		INIT_LIST_HEAD(&obj_event->obj_sub_list);
> > > +		*alloc_obj_event =3D obj_event;
> >=20
> > This is goofy, just store the empty obj_event in the xa instead of
> > using xa_reserve, and when you go to do the error unwind just delete
> > any level2' devx_obj_event' that has a list_empty(obj_sub_list), get
> > rid of the wonky alloc_obj_event stuff.
> >=20
>=20
> Please see my answer above about how level2 is managed by this
> alloc_obj_event, is that really worth a change ? I found current logic to=
 be
> clear. I may put some note here if we can stay with that.

I think it is alot cleaner/simpler than using this extra memory

> > The best configuration would be to use devx_cleanup_subscription to
> > undo the partially ready subscription.
>=20
> This partially ready subscription might not match the
> devx_cleanup_subscription(), e.g. it wasn't added to xa_list and can't be
> deleted without any specific flag to ignore ..

Maybe, but I suspect it can work out

> > > +	event_sub_arr =3D uverbs_zalloc(attrs,
> > > +		MAX_NUM_EVENTS * sizeof(struct devx_event_subscription *));
> > > +	event_obj_array_alloc =3D uverbs_zalloc(attrs,
> > > +		MAX_NUM_EVENTS * sizeof(struct devx_obj_event *));
> >=20
> > There are so many list_heads in the devx_event_subscription, why not
> > use just one of them to store the allocated events instead of this
> > temp array? ie event_list looks good for this purpose.
> >=20
>=20
> I'm using the array later on with direct access to the index that should =
be
> de-allocated. I would prefer staying with this array rather than using th=
e
> 'event_list' which has other purpose down the road, it's used per
> subscription and doesn't look match to hold the devx_obj_event which has =
no
> list entry for this purpose..

Replace the event_obj_array_alloc by storing that data directly in
the xarray

Replace the event_sub_arr by building them into a linked list - it
always need to iterate over the whole list anyhow.

> > > +
> > > +	if (!event_sub_arr || !event_obj_array_alloc)
> > > +		return -ENOMEM;
> > > +
> > > +	/* Protect from concurrent subscriptions to same XA entries to allo=
w
> > > +	 * both to succeed
> > > +	 */
> > > +	mutex_lock(&devx_event_table->event_xa_lock);
> > > +	for (i =3D 0; i < num_events; i++) {
> > > +		u32 key_level1;
> > > +
> > > +		if (obj)
> > > +			obj_type =3D get_dec_obj_type(obj,
> > > +						    event_type_num_list[i]);
> > > +		key_level1 =3D event_type_num_list[i] | obj_type << 16;
> > > +
> > > +		err =3D subscribe_event_xa_alloc(devx_event_table,
> > > +					       key_level1,
> > > +					       obj ? true : false,
> > > +					       obj_id,
> > > +					       &event_obj_array_alloc[i]);
> >=20
> > Usless ?:
>=20
> What do you suggest instead ?

Nothing is needed, cast to implicit bool is always forced to
true/false

Jason
