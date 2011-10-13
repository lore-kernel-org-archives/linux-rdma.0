From: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED
 libraries
Date: Thu, 13 Oct 2011 12:17:22 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1110131212370.19960@router.home>
References: <alpine.DEB.2.00.1110110900290.3388@router.home> <20111011173929.GH26965@obsidianresearch.com> <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237316E6A98C@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW_usQ8o4FJzZqkmoZAvSTHBLZJuJ_YpsHL-=ErbgSw-A@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237316E6A9C0@ORSMSX101.amr.corp.intel.com> <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-549897652-1318526243=:19960"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-549897652-1318526243=:19960
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 13 Oct 2011, Roland Dreier wrote:

> > My latest patches are at:
> >
> > =A0 =A0 =A0 =A0git://git.openfabrics.org/~shefty/rdma-dev.git xrc
>
> So I went through this and merged it to my tree (pretty much only conflic=
ts
> from 3.0->3.1-rc fixed, commit log changes and other minor cleanups).

We got the XRC support via the for-next branch on github. Is that current?

> The result is pushed out to my github  for-next branch, with the
> expectation that I'll ask Linus to pull for 3.2.
>
> However I do have one question: the last patch
> ("RDMA/uverbs: Export ib_open_qp() capability to user space" in
> my tree) adds IB_USER_VERBS_CMD_OPEN_QP but I don't
> see any driver add that to its uverbs_cmd_mask... does this work?
>
> Thanks, Roland

There seems to be some stuff missing in the upstream code compared to the
OFED releases:

1. Raw ethernet support (IB_QPT_RAW_ETH) is missing.

2. MLX4_IB_QP_BLOCK_LOOPBACK is broken it seems? All packets are fed back
via loopback?

---1463811839-549897652-1318526243=:19960--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
