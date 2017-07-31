From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 6/6] ibacm: Support systemd socket activation
Date: Mon, 31 Jul 2017 20:42:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB16373A@ORSMSX109.amr.corp.intel.com>
References: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501532745-28378-7-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501532745-28378-7-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This lets systemd create the socket (to the admin's specifications)
> and starts ibacm when something connects to it.
> 
> We are using this to improve boot ordering by ensuring that any
> rdma_cm clients that would use ibacm block until ibacm is started up
> properly.
> A user could also use this to demand start ibacm, but that means it
> would not plug into kernel RMDA local services for caching.
> 
> For security, the socket will be created on the lo interface by
> default.
> The admin can change this back to the old daemon behavior with a
> systemd drop in.

Calling this change out to increase visibility.

The series looks fine to me, and I don't have any issues.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
