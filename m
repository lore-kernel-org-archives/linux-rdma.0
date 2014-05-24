From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] Clean index map on exit
Date: Sat, 24 May 2014 01:22:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373993078BC@ORSMSX109.amr.corp.intel.com>
References: <B9523649-97F2-4979-8590-F63788B4AC9D@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B9523649-97F2-4979-8590-F63788B4AC9D-hi6Y0CQ0nG0@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> librdmacm already has a cleanup function which releases all resources it
> holds. Missing from that cleanup are entries with struct index_map,
> which are dynamically allocated, whereas the map itself is declared
> static. Because librdmacm plays otherwise nicely with valgrind this
> patch aims to free the memory held by index map entries, mainly to
> reduce valgrind noise.
> This patch adds the function idm_free() to free all entries of an index
> map. A call to this function is added in the ucma_cleanup destructor.
> The ucma_idm struct index_map is cleaned using idm_free().
> There is another struct index_map in preload.c and rsocket.c, but there
> are no destructors yet and I don't feel competent enough to add them.

Instead of adding idm_free, I added count values to the index_map structure.  The allocated arrays are freed whenever the count drops to 0.  This should handle all three cases -- cma, preload, and rsocket.

I sent out a separate patch to address this.  Please let me know if you see any issues with it.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
