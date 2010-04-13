From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA CM problems, ib_find_cached_gid() fails
Date: Tue, 13 Apr 2010 15:41:07 -0700
Message-ID: <CC1A47DBF3084F98B391E73238EAE221@amr.corp.intel.com>
References: <g2i3d2745531004131526gcfec6bc2pccbae15d55997e95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <g2i3d2745531004131526gcfec6bc2pccbae15d55997e95-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Mike M' <mike060677-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Putting in lots of printk messages, I see that the server machine
>indeed gets a connection request MAD, but that the
>ib_find_cached_gid() call inside of cma_acquire_dev() fails.
>
>Any ideas?

What kernel version are you using, and are you trying to connect using IPv4 or
IPv6 addresses?

Can you look at the GID passed into ib_find_cached_gid() and compare it against
the GIDs available in the system?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
