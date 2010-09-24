From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Maximum size for memory registration (ibv_reg_mr)
Date: Fri, 24 Sep 2010 15:47:52 -0700
Message-ID: <adamxr6ahd3.fsf@cisco.com>
References: <036401cb5c35$85829220$9087b660$@edu> <adar5giahvd.fsf@cisco.com>
	<037101cb5c39$b98036f0$2c80a4d0$@edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <037101cb5c39$b98036f0$2c80a4d0$@edu> (Bharath Ramesh's message
	of "Fri, 24 Sep 2010 18:42:10 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > max_mr_size returned by calling ibv_devinfo is 0xffffffffffffffff. Does this
 > mean the size is unlimited?

It means that the query function might be returning bad data.  What
adapter is it?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
