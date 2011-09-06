From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Resolving IP addr to GID with librdmacm
Date: Tue, 6 Sep 2011 18:10:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E59C98@ORSMSX101.amr.corp.intel.com>
References: <loom.20110906T193153-584@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110906T193153-584-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramu <ramu.kavati-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Does IPoIB module depend on Subnet manager/Subnet Administration components
> for
> any service while resolving IP address to GID.

Yes - it relies on multicast groups having been setup and SA queries.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
