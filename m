From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: memory sinhronization and replication
Date: Tue, 24 Dec 2013 10:12:35 +0400
Message-ID: <CACaajQvg0gwStW6mELvdJ1UWP5DOyDGRQEtQ51RLdxUAZxN6rA@mail.gmail.com>
References: <CACaajQvhEVZLqMQY8EOVpvoUT5cF6uLwXGqYJMfnmuqfxeykNw@mail.gmail.com>
 <CADPSxAgWwaO-4H4e3cWQnkt=xxEd20W-e=Bh8GUdE1oK5na5Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAgWwaO-4H4e3cWQnkt=xxEd20W-e=Bh8GUdE1oK5na5Qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/12/24 Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I am not sure if I understand your question correctly. Copying data
> between two machines is straightforward with RDMA: the verbs
> operations do exactly that.


Thanks. I need something like this:
Two servers write data to some storage (sata disks).
On OS level i have disk cache read/write, that i need to have on both
servers identical for failover.


-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
