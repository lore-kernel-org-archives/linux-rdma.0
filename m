From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memory sinhronization and replication
Date: Mon, 23 Dec 2013 15:08:46 -0500
Message-ID: <CADPSxAgWwaO-4H4e3cWQnkt=xxEd20W-e=Bh8GUdE1oK5na5Qw@mail.gmail.com>
References: <CACaajQvhEVZLqMQY8EOVpvoUT5cF6uLwXGqYJMfnmuqfxeykNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQvhEVZLqMQY8EOVpvoUT5cF6uLwXGqYJMfnmuqfxeykNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Vasiliy,

I am not sure if I understand your question correctly. Copying data
between two machines is straightforward with RDMA: the verbs
operations do exactly that.

There are tutorials for this online. A good one is
http://thegeekinthecorner.wordpress.com/2013/02/02/rdma-tutorial-pdfs/.

For more example programs, look into the examples folder of libibverbs
and librdmacm.

--Anuj

On Mon, Dec 23, 2013 at 2:34 PM, Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org> wrote:
> Hi all. Does anybody knowns how create using rdma driver to share
> memory from two servers?
> For example - i need memory from srv1 copied to srv2 and srv2 to srv1 ?
> If nobody knowns, can somebody share to me info/link for docs that can
> explain me that function/ subsystems i need to know/use to create such
> thing?
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
