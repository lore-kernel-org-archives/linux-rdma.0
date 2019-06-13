From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH v2] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Thu, 13 Jun 2019 18:58:30 +0200
Message-ID: <67B4F337-4C3A-4193-B1EF-42FD4765CBB7@oracle.com>
References: <20190226075722.1692315-1-haakon.bugge@oracle.com>
 <174ccd37a9ffa05d0c7c03fe80ff7170a9270824.camel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <174ccd37a9ffa05d0c7c03fe80ff7170a9270824.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 13 Jun 2019, at 16:25, Doug Ledford <dledford@redhat.com> wrote:
>=20
> On Tue, 2019-02-26 at 08:57 +0100, H=C3=A5kon Bugge wrote:
>> During certain workloads, the default CM response timeout is too
>> short, leading to excessive retries. Hence, make it configurable
>> through sysctl. While at it, also make number of CM retries
>> configurable.
>>=20
>> The defaults are not changed.
>>=20
>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>> ---
>> v1 -> v2:
>>   * Added unregister_net_sysctl_table() in cma_cleanup()
>> ---
>> drivers/infiniband/core/cma.c | 52 ++++++++++++++++++++++++++++++---
>> --
>> 1 file changed, 45 insertions(+), 7 deletions(-)
>=20
> This has been sitting on patchworks since forever.  Presumably because
> Jason and I neither one felt like we really wanted it, but also
> couldn't justify flat refusing it.

I thought the agreement was to use NL and iproute2. But I haven't had =
the capacity.

>  Well, I've made up my mind, so
> unless Jason wants to argue the other side, I'm rejecting this patch.=20=

> Here's why.  The whole concept of a timeout is to help recovery in a
> situation that overloads one end of the connection.  There is a
> relationship between the max queue backlog on the one host and the
> timeout on the other host. =20

If you refer to the backlog parameter in rdma_listen(), I cannot see it =
being used at all for IB.

For CX-3, which is paravirtualized wrt. MAD packets, it is the proxy UD =
receive queue length for the PF driver that can be construed as a =
backlog. Remember that any MAD packet being sent from a VF or the PF =
itself, is sent to a proxy UD QP in the PF. Those packets are then =
multiplexed out on the real QP0/1. Incoming MAD packets are =
demultiplexed and sent once more to the proxy QP in the VF.

> Generally, in order for a request to get
> dropped and us to need to retransmit, the queue must already have a
> full backlog.  So, how long does it take a heavily loaded system to
> process a full backlog?  That, plus a fuzz for a margin of error,
> should be our timeout.  We shouldn't be asking users to configure it.

Customer configures #VMs and different workload may lead to way =
different number of CM connections. The proxying of MAD packet through =
the PF driver has a finite packet rate. With 64 VMs, 10.000 QPs on each, =
all going down due to a switch failing or similar, you have 640.000 =
DREQs to be sent, and with the finite packet rate of MA packets through =
the PF, this takes more than the current CM timeout. And then you =
re-transmit and increase the burden of the PF proxying.

So, we can change the default to cope with this. But, a MAD packet is =
unreliable, we may have transient loss. In this case, we want a short =
timeout.

> However, if users change the default backlog queue on their systems,
> *then* it would make sense to have the users also change the timeout
> here, but I think guidance would be helpful.
>=20
> So, to revive this patch, what I'd like to see is some attempt to
> actually quantify a reasonable timeout for the default backlog depth,
> then the patch should actually change the default to that reasonable
> timeout, and then put in the ability to adjust the timeout with some
> sort of doc guidance on how to calculate a reasonable timeout based on
> configured backlog depth.

I can agree to this :-)


Thxs, H=C3=A5kon

>=20
> --=20
> Doug Ledford <dledford@redhat.com>
>    GPG KeyID: B826A3330E572FDD
>    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> 2FDD
