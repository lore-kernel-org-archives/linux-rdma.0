From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Mellanox RDMA performance
Date: Fri, 6 Dec 2013 18:19:26 -0500
Message-ID: <CADPSxAhabc=NRbuCJ9rrQ3u1aj8JtcOKbhGdzewZepPhQA7JiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I had asked a question about RDMA performance here:
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg17483.html.
I got an answer that Connect X-3 cards can support a maximum of about
35 million operations per second.

Is number is unidirectional or bidirectional? For example, ignoring
PCIe issues, can an HCA issue 35M RDMA reads (to remote hosts) and at
the same time serve 35M RDMA reads (from remote hosts)? Or is 35M a
summed number?

I suspect that it is a summed number, but it will be great if someone
could confirm this.

--Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
