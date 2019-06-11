From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] RDMA/mlx4: Spread completion vectors for proxy CQs
Date: Tue, 11 Jun 2019 16:55:44 +0200
Message-ID: <5D80856A-8EF5-4320-B525-F8B28758CAFD@oracle.com>
References: <20190218183302.1242676-1-haakon.bugge@oracle.com>
 <20190610175336.GA4890@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610175336.GA4890@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, jackm@dev.mellanox.co.il, majd@mellanox.com, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 10 Jun 2019, at 19:53, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Mon, Feb 18, 2019 at 07:33:02PM +0100, H=C3=A5kon Bugge wrote:
>> MAD packet sending/receiving is not properly virtualized in
>> CX-3. Hence, these are proxied through the PF driver. The proxying
>> uses UD QPs. The associated CQs are created with completion vector
>> zero.
>>=20
>> This leads to great imbalance in CPU processing, in particular during
>> heavy RDMA CM traffic.
>>=20
>> Solved by selecting the completion vector on a round-robin base.
>>=20
>> The imbalance can be demonstrated in a bare-metal environment, where
>> two nodes have instantiated 8 VFs each. This using dual ported HCAs,
>> so we have 16 vPorts per physical server.
>>=20
>> 64 processes are associated with each vPort and creates and destroys
>> one QP for each of the remote 64 processes. That is, 1024 QPs per
>> vPort, all in all 16K QPs. The QPs are created/destroyed using the
>> CM.
>>=20
>> Before this commit, we have (excluding all completion IRQs with zero
>> interrupts):
>>=20
>> 396: mlx4-1@0000:94:00.0 199126
>> 397: mlx4-2@0000:94:00.0 1
>>=20
>> With this commit:
>>=20
>> 396: mlx4-1@0000:94:00.0 12568
>> 397: mlx4-2@0000:94:00.0 50772
>> 398: mlx4-3@0000:94:00.0 10063
>> 399: mlx4-4@0000:94:00.0 50753
>> 400: mlx4-5@0000:94:00.0 6127
>> 401: mlx4-6@0000:94:00.0 6114
>> []
>> 414: mlx4-19@0000:94:00.0 6122
>> 415: mlx4-20@0000:94:00.0 6117
>>=20
>> The added pr_info shows:
>>=20
>> create_pv_resources: slave:0 port:1, vector:0, num_comp_vectors:62
>> create_pv_resources: slave:0 port:1, vector:1, num_comp_vectors:62
>> create_pv_resources: slave:0 port:2, vector:2, num_comp_vectors:62
>> create_pv_resources: slave:0 port:2, vector:3, num_comp_vectors:62
>> create_pv_resources: slave:1 port:1, vector:4, num_comp_vectors:62
>> create_pv_resources: slave:1 port:2, vector:5, num_comp_vectors:62
>> []
>> create_pv_resources: slave:8 port:2, vector:18, num_comp_vectors:62
>> create_pv_resources: slave:8 port:1, vector:19, num_comp_vectors:62
>>=20
>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>> ---
>> drivers/infiniband/hw/mlx4/mad.c | 4 ++++
>> 1 file changed, 4 insertions(+)
>=20
> This has been on patchworks for too long. Is it still relevant, or
> were you going to respin this with Chuck's 'least loaded' idea?

Let me send a commit based on the least loaded idea this week.


Thxs, H=C3=A5kon

>=20
> Thanks,
> Jason
