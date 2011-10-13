From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Thu, 13 Oct 2011 10:23:33 -0700
Message-ID: <CAL1RGDVb7dwV8CSoUaWbAOjxkpL=pwpcQ3_8PGkXMksZtWNJNA@mail.gmail.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
 <20111011173929.GH26965@obsidianresearch.com> <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A98C@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW_usQ8o4FJzZqkmoZAvSTHBLZJuJ_YpsHL-=ErbgSw-A@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A9C0@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA@mail.gmail.com> <alpine.DEB.2.00.1110131212370.19960@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1110131212370.19960-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2011 at 10:17 AM, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org> wrote:
> There seems to be some stuff missing in the upstream code compared to the
> OFED releases:
>
> 1. Raw ethernet support (IB_QPT_RAW_ETH) is missing.
>
> 2. MLX4_IB_QP_BLOCK_LOOPBACK is broken it seems? All packets are fed back
> via loopback?

Clean reviewed patches for this are where?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
