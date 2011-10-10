From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] net/mlx4_core: remove module param controlling the
 vlan table size
Date: Mon, 10 Oct 2011 10:00:04 -0700
Message-ID: <CAG4TOxNaQicA6ExuNsw8V95mJPD+AQX5Wrfg+rCoBxdr2E+2ww@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com> <alpine.LRH.2.00.1110101055050.11243@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101055050.11243-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -static int log_num_vlan;
> -module_param_named(log_num_vlan, log_num_vlan, int, 0444);
> -MODULE_PARM_DESC(log_num_vlan, "Log2 max number of VLANs per ETH port (0-7)");

Can we really do this?  Doesn't this break anyone who has this
option configured in modprobe.conf?

This is one reason why I hate adding module parameters -- you can't
just delete them later like this.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
