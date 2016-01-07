From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Fix kernel panic on multicast flow
Date: Thu, 7 Jan 2016 10:03:28 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1601071002220.28791@east.gentwo.org>
References: <1452151688-7695-1-git-send-email-erezsh@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452151688-7695-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 7 Jan 2016, Erez Shitrit wrote:

> ipoib_mcast_restart_task calls ipoib_mcast_remove_list with the
> parameter mcast->dev. That mcast is a temporary (used as an iterator)
> variable that may be uninitialized.
> There is no need to send the variable dev to the function, as each mcast
> has its dev as a member in the mcast struct.

Reviewed-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
