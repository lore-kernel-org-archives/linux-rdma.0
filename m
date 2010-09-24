From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Maximum size for memory registration (ibv_reg_mr)
Date: Fri, 24 Sep 2010 15:36:54 -0700
Message-ID: <adar5giahvd.fsf@cisco.com>
References: <036401cb5c35$85829220$9087b660$@edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <036401cb5c35$85829220$9087b660$@edu> (Bharath Ramesh's message
	of "Fri, 24 Sep 2010 18:12:05 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Is there any limit on the maximum size of memory that can be registered
 > using ibv_reg_mr. I am using OFED-1.4.2 stack, and when I try to pass a size
 > greater than 16GB ibv_reg_mr returns NULL. The total amount of physical
 > memory on the node is 48GB, max locked memory(ulimit -l) is set to
 > unlimited.

The limit depends on the HCA.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
