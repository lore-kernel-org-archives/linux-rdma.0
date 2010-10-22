From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address resolution
Date: Fri, 22 Oct 2010 17:59:59 +0200
Message-ID: <AANLkTi=fb3Z+i8Qs9Fbi4Eg-9wSY4R5jf0Fa30HL43jW@mail.gmail.com>
References: <20100826141851.GI8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826141851.GI8795@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> [...] Address resolution is done atomically in the
> case of a link local address or a multicast GID and otherwise -EINVAL=
 is
> returned. =A0mlx4 transport packets were changed too to accommodate f=
or IBoE.
> Multicast groups attach/detach calls dev_mc_add/remove to update the =
NIC's
> multicast filters.

This change log and also I assume the patch as well, deals alot with
multicast, however, patch 0/10 says "With these patches, IBoE
multicast frames may be broadcast as there is
currently no use of a L2 multicast group membership protocol." - does
this means some/much of the code added/changed by this patch is dead
code or not needed at this point?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
