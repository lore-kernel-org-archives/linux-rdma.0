From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx5: Implement new initialization sequence
Date: Wed, 31 Jul 2013 00:03:56 +0300
Message-ID: <CAJZOPZLj63B6F5zR=KTHSSg9+50sus2bTHCqfD7Lss8uftfOug@mail.gmail.com>
References: <20130718123108.GA6777@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130718123108.GA6777@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Roland Dreier\"" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 18, 2013 at 3:31 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Introduce enbale_hca and disable_hca commands to signify when the driver starts
> or ceases to operate on the device.
> In addition the driver will use boot and init pages count; boot pages is
> required to allow firmware to complete boot commands and the other to complete
> init hca. Command interface revision is bumped to 4 to enforce using supported
> firmware.

Roland, haven't seen a response from you for about 2 weeks. Its
critical that the first upstream release that includes the mlx5 driver
will use this initilization sequence. Its mlx5_core patch, do you want
it to go through netdev/Dave?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
