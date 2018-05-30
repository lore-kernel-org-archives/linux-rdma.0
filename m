From: jackm <jackm@dev.mellanox.co.il>
Subject: Re: [PATCH] IB/mad: Use ID allocator routines to allocate agent
 number
Date: Wed, 30 May 2018 11:02:16 +0300
Message-ID: <20180530110216.00000913@dev.mellanox.co.il>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
        <20180529154922.GA18457@ziepe.ca>
        <A470D739-D0CD-42EE-9196-8E7610B6DAF4@oracle.com>
        <20180529164032.GB18457@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529164032.GB18457@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Doug Ledford <dledford@redhat.com>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 29 May 2018 10:40:32 -0600
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, May 29, 2018 at 06:16:14PM +0200, H=E5kon Bugge wrote:
> > =20
> > > On 29 May 2018, at 17:49, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >=20
> > > On Tue, May 29, 2018 at 09:38:08AM +0200, Hans Westgaard Ry
> > > wrote: =20
> > >> The agent TID is a 64 bit value split in two dwords.  The least
> > >> significant dword is the TID running counter. The most
> > >> significant dword is the agent number. In the CX-3 shared port
> > >> model, the mlx4 driver uses the most significant byte of the
> > >> agent number to store the slave number, making agent numbers
> > >> greater and equal to 2^24 (3 bytes) unusable. =20
> > >=20
> > > There is no reason for this to be an ida, just do something like
> > >=20
> > > mad_agent_priv->agent.hi_tid =3D
> > > atomic_inc_return(&ib_mad_client_id) &
> > > mad_agent_priv->ib_dev->tid_mask;
> > >=20
> > > And have the driver set tid_mask to 3 bytes of 0xFF =20
> >=20
> > The issue is that some of the mad agents are long-lived, so you will
> > wrap and use the same TID twice. =20
>=20
> We already have that problem, and using ida is problematic because we
> need to maximize the time between TID re-use, which ida isn't doing.
>=20
> Preventing re-use seems like a seperate issue from limiting the range
> to be compatible with mlx4.
>=20

Preventing immediate re-use can be accomplished by judicious use of the
start argument (second argument) in the call to ida_simple_get (to
introduce hysteresis into the id allocations).

For example, can do something like:

static atomic_t ib_mad_client_id_min =3D ATOMIC_INIT(1);
...
        ib_mad_client_id =3D ida_simple_get(&ib_mad_client_ids,
                                          atomic_read(&ib_mad_client_id_min=
),
                                          ib_mad_sysctl_client_id_max,
                                          GFP_KERNEL);
....
        if (!(ib_mad_client_id % 1000) ||
            ib_mad_sysctl_client_id_max - ib_mad_client_id <=3D 1000)
		atomic_set(&ib_mad_client_id_min, 1);
	else
                atomic_set(&ib_mad_client_id_min, ib_mad_client_id + 1);

The above avoids immediate re-use of ids, and only searches for past
freed ids if the last allocated-id is zero mod 1000.

This is just suggestion -- will probably need some variation of the
above to handle what happens over time (i.e., to not depend on the
modulo operation to reset the search start to 1), to properly handle
how we deal with the start value when we are close to the allowed
client_id_max, and also to implement some sort of locking.

-Jack
