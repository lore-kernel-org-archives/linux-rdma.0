From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix missing device local_dma_lkey
Date: Mon, 20 Jul 2015 13:52:08 -0600
Message-ID: <20150720195208.GB24162@obsidianresearch.com>
References: <1437411276-22731-1-git-send-email-sagig@mellanox.com>
 <3095C235-676F-4A99-A27C-F2F332D9921F@oracle.com>
 <55AD2B65.4090006@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AD2B65.4090006-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 08:09:57PM +0300, Sagi Grimberg wrote:
> On 7/20/2015 8:08 PM, Chuck Lever wrote:
> >
> >On Jul 20, 2015, at 12:54 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
> >
> >>The mlx5 driver exposes device capability IB_DEVICE_LOCAL_DMA_LKEY
> >>but does not set the the device local_dma_lkey. This breaks
> >>rpcrdma drivers.
> >>
> >>Query and set this lkey when creating the device resources.
> >
> >Wow. This suggests no-one has been testing NFS/RDMA with mlx5? I
> >know I=E2=80=99m not (yet). Anyway, this makes sense.
>=20
> That's what I was wandering about.
>=20
> I just turned it on and it blew up... gracefully though :)

Ugh, good thing you caught this before I sent my cleanup:

https://github.com/jgunthorpe/linux/tree/remove-ib_get_dma_mr

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
