From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Resolving IP addr to GID with librdmacm
Date: Wed, 24 Aug 2011 16:03:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E476D5@ORSMSX101.amr.corp.intel.com>
References: <loom.20110824T165557-959@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110824T165557-959-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramu <ramu.kavati-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In the code, it looks like during resolving IP addr to GID, one of the kernel
> module (ib_addr) is using neigh_lookup(..) to get the hardware address of the
> given IP.  I did not get the dependency on the module ib_ipoib to resolve
> remote
> IP addr to GID.  Am I missing anything here? Please explain.

The IP address is mapped to a hardware address, typically done using ARP for IPv4, which goes over the ipoib device.  The returned hardware address must be in the format defined by the ipoib protocol.  That format includes the GID as part of the hardware address.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
