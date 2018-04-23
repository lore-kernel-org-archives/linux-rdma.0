From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] IB/core: Make ib_mad_client_id atomic
Date: Mon, 23 Apr 2018 16:19:57 +0200
Message-ID: <50E3FE4A-2C6E-4493-92E1-383C349FAE3A@oracle.com>
References: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
 <1524196555.11756.30.camel@redhat.com> <20180420153451.GF30433@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420153451.GF30433@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, jackm <jackm@dev.mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org


+Jack

> On 20 Apr 2018, at 17:34, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Thu, Apr 19, 2018 at 11:55:55PM -0400, Doug Ledford wrote:
>> On Wed, 2018-04-18 at 16:24 +0200, H=C3=A5kon Bugge wrote:
>>> Two kernel threads may get the same value for agent.hi_tid, if the
>>> agents are registered for different ports. As of now, this works, as
>>> the agent list is per port.
>>>=20
>>> It is however confusing and not future robust. Hence, making it
>>> atomic.
>>>=20
>>=20
>> People sometimes underestimate the performance penalty of atomic ops.=20=

>> Every atomic op is the equivalent of a spin_lock/spin_unlock pair.

Well, may be this holds true if the mutex and the variable is located in =
the same cacheline.

>>  This
>> is why two atomics are worse than taking a spin_lock, doing what you
>> have to do, and releasing the spin_lock.  Is this really what you =
want
>> for a "confusing, let's make it robust" issue?
>=20
> But it is on the ib_register_mad_agent() path which is not a
> performance path..
>=20
> This actually looks like a genuine bug, why is it described only as
> 'confusing'? ib_register_mad_agent is callable from userspace, so at
> least two userspace agents can race and get the same TID=E2=80=99s.

My understanding is that every lookup is using the {port, TID} tuple. As =
such, it is not a bug, but, very confusing.

> TIDs need to be globally unique on the entire machine.

If you are correct Jason, let me reword the commit message.


Thxs, H=C3=A5kon
