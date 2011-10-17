From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma: 3.1.0-rc9 breaks UD
Date: Mon, 17 Oct 2011 23:14:26 +0200
Message-ID: <CAJZOPZJVNiwU-YA6KteOoFYX5M=BzPEZJsvRoFOz170O11qgeA@mail.gmail.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1110140852210.6411-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2011 at 4:02 PM, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org> wrot=
e:
> Running ibv_ud_pingpong and ibc_uc_pingpong between two hosts. One wi=
th
> OFED 1.5.3.1 (Ubuntu LTS 10.04) and another on linux 3.1.0-rc9 (Same
> ubuntu version uderlying) with the upstream libraries.
> ibv_ud_pingpong
> OFED:
> # ibv_ud_pingpong
> =A0local address: =A0LID 0x000a, QPN 0x50004d, PSN 0x8b572b: GID ::
> =A0remote address: LID 0x000b, QPN 0x02004c, PSN 0x2117ef, GID ::
> 3.1.0-rc9:
> # ibv_ud_pingpong 10.2.35.21
> =A0local address: =A0LID 0x000b, QPN 0x02004c, PSN 0x2117ef: GID ::
> =A0remote address: LID 0x000a, QPN 0x50004d, PSN 0x8b572b, GID ::
> No traffic flows.

Could you try that again with small msg size e.g use "-s 100", if that
doesn't help
can you send the output of "ibv_devinfo" from both nodes. Also please
specify the exact top commit of the two libraries (libibverbs and I
assume libmlx4 if you use Mellanox ConnectX) in case you built them
from the git trees, or the library version if you're using official
release, thanks,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
