From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 03/18] xprtrdma: Remove completion polling budgets
Date: Thu, 1 Oct 2015 13:36:26 -0400
Message-ID: <CDDBC387-9135-405E-B535-EE89F952386E@oracle.com>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net> <20150917204435.19671.56195.stgit@manet.1015granger.net> <CANjDDBgokeHEZ7jWhRKRRU4Usr655zRoYY-qUHc9jeuyjYBzpA@mail.gmail.com> <A3B1A836-81AF-40E6-B551-587B7173B72D@oracle.com> <55FE8C0F.1050706@dev.mellanox.co.il> <CANjDDBjcRXsPFt2Bd+9oL2wTBTxpDsAvN5PZN669dhTC7xSyqw@mail.gmail.com> <0804C887-9E32-4257-96D2-6C1FBC9CB271@oracle.com> <CANjDDBgB_T9BN7ATTWEJcJScs2JH9bGv5zikUpu_2JJaRYS-Ug@mail.gmail.com> <A5EE402A-82CE-49DC-8AB9-63EC340CE8DA@oracle.com> <20151001171310.GA8428@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151001171310.GA8428-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Oct 1, 2015, at 1:13 PM, Jason Gunthorpe <jgunthorpe@obsidianresea=
rch.com> wrote:
>=20
> On Thu, Oct 01, 2015 at 12:37:36PM -0400, Chuck Lever wrote:
>=20
>> A missed WC will result in an RPC/RDMA transport deadlock. In
>> fact that is the reason for this particular patch (although
>> it addresses only one source of missed WCs). So I would like
>> to see that there are no windows here.
>=20
> WCs are never missed.

The review comment earlier in this thread suggested there is
a race condition where a WC can be =E2=80=9Cdelayed=E2=80=9D resulting =
in,
well, I=E2=80=99m still not certain what the consequences are.

There was some interest in going back to a single WC array
argument when calling ib_poll_cq. I=E2=80=99d like to avoid that.

If there is an issue using a WC array, I=E2=80=99d like to
understand what it is.


> The issue is a race where re-arming the CQ might not work, meaning yo=
u
> don't get an event.
>=20
> You can certainly use arrays with poll_cq. There is no race in the AP=
I
> here.
>=20
> But you have to use the IB_CQ_REPORT_MISSED_EVENTS scheme to guarante=
e
> the CQ is actually armed or continue to loop again.
>=20
> Basically you have to loop until ib_req_notify_cq succeeds.
>=20
> Any driver that doesn't support this is broken, do we know of any?
>=20
> while (1) {
>  struct ib_wc wcs[100];
>  int rc =3D ib_poll_cq(cw, NELEMS(wcs), wcs);
>=20
>  .. process rc wcs ..
>=20
>  if (rc !=3D NELEMS(wcs))
>    if (ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
>        IB_CQ_REPORT_MISSED_EVENTS) =3D=3D 0)
>     break;
> }
>=20
> API wise, we should probably look at forcing
> IB_CQ_REPORT_MISSED_EVENTS on and dropping the flag.

It=E2=80=99s been suggested that it=E2=80=99s not clear what a positive
return value from ib_req_notify_cq() means when the
REPORT_MISSED_EVENTS flags is set: does it mean that
the CQ has been re-armed? I had assumed that a positive
RC meant both missed events and a successful re-arm,
but the pseudo-code above suggests that is not the
case.


=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
