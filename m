From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH v2] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Fri, 14 Jun 2019 07:44:57 +0200
Message-ID: <9B7C9353-39B6-4193-9ACD-AD0FA62E9433@oracle.com>
References: <20190226075722.1692315-1-haakon.bugge@oracle.com>
 <174ccd37a9ffa05d0c7c03fe80ff7170a9270824.camel@redhat.com>
 <67B4F337-4C3A-4193-B1EF-42FD4765CBB7@oracle.com>
 <6e586118ad154204ad2e2cf2c1391b916cb4ee54.camel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6e586118ad154204ad2e2cf2c1391b916cb4ee54.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 13 Jun 2019, at 22:25, Doug Ledford <dledford@redhat.com> wrote:
>=20
> On Thu, 2019-06-13 at 18:58 +0200, H=C3=A5kon Bugge wrote:
>>> On 13 Jun 2019, at 16:25, Doug Ledford <dledford@redhat.com> wrote:
>>>=20
>>> On Tue, 2019-02-26 at 08:57 +0100, H=C3=A5kon Bugge wrote:
>>>> During certain workloads, the default CM response timeout is too
>>>> short, leading to excessive retries. Hence, make it configurable
>>>> through sysctl. While at it, also make number of CM retries
>>>> configurable.
>>>>=20
>>>> The defaults are not changed.
>>>>=20
>>>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>>>> ---
>>>> v1 -> v2:
>>>>  * Added unregister_net_sysctl_table() in cma_cleanup()
>>>> ---
>>>> drivers/infiniband/core/cma.c | 52
>>>> ++++++++++++++++++++++++++++++---
>>>> --
>>>> 1 file changed, 45 insertions(+), 7 deletions(-)
>>>=20
>>> This has been sitting on patchworks since forever.  Presumably
>>> because
>>> Jason and I neither one felt like we really wanted it, but also
>>> couldn't justify flat refusing it.
>>=20
>> I thought the agreement was to use NL and iproute2. But I haven't had
>> the capacity.
>=20
> To be fair, the email thread was gone from my linux-rdma folder.  So, =
I
> just had to review the entry in patchworks, and there was no captured
> discussion there.  So, if the agreement was made, it must have been
> face to face some time and if I was involed, I had certainly forgotten
> by now.  But I still needed to clean up patchworks, hence my email =
;-).

This is the "agreement" I was referring too:

> On 4 Mar 2019, at 07:27, Parav Pandit <parav@mellanox.com> wrote:
>=20
>> []
>=20
> I think we should use rdma_nl_register(RDMA_NL_RDMA_CM, cma_cb_table) =
which was removed as part of ID stats removal.
> Because of below reasons.
> 1. rdma netlink command auto loads the module
> 2. we don't need to write any extra code to do register_net_sysctl () =
in each netns.
> Caller's skb's netns will read/write value of response_timeout in =
'struct cma_pernet'.
> 3. last time sysctl added in ipv6 was in 2017 in net/ipv6/addrconf.c, =
however ipv4 was done in 2018.
>=20
> Currently rdma_cm/rdma_ucma has configfs, sysctl.
> We are adding netlink sys params to ib_core.
>=20
> We already have 3 clients and infra built using rdma_nl_register() =
netlink , so hooking up to netlink will provide unified way to set rdma =
params.
> Let's just use netlink for any new params unless it is not doable.



>=20
>>> Well, I've made up my mind, so
>>> unless Jason wants to argue the other side, I'm rejecting this
>>> patch.=20
>>> Here's why.  The whole concept of a timeout is to help recovery in
>>> a
>>> situation that overloads one end of the connection.  There is a
>>> relationship between the max queue backlog on the one host and the
>>> timeout on the other host. =20
>>=20
>> If you refer to the backlog parameter in rdma_listen(), I cannot see
>> it being used at all for IB.
>=20
> No, not exactly.  I was more referring to heavy load causing an
> overflow in the mad packet receive processing.  We have
> IB_MAD_QP_RECV_SIZE set to 512 by default, but it can be changed at
> module load time of the ib_core module and that represents the maximum
> number of backlogged mad packets we can have waiting to be processed
> before we just drop them on the floor.  There can be other places to
> drop them too, but this is the one I was referring to.

That is another scenario than what I try to solve. What I see, is that =
the MAD packets are delayed, not lost. The delay is longer than the CMA =
timeout. Hence, the MAD packets are retried, adding more burden to the =
PF proxying and inducing even longer delays. And excessive CM retries =
are observed. See 2612d723aadc ("IB/mlx4: Increase the timeout for CM =
cache") where I have some quantification thereof.

Back to your scenario above, yes indeed, the queue sizes are module =
params. If the MADs are tossed, we will see rq_num_udsdprd incrementing =
on a CX-3.

But I do not understand how the dots are connected. Assume one client =
does rdma_listen(, backlog =3D 1000); Where are those 1000 REQs stored, =
assuming an "infinite slow processor"?


Thxs, H=C3=A5kon


>=20
>> For CX-3, which is paravirtualized wrt. MAD packets, it is the proxy
>> UD receive queue length for the PF driver that can be construed as a
>> backlog. Remember that any MAD packet being sent from a VF or the PF
>> itself, is sent to a proxy UD QP in the PF. Those packets are then
>> multiplexed out on the real QP0/1. Incoming MAD packets are
>> demultiplexed and sent once more to the proxy QP in the VF.
>>=20
>>> Generally, in order for a request to get
>>> dropped and us to need to retransmit, the queue must already have a
>>> full backlog.  So, how long does it take a heavily loaded system to
>>> process a full backlog?  That, plus a fuzz for a margin of error,
>>> should be our timeout.  We shouldn't be asking users to configure
>>> it.
>>=20
>> Customer configures #VMs and different workload may lead to way
>> different number of CM connections. The proxying of MAD packet
>> through the PF driver has a finite packet rate. With 64 VMs, 10.000
>> QPs on each, all going down due to a switch failing or similar, you
>> have 640.000 DREQs to be sent, and with the finite packet rate of MA
>> packets through the PF, this takes more than the current CM timeout.
>> And then you re-transmit and increase the burden of the PF proxying.
>>=20
>> So, we can change the default to cope with this. But, a MAD packet is
>> unreliable, we may have transient loss. In this case, we want a short
>> timeout.
>>=20
>>> However, if users change the default backlog queue on their
>>> systems,
>>> *then* it would make sense to have the users also change the
>>> timeout
>>> here, but I think guidance would be helpful.
>>>=20
>>> So, to revive this patch, what I'd like to see is some attempt to
>>> actually quantify a reasonable timeout for the default backlog
>>> depth,
>>> then the patch should actually change the default to that
>>> reasonable
>>> timeout, and then put in the ability to adjust the timeout with
>>> some
>>> sort of doc guidance on how to calculate a reasonable timeout based
>>> on
>>> configured backlog depth.
>>=20
>> I can agree to this :-)
>>=20
>>=20
>> Thxs, H=C3=A5kon
>>=20
>>> --=20
>>> Doug Ledford <dledford@redhat.com>
>>>   GPG KeyID: B826A3330E572FDD
>>>   Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
>>> 2FDD
>=20
> --=20
> Doug Ledford <dledford@redhat.com>
>    GPG KeyID: B826A3330E572FDD
>    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> 2FDD
