From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: librdmacm: select() gives false positive on cm channel file descriptor
Date: Thu, 03 Jun 2010 12:31:52 -0700
Message-ID: <adafx13q5ef.fsf@roland-alpha.cisco.com>
References: <20100603190651.188C02270E@vis06.nas.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100603190651.188C02270E-PJ7uzvdTSdjyYnqMeUxRc+1ftBKYq+Ku@public.gmane.org> (Bryan Green's
	message of "Thu, 03 Jun 2010 12:06:51 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Green <bryan.d.green-NSQ8wuThN14@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Thanks for the advise about select.  In what way is select obsolete?

The crazy fd_set stuff that forces a big bitmap to be copied into the
kernel and scanned through there, and at the same set limits the number
of fds that can be handled.  poll() is essentially the same interface
made more efficient and with arbitrary limits removed.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
