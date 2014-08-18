From: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx5 + SRP: max_qp_sz mismatch
Date: Mon, 18 Aug 2014 17:20:29 -0600
Message-ID: <CADvaNzWGThMx1gMYfheFVwHzk10+8KWmAPkYZ1_FxArhdmri8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have a client machine that is trying to establish an SRP connection,
and it is failing due to an ENOMEM memory allocation error.  I traced
it down to the max_qp_sz field -- the mlx5 limits this to 16384 but
the request wants 32768.

I spent some time trying to figure out how this limit is set, but it
isn't quite obvious.  Is there a driver parameter I can set, or a hard
coded limit somewhere?

I'm using Ubuntu 14.04 and targetcli on the target side, Windows
2008r2 and WinOFED on the client side.

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
