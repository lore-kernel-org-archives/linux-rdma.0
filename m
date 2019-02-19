From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH] RDMA/mlx4: Spread completion vectors for proxy CQs
Date: Tue, 19 Feb 2019 12:39:02 -0500
Message-ID: <692D2301-5738-4B60-B80D-901F0D2040E9@oracle.com>
References: <20190218183302.1242676-1-haakon.bugge@oracle.com>
 <38187795-4082-42C2-AF56-E6C89EE7DE39@oracle.com>
 <66C92ED1-EE5E-4136-A7D7-DBF8A0816800@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <66C92ED1-EE5E-4136-A7D7-DBF8A0816800@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, jackm@dev.mellanox.co.il, majd@mellanox.com, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On Feb 19, 2019, at 12:32 PM, H=C3=A5kon Bugge =
<haakon.bugge@oracle.com> wrote:
>=20
>=20
>=20
>> On 19 Feb 2019, at 15:58, Chuck Lever <chuck.lever@oracle.com> wrote:
>>=20
>> Hey H=C3=A5kon-
>>=20
>>> On Feb 18, 2019, at 1:33 PM, H=C3=A5kon Bugge =
<haakon.bugge@oracle.com> wrote:
>>>=20
>>> MAD packet sending/receiving is not properly virtualized in
>>> CX-3. Hence, these are proxied through the PF driver. The proxying
>>> uses UD QPs. The associated CQs are created with completion vector
>>> zero.
>>>=20
>>> This leads to great imbalance in CPU processing, in particular =
during
>>> heavy RDMA CM traffic.
>>>=20
>>> Solved by selecting the completion vector on a round-robin base.
>>=20
>> I've got a similar patch for NFS and NFSD. I'm wondering if this
>> should be turned into a core helper, simple as it is. Perhaps
>> it would be beneficial if all participating ULPs used the same
>> global counter?
>=20
>=20
> A global counter works for this commit, because the QPs and associated =
CQs are (pretty) persistent. That is, VMs doesn't come and go that =
often.
>=20
> In the more general ULP case, the usage model is probably a lot more =
intermittent. Hence, a least-load approach is probably better. That can =
be implemented in ib core. I've seen in the past an enum =
IB_CQ_USE_LEAST_LOAD_VECTOR for signalling this behaviour and define =
that to e.g. -1, that is, outside of 0..(num_comp_vectors-1).

Indeed, passing such a value to either ib_create_cq or ib_alloc_cq
could allow the compvec to be selected automatically. Using a
round-robin would be the first step towards something smarter, and
the ULPs need be none the wiser when more smart-i-tude eventually
comes along.


> But this mechanism doesn't know which CQs that delivers the most =
interrupts. We lack an ib_modify_cq() that may change the CQ to EQ =
association, to _really_ spread the interrupts, not the CQ to EQ =
association.
>=20
> Anyway, Jason mentioned in a private email that maybe we could use the =
new completion API or something? I am not familiar with that one (yet).
>=20
> Well, I can volunteer to do the least load approach in ib core and =
change all (plain stupid) zero comp_vectors in ULPs and core, if that =
seems like an interim approach.

Please update net/sunrpc/xprtrdma/{svc_rdma_,}transport.c as well.
It should be straightforward, and I'm happy to review and test as
needed.


> Thxs, H=C3=A5kon
>=20
>=20
>=20
>=20
>>=20
>>=20
>>> The imbalance can be demonstrated in a bare-metal environment, where
>>> two nodes have instantiated 8 VFs each. This using dual ported HCAs,
>>> so we have 16 vPorts per physical server.
>>>=20
>>> 64 processes are associated with each vPort and creates and destroys
>>> one QP for each of the remote 64 processes. That is, 1024 QPs per
>>> vPort, all in all 16K QPs. The QPs are created/destroyed using the
>>> CM.
>>>=20
>>> Before this commit, we have (excluding all completion IRQs with zero
>>> interrupts):
>>>=20
>>> 396: mlx4-1@0000:94:00.0 199126
>>> 397: mlx4-2@0000:94:00.0 1
>>>=20
>>> With this commit:
>>>=20
>>> 396: mlx4-1@0000:94:00.0 12568
>>> 397: mlx4-2@0000:94:00.0 50772
>>> 398: mlx4-3@0000:94:00.0 10063
>>> 399: mlx4-4@0000:94:00.0 50753
>>> 400: mlx4-5@0000:94:00.0 6127
>>> 401: mlx4-6@0000:94:00.0 6114
>>> []
>>> 414: mlx4-19@0000:94:00.0 6122
>>> 415: mlx4-20@0000:94:00.0 6117
>>>=20
>>> The added pr_info shows:
>>>=20
>>> create_pv_resources: slave:0 port:1, vector:0, num_comp_vectors:62
>>> create_pv_resources: slave:0 port:1, vector:1, num_comp_vectors:62
>>> create_pv_resources: slave:0 port:2, vector:2, num_comp_vectors:62
>>> create_pv_resources: slave:0 port:2, vector:3, num_comp_vectors:62
>>> create_pv_resources: slave:1 port:1, vector:4, num_comp_vectors:62
>>> create_pv_resources: slave:1 port:2, vector:5, num_comp_vectors:62
>>> []
>>> create_pv_resources: slave:8 port:2, vector:18, num_comp_vectors:62
>>> create_pv_resources: slave:8 port:1, vector:19, num_comp_vectors:62
>>>=20
>>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>>> ---
>>> drivers/infiniband/hw/mlx4/mad.c | 4 ++++
>>> 1 file changed, 4 insertions(+)
>>>=20
>>> diff --git a/drivers/infiniband/hw/mlx4/mad.c =
b/drivers/infiniband/hw/mlx4/mad.c
>>> index 936ee1314bcd..300839e7f519 100644
>>> --- a/drivers/infiniband/hw/mlx4/mad.c
>>> +++ b/drivers/infiniband/hw/mlx4/mad.c
>>> @@ -1973,6 +1973,7 @@ static int create_pv_resources(struct =
ib_device *ibdev, int slave, int port,
>>> {
>>> 	int ret, cq_size;
>>> 	struct ib_cq_init_attr cq_attr =3D {};
>>> +	static atomic_t comp_vect =3D ATOMIC_INIT(-1);
>>>=20
>>> 	if (ctx->state !=3D DEMUX_PV_STATE_DOWN)
>>> 		return -EEXIST;
>>> @@ -2002,6 +2003,9 @@ static int create_pv_resources(struct =
ib_device *ibdev, int slave, int port,
>>> 		cq_size *=3D 2;
>>>=20
>>> 	cq_attr.cqe =3D cq_size;
>>> +	cq_attr.comp_vector =3D atomic_inc_return(&comp_vect) % =
ibdev->num_comp_vectors;
>>> +	pr_info("slave:%d port:%d, vector:%d, num_comp_vectors:%d\n",
>>> +		slave, port, cq_attr.comp_vector, =
ibdev->num_comp_vectors);
>>> 	ctx->cq =3D ib_create_cq(ctx->ib_dev, =
mlx4_ib_tunnel_comp_handler,
>>> 			       NULL, ctx, &cq_attr);
>>> 	if (IS_ERR(ctx->cq)) {
>>> --=20
>>> 2.20.1
>>>=20
>>=20
>> --
>> Chuck Lever

--
Chuck Lever
