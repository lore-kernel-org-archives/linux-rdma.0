From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow
 steering
Date: Mon, 16 May 2016 08:53:27 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605160853050.23895@east.gentwo.org>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org> <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org> <cf61efc8-e426-dd7c-7065-e46bbfb323b0@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cf61efc8-e426-dd7c-7065-e46bbfb323b0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 13 May 2016, Doug Ledford wrote:

> >  	if (cmd.flow_attr.flags >= IB_FLOW_ATTR_FLAGS_RESERVED)
> >
>
> I'm not at all convinced this is the right thing to do.  Sniffing of
> packets is definitely a privileged operation.  Tcpdump needs to be run
> as root to do this on regular devices.  If not CAP_NET_ADMIN, then a
> root check seems appropriate.  CAP_NET_RAW does not seem sufficient for
> sniffing other people's packets.

CAP_NET_RAW is sufficient for tcpdump and this is not more than that.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
