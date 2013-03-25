From: Grant Grundler <grundler-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: odd use of WARN_ON() in ib_srpt.c
Date: Mon, 25 Mar 2013 16:48:40 -0700
Message-ID: <CANEJEGvArsbMitJENhFQ4HPCfmAC=PGz4_J2d9JmJVQS4eKiUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Stumbled across this in 3.4 kernel but still exists in 3.9-rc3:

fgrep -n WARN_ON ./drivers/infiniband/ulp/srpt/ib_srpt.c
...
1377:           WARN_ON("ERROR: unexpected command state");
...

This "works" but intent is more obvious with something like:
    WARN(1, "Unexpected command state (%d)", state);

Thoughts?

thanks,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
