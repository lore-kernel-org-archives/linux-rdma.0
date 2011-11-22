From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Independent server management of Multicasting connections
Date: Tue, 22 Nov 2011 18:47:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9BD4D@ORSMSX101.amr.corp.intel.com>
References: <20111121071551.14306gf6ogr9z8yf@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9B9E9@ORSMSX101.amr.corp.intel.com>
 <20111122110030.112519gpho0ikta6@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9BD23@ORSMSX101.amr.corp.intel.com>
 <20111122112723.153527yw26bz6n4b@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111122112723.153527yw26bz6n4b-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Are there examples of how to create the multicast group using rdma_cm?

rdma_join_multicast will create the group if it does not exist.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
