From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
Date: Thu, 14 Jul 2016 19:12:48 +0200
Message-ID: <5722B9B9-2145-414A-957A-AA5C1C223B31@oracle.com>
References: <1468402436-25053-1-git-send-email-yuval.shaia@oracle.com> <20160713174742.GE19657@obsidianresearch.com> <20160713191224.GB2985@yuval-lap> <20160713192504.GA26851@obsidianresearch.com> <20160713195030.GB4929@yuval-lap.uk.oracle.com> <02892134-15c7-963a-d13b-95d6e35ceaca@oracle.com> <20160713205358.GA27704@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160713205358.GA27704-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On 13 Jul 2016, at 22:53, Jason Gunthorpe <jgunthorpe@obsidianresearc=
h.com> wrote:
>=20
> On Wed, Jul 13, 2016 at 01:46:07PM -0700, Santosh Shilimkar wrote:
>>> Patch does not offer any recovery mechanism it simply print fatal e=
rror to
>>> console and exit NAPI. This fatal error will suggest admin to reloa=
d the
>>> driver or something like that.
>>> This takes us to "recovery-mechanism" :)
>>> I'm not sure that restarting the QP will help as the error is while=
 reading
>>> the CQ and restarting the CQ is more or less like restarting the dr=
iver.
>>>=20
>> Probably Jason mean destroy the problematic CQ and create a new one.=
 This is
>> what Haakon suggested as well but it will lead to the leak
>> and also possible issue with outstanding WC's getting lost without
>> being flushed on that CQ.
>=20
> Again, this seems crazy.
>=20
> What failure mode does a CQ have that does not require a full driver
> restart after?

The OFED API clearly indicates that ib_poll_cq() might fail and return =
an error status.

This API is also conforms with the IBTA specification, section 11.4.2.1=
 Poll for Completion:

=E2=80=9CIf an immediate error, associated with executing the Poll CQ v=
erb itself, is returned, the CQ and QP state shall not be affected.=E2=80=
=9D

> Drivers that hard fail a CQ poll should declare themselves dead and
> require a full restart to recover. This is the same infrastructure
> that was added to the mlx drivers to handle other forms of hard
> errors.

Yes, but this is at the discretion of the driver. Provider drivers are =
free to have a BUG_ON() instead of a return -EINVAL. But that is not th=
e case. And, if there is an intermittent error return (e.g., EAGAIN), I=
 take it that we can agree that the driver shall not declare itself dea=
d.

Now, for drivers that can fault isolate a CQ error to the CQ and affect=
ed QPs, as supported by the API, should be allowed to offer that possib=
ility in my opinion. Errors do happen, although this kind of errors hap=
pen seldom. There are different failover models that can be used to ove=
rcome such an error, whether it is intermittent or hard.

> This was the same direction we went in for the _destroy functions.
>=20
> poll_cq should only return -EAGAIN or success (and EAGAIN seems
> fairly strange, how is that different from returning 0 wcs?)

Well, now we are post the creation time of the OFED API and the IBTA st=
andard, and you propose to change them. Thats is OK by itself, but orth=
ogonal to this commit.

I see -EINVAL returned from poll_cq() from ehca and mlx4 for example.

> If there is some actual reason preventing a driver from implementing
> that kind of API lets hear it. Otherwise I recommend you focus patche=
s
> on fixing any broken drivers and documenting this requirement.

Well, handling legitimate and possible error returns from HCA drivers i=
s honourable enough in my opinion.



H=C3=A5kon


>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
