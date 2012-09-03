From: Alex Couvrard <acouvrard2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: rsocket library and dup2()
Date: Mon, 3 Sep 2012 17:31:51 +0000
Message-ID: <CAKb08J+ZApm-GXGUu--NZV31PvGK-tRrqPGFU4aMhWC50nmYow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I found the following code in dup2():

	oldfdi = idm_lookup(&idm, oldfd);
	if (oldfdi && oldfdi->type == fd_fork)
		fork_passive(oldfd);

In that code the file descriptor type ("type") is compared with a fork
state enum value ("fd_fork"). Is that on purpose ??

Merci,

Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
