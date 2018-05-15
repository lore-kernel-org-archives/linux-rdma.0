From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Tue, 15 May 2018 20:11:09 +0200
Message-ID: <E41BCEAA-0204-448D-8188-ACA03932B3AC@oracle.com>
References: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
 <20180509093020.24503-3-Haakon.Bugge@oracle.com>
 <ab1f16cd-aa60-0c43-841c-aed301fd2a7e@dev.mellanox.co.il>
 <F9802EE9-4420-44EE-93DC-27CC799B427E@oracle.com>
 <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
 <B3360947-5905-47BD-ABC4-6C4BB32F5DA6@oracle.com>
 <20180514210200.GN21531@ziepe.ca>
 <ab0e1318-8e1a-5822-5484-33e460095830@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ab0e1318-8e1a-5822-5484-33e460095830@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 15 May 2018, at 02:38, Hal Rosenstock <hal@dev.mellanox.co.il> =
wrote:
>=20
> On 5/14/2018 5:02 PM, Jason Gunthorpe wrote:
>> On Thu, May 10, 2018 at 05:16:28PM +0200, H=C3=A5kon Bugge wrote:
>>=20
>>> We are talking about two things here. The PKey in the BTH and the
>>> PKey in the CM REQ payload. They differ.
>>>=20
>>> I am out of office, but if my memory serves me correct, the PKey in
>>> the BTH in the MAD packet will be the default PKey. Further, we have
>>> per IBTA:
>>=20
>> This sounds like a Linux bug.
>>=20
>> Linux does not do a PR to get a reversible path dedicated to the GMP> =
so it always uses the data flow path, thus the GMP path paramenters
>> and those in the REQ should always exactly match.
>>=20
>> Where is Linux setting the BTH.PKey and how did it choose to use the
>> default pkey? Lets fix that at least for sure.

Linux isn=E2=80=99t. The BTH.PKey is inserted by the HCA (hw or fw) =
coming from the P_Key table (10.9.2 in IBTA), selected by a pkey_index =
associated with the QP.

As per C10-133: Packets sent from the Send Queue of a GSI QP shall =
attach a P_Key associated with that QP, just as a P_Key is associated =
with nonmanagement QPs

>> Once that is fixed the rest of the series makes no sense since a REQ
>> with invalid PKey will never arrive.
>>=20
>> However...
>>=20
>> This series seems inconsistent with the spec.
>>=20
>> IIRC the spec doesn't say if a full or limited pkey should be placed
>> in the REQ (Hal?).=20
>=20
> CM spec for REQ just says partition key without indicating whether =
this
> means P_Key or just the partition (15 bits) so my read is that either
> full or limited pkey is allowed in REQ.
>=20
>> It is designed so that the requestor can get a
>> single reversible path and put that results into the REQ without
>> additional processing, however the PR returns only one PKey and =
again,
>> it is not really specified if it should be the full or limited pkey
>> (Hal?).
>=20
> Correct; it's not specified.
>=20
>> Basically this means that any pkey in the REQ could randomly be the
>> full or limited value, and that in-of-itself has not bearing on the
>> connection.
>>=20
>> So it is quite wrong to insist that the pkey be limited or full when
>> processing the REQ. The end port is expected to match against the
>> local table.
>=20
> Note that there is thorny issue with shared (physical) port
> virtualization. In shared port virtualization, the VF pkey assignment =
is
> a local matter. Only thing SM knows is the physical port pkeys where
> both full and limited membership of same partition is possible. It is
> conceivable that CM REQ contains limited partition key between 2 =
limited
> VFs and for that a new REJ reason code appears to be needed.

+1


H=C3=A5kon

>=20
> -- Hal
>=20
>> The real answer to your trap problem is to fix the SM to not create
>> paths that are non-functional, that is just flat out broken SM
>> behavior.
>>=20
>> Jason
>>=20
