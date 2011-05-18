From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Wed, 18 May 2011 18:13:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373FC13@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A@mail.gmail.com>
 <20110518170226.GA2595@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373FBC7@ORSMSX101.amr.corp.intel.com>
 <20110518180519.GA11860@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110518180519.GA11860-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The size is 3*64 + 1*32 so there is a 32 bit pad, thus we can rewrite
> it as:
> 
>         union {
>                 struct {
>                         uint64_t        remote_addr;
>                         uint32_t        rkey;
> 			uint32_t        xrc_remote_qpn;
>                 } rdma;
>                 struct {
>                         uint64_t        remote_addr;
>                         uint64_t        compare_add;
>                         uint64_t        swap;
>                         uint32_t        rkey;
> 			uint32_t        xrc_remote_qpn;
>                 } atomic;
>                 struct {
>                         struct ibv_ah  *ah;
>                         uint32_t        remote_qpn;
>                         uint32_t        remote_qkey;
>                 } ud;
>         } wr;
> 
> Without changing the size at all.

You need it in the normal send case as well, either outside of the union, or part of a new struct within the union.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
