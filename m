From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Date: Tue, 25 Jun 2019 20:23:24 +0000
Message-ID: <20190625202320.GJ3607@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-12-leon@kernel.org>
 <20190624120338.GD5479@mellanox.com>
 <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
 <20190624180558.GL7418@mellanox.com>
 <a2380ea6-4542-c72c-96f7-e68786847ccc@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <a2380ea6-4542-c72c-96f7-e68786847ccc@dev.mellanox.co.il>
Content-Language: en-US
Content-ID: <40E9C00191753E49BCF30A92BCDAD487@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 25, 2019 at 05:41:49PM +0300, Yishai Hadas wrote:
> > > > Why don't we return EIO as soon as is-destroyed happens? What is th=
e
> > > > point of flushing out the accumulated events?
> > >=20
> > > It follows the above uverb code/logic that returns existing events ev=
en in
> > > that case, also the async command events in this file follows that lo=
gic, I
> > > suggest to stay consistent.
> >=20
> > Don't follow broken uverbs stuff...
>=20
> May it be that there is some event that we still want to deliver post
> unbind/hot-unplug ? for example IB_EVENT_DEVICE_FATAL in uverbs and other=
s
> from the driver code.

EIO is DEVICE_FATAL.

> Not sure that we want to change this logic.
> What do you think ?

I think this code should exit immediately with EIO if the device is
disassociated.

> > > > Maybe the event should be re-added on error? Tricky.
> > >=20
> > > What will happen if another copy_to_user may then fail again (loop ?)=
 ...
> > > not sure that we want to get into this tricky handling ...
> > >=20
> > > As of above, It follows the logic from uverbs at that area.
> > > https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/cor=
e/uverbs_main.c#L267
> >=20
> > again it is wrong...
> >=20
> > There is no loop if you just stick the item back on the head of the
> > list and exit, which is probably the right thing to do..
> >=20
>=20
> What if copy_to_user() will fail again just later on ? we might end-up wi=
th
> loop of read(s) that always find an event as it was put back.

That is clearly an application bug and is not the concern of the
kernel..

> I suggest to leave this flow as it's now, at least for this series
> submission.
>=20
> Agree ?

I don't think you can actually fix this, so maybe we have to leave
it. But add a comment explaining=20

Jason
