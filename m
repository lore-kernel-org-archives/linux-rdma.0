From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 03/18] xprtrdma: Remove completion polling budgets
Date: Thu, 1 Oct 2015 14:31:41 -0400
Message-ID: <E543F197-56F6-43FC-A2FE-4273695405E9@oracle.com>
References: <20150917204435.19671.56195.stgit@manet.1015granger.net> <CANjDDBgokeHEZ7jWhRKRRU4Usr655zRoYY-qUHc9jeuyjYBzpA@mail.gmail.com> <A3B1A836-81AF-40E6-B551-587B7173B72D@oracle.com> <55FE8C0F.1050706@dev.mellanox.co.il> <CANjDDBjcRXsPFt2Bd+9oL2wTBTxpDsAvN5PZN669dhTC7xSyqw@mail.gmail.com> <0804C887-9E32-4257-96D2-6C1FBC9CB271@oracle.com> <CANjDDBgB_T9BN7ATTWEJcJScs2JH9bGv5zikUpu_2JJaRYS-Ug@mail.gmail.com> <A5EE402A-82CE-49DC-8AB9-63EC340CE8DA@oracle.com> <20151001171310.GA8428@obsidianresearch.com> <CDDBC387-9135-405E-B535-EE89F952386E@oracle.com> <20151001181548.GA8670@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151001181548.GA8670-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Oct 1, 2015, at 2:15 PM, Jason Gunthorpe <jgunthorpe@obsidianresea=
rch.com> wrote:
>=20
> On Thu, Oct 01, 2015 at 01:36:26PM -0400, Chuck Lever wrote:
>=20
>>>> A missed WC will result in an RPC/RDMA transport deadlock. In
>>>> fact that is the reason for this particular patch (although
>>>> it addresses only one source of missed WCs). So I would like
>>>> to see that there are no windows here.
>>>=20
>>> WCs are never missed.
>>=20
>> The review comment earlier in this thread suggested there is
>> a race condition where a WC can be =E2=80=9Cdelayed=E2=80=9D resulti=
ng in,
>> well, I=E2=80=99m still not certain what the consequences are.
>=20
> Yes. The consequence would typically be lockup of CQ processing.
>=20
>>> while (1) {
>>> struct ib_wc wcs[100];
>>> int rc =3D ib_poll_cq(cw, NELEMS(wcs), wcs);
>>>=20
>>> .. process rc wcs ..
>>>=20
>>> if (rc !=3D NELEMS(wcs))
>>>   if (ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
>>>       IB_CQ_REPORT_MISSED_EVENTS) =3D=3D 0)
>>>    break;
>>> }
>>>=20
>>> API wise, we should probably look at forcing
>>> IB_CQ_REPORT_MISSED_EVENTS on and dropping the flag.
>>=20
>> It=E2=80=99s been suggested that it=E2=80=99s not clear what a posit=
ive
>> return value from ib_req_notify_cq() means when the
>> REPORT_MISSED_EVENTS flags is set: does it mean that
>> the CQ has been re-armed? I had assumed that a positive
>> RC meant both missed events and a successful re-arm,
>> but the pseudo-code above suggests that is not the
>> case.
>=20
> The ULP must assume the CQ has NOT been armed after a positive return=
=2E

OK, I will fix this when I revise 03/18.


> What the driver does to the arm state is undefined - for instance the
> driver may trigger a callback and still return 1 here.
>=20
> However, the driver must make this guarentee:
>=20
> If ib_req_notify_cq(IB_CQ_REPORT_MISSED_EVENTS) returns 0 then
> the call back will always be called when the CQ is non-empty.
>=20
> The ULP must loop doing polling until the above happens, otherwise th=
e
> event notification may be missed.
>=20
> ie the above is guarnteed to close the WC delay/lockup race.
>=20
> Again, if there has been confusion on the driver side, drivers that
> don't implement the above are broken.
>=20
> Review Roland's original commit comments on this feature.
>=20
> https://github.com/jgunthorpe/linux/commit/ed23a72778f3dbd465e55b06fe=
31629e7e1dd2f3
>=20
> I'm not sure where we are at on the 'significant overhead for some
> low-level drivers' issue, but assuming that is still the case, then
> the recommendation is this:
>=20
> bool exiting =3D false;
> while (1) {
>   struct ib_wc wcs[100];
>   int rc =3D ib_poll_cq(cq, NELEMS(wcs), wcs);
>   if (rc =3D=3D 0 && exiting)
>        break;
>=20
>   .. process rc wcs ..
>=20
>   if (rc !=3D NELEMS(wcs)) {
>        ib_req_notify_cq(cq, IB_CQ_NEXT_COMP)
> 	exiting =3D true;
>   } else
> 	exiting =3D false;
> }
>=20
> ie a double poll.
> AFAIK, this is a common pattern in the ULPs.. Perhaps we should
> implement this as a core API:
>=20
> struct ib_wc wcs[100];
> while ((rc =3D ib_poll_cq_and_arm(cq, NELEMS(wcs), wcs)) !=3D 0) {
>   .. process rc wcs  ..
>=20
> ib_poll_cq_and_arm reads wcs off the CQ. If it returns 0 then the
> callback is guarenteed to happen when the CQ is non empty.

This makes sense to me, especially if it means fewer
times grabbing and releasing the CQ=E2=80=99s spinlock.

Does a ULP want to continue polling if ib_poll_cq{_and_arm)
returns a negative RC?


=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
