From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: fix hazard of sending ibevent for unregistered device
Date: Fri, 28 Jan 2011 16:33:19 -0800
Message-ID: <AANLkTik-vL54K_EjBThWqTEvw+JJNXREEhnNoRM0_bV9@mail.gmail.com>
References: <20110125134916.6532.63603.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110125134916.6532.63603.stgit-YbU/o29LwNHN0uC3ymp8PA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> nes_port_ibevent() should not be called when nes IB device
> is not registered with IB core.
> Add missing checks of of_device_registered flag.

Thanks, applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
