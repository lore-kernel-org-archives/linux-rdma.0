From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-3.14] IB/mlx4: Report using RoCE IP based gids in port caps
Date: Thu, 6 Feb 2014 23:07:32 -0800
Message-ID: <CAG4TOxOS8iM2VPk_GB8nR3AUkwXgN8DpGLLVtTOT6HtgO=SH4A@mail.gmail.com>
References: <1391356314-3963-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391356314-3963-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 2, 2014 at 7:51 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> For user-space RoCE UD QPs we need to know the GID format that the
> kernel uses, e.g when working over older kernels. For that end, add
> new port capability IB_PORT_IP_BASED_GIDS and report it when a port
> query is issued.

I'm a little worried here.  Does old libibverbs (which doesn't know
anything about this flag) still work on a new kernel with the IP-based
GIDs?  Or have we broken ABI?

Also why does only mlx4 get modified here?  Didn't we modify ocrdma to
use IP-based GIDs too?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
