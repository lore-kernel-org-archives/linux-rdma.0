From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] IB/core: Make ib_mad_client_id atomic
Date: Tue, 1 May 2018 08:40:07 +0200
Message-ID: <451F533C-60E1-4154-9540-92CB83276446@oracle.com>
References: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
 <1524196555.11756.30.camel@redhat.com> <20180420153451.GF30433@ziepe.ca>
 <50E3FE4A-2C6E-4493-92E1-383C349FAE3A@oracle.com>
 <20180423221618.0000795d@dev.mellanox.co.il>
 <20180430144930.GB26895@ziepe.ca> <1525108249.11756.93.camel@redhat.com>
 <20180501073816.00001ec6@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180501073816.00001ec6@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: jackm <jackm@dev.mellanox.co.il>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Don Hiatt <don.hiatt@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 1 May 2018, at 06:38, jackm <jackm@dev.mellanox.co.il> wrote:
>=20
> On Mon, 30 Apr 2018 13:10:49 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>=20
> Looks good!

Yes, absolutely!

H=C3=A5kon

>=20
> -Jack
>=20
>> On Mon, 2018-04-30 at 08:49 -0600, Jason Gunthorpe wrote:
>>> On Mon, Apr 23, 2018 at 10:16:18PM +0300, jackm wrote:
>>>=20
>>>>>> TIDs need to be globally unique on the entire machine.   =20
>>>> Jason, that is not exactly correct. =20
>>>=20
>>> The expecation for /dev/umad users is that they all receive locally
>>> unique TID prefixes. The kernel may be OK to keep things
>>> port-specific but it is slightly breaking the API we are presenting
>>> to userspace to allow them to alias..
>>>=20
>>> Jason =20
>>=20
>> Would people be happier with this commit message then:
>>=20
>> IB/core: Make ib_mad_client_id atomic
>>=20
>> Currently, the kernel protects access to the agent ID allocator on a
>> per port basis using a spinlock, so it is impossible for two
>> apps/threads on the same port to get the same TID, but it is entirely
>> possible for two threads on different ports to end up with the same
>> TID. =20
>>=20
>> As this can be confusing (regardless of it being legal according to
>> the IB Spec 1.3, C13-18.1.1, in section 13.4.6.4 - TransactionID
>> usage), and as the rdma-core user space API for /dev/umad devices
>> implies unique TIDs even across ports, make the TID an atomic type so
>> that no two allocations, regardless of port number, will be the same.
>>=20
>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>> Reviewed-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>>=20
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
