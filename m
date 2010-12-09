From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_cm resource over use
Date: Thu, 9 Dec 2010 10:30:02 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1F52B@orsmsx501.amr.corp.intel.com>
References: <20101209175338.GA26902@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101209175338.GA26902@mtldesk30>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> the rdma_cm library opens all availabe devices and keeps them open
> even after binding to a specific device/port. This eats resources from
> other devices that would otherwise be available to other applications.
> Is there a way to avoid this? If not, maybe we should close all other
> devices after binfing?

The librdmacm documents that all RDMA devices remain open while the librdmacm is loaded (see rdma_get_devices).  Also, a listen doesn't need to be bound to any specific device, but the connection request will be.  Personally, I really don't see this as a major use of resources.

- Sean


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
