From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Thu, 26 May 2011 00:05:06 +0300
Message-ID: <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
	<BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Is the issue that we trade off VL cap for MTU?

yes, this is it

> [...] however I still think needing to set this with a module parameter kind of
> sucks for the end user.  Can we think of a better way to handle this?

with the above @ hand, setting mtu cap of 4k w.o an ability of
reducing that to 2k, makes the patch distruptive for users that do
need eight VLs. Maybe it would be easier for the common user if turn
on the module param by default.

> Does anyone really care about max VL cap with 2K MTU?

I'm not with you... can you elaborate a little further here? the
current HW generation support four VLs with 4k mtu, newer HW might
support more.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
