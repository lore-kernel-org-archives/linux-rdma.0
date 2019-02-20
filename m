From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] RDMA/mlx4: Spread completion vectors for proxy CQs
Date: Wed, 20 Feb 2019 18:46:47 +0100
Message-ID: <A7FA2738-ACD2-42C7-A0AF-4343583CF87E@oracle.com>
References: <20190218183302.1242676-1-haakon.bugge@oracle.com>
 <38187795-4082-42C2-AF56-E6C89EE7DE39@oracle.com>
 <66C92ED1-EE5E-4136-A7D7-DBF8A0816800@oracle.com>
 <20190220171441.GH8429@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190220171441.GH8429@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Chuck Lever <chuck.lever@oracle.com>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, jackm@dev.mellanox.co.il, majd@mellanox.com, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 20 Feb 2019, at 18:14, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Tue, Feb 19, 2019 at 06:32:50PM +0100, H=C3=A5kon Bugge wrote:
>>   Anyway, Jason mentioned in a private email that maybe we could use =
the
>>   new completion API or something? I am not familiar with that one
>>   (yet).
>=20
> I was thinking of the stuff in core/cq.c - but it also doesn't have
> automatic comp_vector balancing. It is the logical place to put
> something like that though..
>=20
> An API to manage a bundle of CPU affine CQ's is probably what most
> ULPs really need.. (it makes little sense to create a unique CQ for
> every QP)

ULPs behave way differently. E.g. RDS creates one tx and one rx CQ per =
QP.

As I wrote earlier, we do not have any modify_cq() that changes the =
comp_vector (EQ association). We can balance #CQ associated with the =
EQs, but we do not know their behaviour.

So, assume 2 completion EQs, and four CQs. CQa and CQb are associated =
with the first EQ, the two others with the second EQ. That's the "best" =
we can do. But, if CQa and CQb are the only ones generating events, we =
will have all interrupt processing on a single CPU. But if we now could =
modify CQa.comp_vector to be that of the second EQ, we could achieve =
balance. But not sure if the drivers are able to do this at all.

> alloc_bundle()

You mean alloc a bunch of CQs? How do you know their #cqes and =
cq_context?


H=C3=A5kon


> get_cqn_for_flow(bundle)
> alloc_qp()
> destroy_qp()
> put_cqn_for_flow(bundle)
> destroy_bundle();
>=20
> Let the core code balance the cqn's and allocate (shared) CQ
> resources.
>=20
> Jason
