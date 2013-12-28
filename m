From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: IPoIB and STP
Date: Sat, 28 Dec 2013 12:08:35 +0100
Message-ID: <CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ@mail.gmail.com>
References: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
i'm trying to configure a redundant IPoIB network.
Obviously, IB switches doesn't talk IP and so doesn't have STP support.

How can I interconnect two different switches with multiple cables and
avoid loops?

For example:
http://pastebin.com/raw.php?i=w8ySRibG

To have a fully redundant network, I have to interconnect switch1 and
switch2 at least with 2 cables and enable STP to avoit loops

Is OpenSM smart enough to detect a multiple link and shutdown one port
automatically (doing the same as STP) ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
