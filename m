From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI V5 01/10] RDMA/core: Refactor IDR to be per-device
Date: Fri, 28 Oct 2016 22:53:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0A445F@ORSMSX109.amr.corp.intel.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477579398-6875-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The current code creates an IDR per type. Since types are currently
> common for all vendors and known in advance, this was good enough.
> However, the proposed ioctl based infrastructure allows each vendor
> to declare only some of the common types and declare its own specific
> types.
> 
> Thus, we decided to implement IDR to be per device and refactor it to
> use a new file.

I think this needs to be more abstract.  I would consider introducing the concept of an 'ioctl provider', with the idr per ioctl provider.  You could then make each ib_device an ioctl provider.  (Just embed the structure).  I believe this will be necessary to support the rdma_cm, ib_cm, as well as devices that export different sets of ioctls, where an ib_device isn't necessarily available.

Essentially, I would treat plugging into the uABI independent from plugging into the kernel verbs API.  Otherwise, I think we'll end up with multiple ioctl 'frameworks'.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
