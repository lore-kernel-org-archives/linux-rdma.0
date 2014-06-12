From: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nfs-rdma performance
Date: Thu, 12 Jun 2014 13:54:13 -0600
Message-ID: <CADvaNzXHOafuzav9RwB2SHXma7EUCxMQX6sNEL6r5-a_e37pLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Awesome work on nfs-rdma in the later kernels!  I had been having
panic problems for awhile and now things appear to be quite reliable.

Now that things are more reliable, I would like to help work on speed
issues.  On this same hardware with SMB Direct and the standard
storage review 8k 70/30 test, I get combined read & write performance
of around 2.5GB/sec.  With nfs-rdma it is pushing about 850MB/sec.
This is simply an unacceptable difference.

I'm using the standard settings -- connected mode, 65520 byte MTU,
nfs-server-side "async", lots of nfsd's, and nfsver=3 with large
buffers.  Does anyone have any tuning suggestions and/or places to
start looking for bottlenecks?

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
