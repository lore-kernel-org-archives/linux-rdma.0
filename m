From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Notes on XRC
Date: Tue, 26 Mar 2013 15:55:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F368244@ORSMSX101.amr.corp.intel.com>
References: <51501991.5020105@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823736F367A8A@ORSMSX101.amr.corp.intel.com>
 <5151718A.6090907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5151718A.6090907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This is just a workaround I been considering in case using "hints" and
> asynchronous connection request can't work together. If I want to have
> servers and clients that need to be backward compatible with RC servers
> and clients. And assuming the old ones didn't used the private data in
> the connection request and in the accept. Than the presence of the
> private data will indicated that these are XRC enabled clients and servers.

I don't see how an app can 'just switch' from RC to XRC without having coded for the possibility of XRC.  XRC introduces too many new concepts.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
