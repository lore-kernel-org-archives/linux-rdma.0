From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB core sysfs: Add port_xmit_wait_counter V2
Date: Fri, 8 Jul 2016 09:12:24 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607080911350.3887@east.gentwo.org>
References: <alpine.DEB.2.20.1607071231550.20276@east.gentwo.org> <f77b903a-75d5-b7bf-3814-9efa3c627996@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f77b903a-75d5-b7bf-3814-9efa3c627996-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 8 Jul 2016, Hal Rosenstock wrote:

> I'm not following the relationship of _counter field to the offset other
> than they are combined in the index and then I don't see counter part of
> index ever being used. So it looks to me like _counter can be
> deprecated/removed which is what Roland wrote in the thread you
> referenced below.

Yup. I think so too. But the rest of the discussion refers to some bit
that correlates with _counter. There may be something I missed.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
