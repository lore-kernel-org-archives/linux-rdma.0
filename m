From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: wireshark's RPC-over-RDMA dissector
Date: Wed, 9 Nov 2016 22:11:52 +0530
Message-ID: <CAG53R5WQRCD32iEefGoaRqggAT1hyv_FSpCAN3c3Z7sVspzx1Q@mail.gmail.com>
References: <2975B49B-2696-4E2A-B9D0-2D6CB607EC59@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2975B49B-2696-4E2A-B9D0-2D6CB607EC59-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

Just FYI.
I have committed few fixes in wireshark trunk for RoCE and IB
dissectors which will in general benefit other ULPs as well (primary
for statefulness of ULPs) last month.

I have few patches pending in my sandbox in area of RoCE and for other
ULP that I will push in coming days, likely next week.
I am currently actively testing them and have made steady progress so far.

I will try to find sometime to review them next week.

Regards,
Parav Pandit


On Wed, Nov 9, 2016 at 9:35 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hi-
>
> Thanks to Yan Berman, for a couple of years now we've had a basic
> RPC-over-RDMA dissector in wireshark that can be used with ibdump
> captures. There have been some bugs noted, but no-one has had the
> cycles to dig in and address.
>
> Recently Tom Haynes helped me set up my own wireshark build so I
> could help address some of the known issues.
>
> http://git.linux-nfs.org/?p=3Dcel/wireshark.git;a=3Dshortlog;h=3Drefs/hea=
ds/rpc-rdma-fixes
>
> Posting here for review before I take the next steps to push these
> to the wireshark community. Constructive critique and other
> suggestions are welcome.
>
> The fixes so far focus on dissecting transport headers correctly.
> There continue to be significant open issues with the dissector:
>         =E2=80=A2 There does not appear to be any support for dissecting
>           RPC-over-RDMA on iWARP or RoCE
>         =E2=80=A2 The NFS dissector does not handle portions of the XDR
>           stream that were transmitted via RDMA Read/Write
>         =E2=80=A2 RPC messages conveyed via RDMA_NOMSG are not recognized
>           or dissected
>         =E2=80=A2 There is no association between RDMA Reads and Writes
>           and the RPC-over-RDMA message they go with
>         =E2=80=A2 A CREQ / CREP pair are needed to identify which QP
>           numbers are used for RPC-over-RDMA traffic
>         =E2=80=A2 With TCP, the dissector fully outdents the RPC and NFS
>           dissection results; but with RDMA, the dissector places
>           the results in the tree under the Infiniband header
>         =E2=80=A2 Not enough error detection in the dissector
>
> --
> Chuck Lever
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
