From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] IB/mad: Use ID allocator routines to allocate agent
 number
Date: Wed, 30 May 2018 22:07:16 +0200
Message-ID: <E67F0098-C2BC-49F6-AC55-3F9195712D4B@oracle.com>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180529154922.GA18457@ziepe.ca>
 <A470D739-D0CD-42EE-9196-8E7610B6DAF4@oracle.com>
 <20180529164032.GB18457@ziepe.ca>
 <20180530110216.00000913@dev.mellanox.co.il>
 <d8b75416-6a01-aa64-cd60-0cb4f2b6d0d5@oracle.com>
 <20180530151023.GB30754@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530151023.GB30754@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, jackm <jackm@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org



> On 30 May 2018, at 17:10, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Wed, May 30, 2018 at 02:22:56PM +0200, Hans Westgaard Ry wrote:
>=20
>> We came up with this code snippet which we think handles both =
preventing
>> immediate re-use and too big/wrapping...
>=20
> Isn't this basically the same as idr_alloc_cyclic ?

I draw my statement back. The idr_alloc_cyclic() is the family of idr's =
that associates a pointer with the bit. Hence, each bit is a bit + 64b.

That's why we ended up with Hans' pseudo code.


Thxs, H=C3=A5kon


>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
