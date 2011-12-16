From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: checkpoint release of libibverbs/libmlx4
Date: Fri, 16 Dec 2011 11:43:29 +0200
Message-ID: <CAJZOPZLgxh_isUW42F09rPp=L2knWmX-oSsrrRjV7qy1QbBU0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 6, 2011 at 12:49 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
>> I want to do a checkpoint release of libibverbs with IBoE support
>> (ie what's in the tree already) and then get XRC in.

> This makes sense, could we add also that little patch to support FDR =
@
> http://marc.info/?l=3Dlinux-rdma&m=3D131805712306662&w=3D2 the =A0ker=
nel FDR
> patches are in place, already in.

Roland,

I realized that the latest releases for libibverbs / libmlx4 don't
contain support for

1. CX3 (one simple libmlx4 patch, committed)
2. FDR (one simple libibverbs patch, pending)
3. IBoE (set of patches, committed)

looks like checkpoint release is really needed here...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
