From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH v2] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Thu, 13 Jun 2019 19:39:24 +0200
Message-ID: <1D8E6B14-3336-42B3-B572-596DD2183D89@oracle.com>
References: <20190226075722.1692315-1-haakon.bugge@oracle.com>
 <174ccd37a9ffa05d0c7c03fe80ff7170a9270824.camel@redhat.com>
 <67B4F337-4C3A-4193-B1EF-42FD4765CBB7@oracle.com>
 <20190613172355.GF22901@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190613172355.GF22901@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 13 Jun 2019, at 19:23, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Thu, Jun 13, 2019 at 06:58:30PM +0200, H=C3=A5kon Bugge wrote:
>=20
>> If you refer to the backlog parameter in rdma_listen(), I cannot see
>> it being used at all for IB.
>>=20
>> For CX-3, which is paravirtualized wrt. MAD packets, it is the proxy
>> UD receive queue length for the PF driver that can be construed as a
>> backlog.=20
>=20
> No, in IB you can drop UD packets if your RQ is full - so the proxy RQ
> is really part of the overall RQ on QP1.
>=20
> The backlog starts once packets are taken off the RQ and begin the
> connection accept processing.

Do think we say the same thing. If, incoming REQ processing is severly =
delayed, the backlog is #entries in the QP1 receive queue in the PF. I =
can call rdma_listen() with a backlog of a zillion, but it will not =
help.

>> Customer configures #VMs and different workload may lead to way
>> different number of CM connections. The proxying of MAD packet
>> through the PF driver has a finite packet rate. With 64 VMs, 10.000
>> QPs on each, all going down due to a switch failing or similar, you
>> have 640.000 DREQs to be sent, and with the finite packet rate of MA
>> packets through the PF, this takes more than the current CM
>> timeout. And then you re-transmit and increase the burden of the PF
>> proxying.
>=20
> I feel like the performance of all this proxying is too low to support
> such a large work load :(

That is what I am aiming at, for example to spread the =
completion_vector(s) for said QPs ;-)

-h

>=20
> Can it be improved?
>=20
> Jason
