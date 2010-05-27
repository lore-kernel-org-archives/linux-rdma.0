From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] IB/util madeye.c
Date: Thu, 27 May 2010 09:31:46 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E369@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D5D7@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D5D7-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Madeye is a debugging/monitoring tool for infiniband fabrics. When loaded,
> by default it will log copies of all MAD traffic to the system log. In
> addition, it can be configured to log only those MADs which have a
> particular class or a particular attribute id.

While I've found madeye to be very useful myself, it seems preferable for umad to support MAD snooping, so that a user space application could implement more complex filtering, monitoring, and reporting mechanisms.  Madeye could then be ported to user space.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
