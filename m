From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Linux DMA address
Date: Tue, 3 Jul 2012 07:34:41 -0700
Message-ID: <CAL1RGDXJSVrAsdYaajQT0sQq8RKwQf88Vofs3cZ0c+T7mucqcw@mail.gmail.com>
References: <OF0BBAC7B2.370E3DEF-ONC1257A2F.003DED12-C1257A2F.00407B62@de.ibm.com>
 <4FF1A7F0.10208@mellanox.com> <OF2C9BED9D.50BF4649-ONC1257A30.004A568D-C1257A30.004ADEF1@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF2C9BED9D.50BF4649-ONC1257A30.004A568D-C1257A30.004ADEF1-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 3, 2012 at 6:37 AM, Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
> 1.) Is it possible/allowed to call ib_dma_map_single() on Linux, same
> buffer address, size and dma_data direction, for two different ib devices?

Yes, this should be no problem.

> 2.) If this is possible, will the returned dma_addresses be the same? Any
> dependencies on the adapter model?

There is no guarantee about what the addresses will be.  For example
if the adapters are behind IOMMUs (eg Intel VT-d) then it is quite likely
the dma addresses will be different for each ib device.

As Or has said, ib_dma_xxx functions are pretty thin wrappers around
the normal dma api -- they're just there to handle ib devices like qib/ipath
that emulate dma in software.  So if you understand the dma api then
the same answer should apply to the ib_dma_ functions.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
