From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] IB/mad: Use ID allocator routines to allocate agent
 number
Date: Wed, 30 May 2018 09:32:02 +0200
Message-ID: <0E56560E-F577-43A6-9F18-B7AC7B5DB213@oracle.com>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180529154922.GA18457@ziepe.ca>
 <A470D739-D0CD-42EE-9196-8E7610B6DAF4@oracle.com>
 <20180529164032.GB18457@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529164032.GB18457@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Doug Ledford <dledford@redhat.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 29 May 2018, at 18:40, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Tue, May 29, 2018 at 06:16:14PM +0200, H=C3=A5kon Bugge wrote:
>>=20
>>> On 29 May 2018, at 17:49, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>>=20
>>> On Tue, May 29, 2018 at 09:38:08AM +0200, Hans Westgaard Ry wrote:
>>>> The agent TID is a 64 bit value split in two dwords.  The least
>>>> significant dword is the TID running counter. The most significant
>>>> dword is the agent number. In the CX-3 shared port model, the mlx4
>>>> driver uses the most significant byte of the agent number to store =
the
>>>> slave number, making agent numbers greater and equal to 2^24 (3 =
bytes)
>>>> unusable.
>>>=20
>>> There is no reason for this to be an ida, just do something like
>>>=20
>>> mad_agent_priv->agent.hi_tid =3D =
atomic_inc_return(&ib_mad_client_id) & mad_agent_priv->ib_dev->tid_mask;
>>>=20
>>> And have the driver set tid_mask to 3 bytes of 0xFF
>>=20
>> The issue is that some of the mad agents are long-lived, so you will
>> wrap and use the same TID twice.
>=20
> We already have that problem, and using ida is problematic because we
> need to maximize the time between TID re-use, which ida isn't doing.

Initially, I thought that too, but consulted the spec which states:

C13-18.1.1: When initiating a new operation, MADHeader:TransactionID
shall be set to such a value that within that MAD the combination of =
TID,
SGID, and MgmtClass is different from that of any other currently =
executing
operation. []

"currently executing operation" that is.

But if timeouts etc. leads to MAD floating around in the fabric, its of =
course more robust to maximize the time between reuse.

Then idr_alloc_cyclic() can be used.

> Preventing re-use seems like a seperate issue from limiting the range
> to be compatible with mlx4.

Yes. But a v2 of Hans' patch using idr_alloc_cyclic() solves both =
issues.


Thxs, H=C3=A5kon

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
