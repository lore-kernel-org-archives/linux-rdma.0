From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA Multicast APM
Date: Wed, 28 Jul 2010 09:12:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A911AA4A@orsmsx501.amr.corp.intel.com>
References: <004d01cb2e47$e816dfc0$b8449f40$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004d01cb2e47$e816dfc0$b8449f40$@com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nuwan Sanjeewa Abeysiriwardana <nuwansa-d0YwtTOpHbYQCxfLn1kDAA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

copying linux-rdma list

>                 We have done some native IB multicast  development. It's working fine at the moment.
> But I have no idea how to setup APM  for the IB multicast. How do we handle switch failover  with IB
> multicast. It's very helpful if you can give some information about the how  APM works with UD QPs.

APM doesn't apply to UD QPs.  For multicast, it's up to the SM to detect any switch issues and reconfigure the fabric so that multicast traffic continues to work.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
