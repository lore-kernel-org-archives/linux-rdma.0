From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Sun, 17 Jan 2010 09:19:03 -0800
Message-ID: <adak4vghcoo.fsf@roland-alpha.cisco.com>
References: <4B12AA78.7090401@gmail.com>
	<ada8wbzi490.fsf@roland-alpha.cisco.com> <4B52D8A8.7060804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B52D8A8.7060804-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Alex Vainman's message of "Sun, 17
	Jan 2010 11:30:16 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > But we couldn't find another one without changing the API or changing
 > the kernel.

Changing which API?  Changing the kernel is a possibility of course.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
