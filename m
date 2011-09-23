From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 14:01:50 -0400
Message-ID: <4E7CC98E.5050408@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com> <20110921151349.140d95f6.weiny2@llnl.gov> <1828884A29C6694DAF28B7E6B8A8237316E6723E@ORSMSX101.amr.corp.intel.com> <20110921153254.06c77ebc.weiny2@llnl.gov> <20110921223546.GI28454@obsidianresearch.com> <CAKzyTsw8TKFNPS8QFgjag7XZ77cu=OzofAuAKTr_DQmkPTsogw@mail.gmail.com> <20110923165758.GM28454@obsidianresearch.com> <4E7CC268.4000909@dev.mellanox.co.il> <20110923175542.GN28454@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923175542.GN28454-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/23/2011 1:55 PM, Jason Gunthorpe wrote:
> On Fri, Sep 23, 2011 at 01:31:20PM -0400, Hal Rosenstock wrote:
>=20
>>> The only wonky bit
>>> was that verbs was needed for subnet timeout because it isn't in
>>> sysfs. Everything else went according to the spec.
>>
>> I don't see how your algorithm can be compliant with just subnet tim=
eout.
>=20
> Really?
>=20
> 13.4.6.3  specifies the formula
>=20
>                  CommTimeValueOut    CommTimeValueIn    RespTimeValue
> 4.096 =B5sec x ( 2                  +2                 +2            =
   )
>=20
> Which boils down to=20
>=20
> 4.096 =B5sec x (2 x 2**(Subnet_Timeout) + 2**(RespTimeValue))
>=20
> For the on subnet case.
>=20
> RespTimeValue comes from the class port info of the target manager,
> and C13-13.1.1 gives guidance what value to use for the initial class
> port info query to get the value.
>=20
> Which is exactly what I implemented.
>=20
> It isn't hard.

and for SM MADs you need PortInfo:RespTimeValue (do you do SM MADs too =
?)

My point was that verbs alone is insufficient as you need a MAD to do
this and the first round trip needs an artificial timeout (before you
know the RespTimeValue from wherever you get it). Clearly, for non SM
MADs, having subnet timeout as a port attribute saves that round trip.

-- Hal

> Jason
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
