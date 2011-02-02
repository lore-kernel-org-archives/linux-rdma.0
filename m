From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: re librdmacm-devel dependency on librdmacm
Date: Wed, 2 Feb 2011 07:24:26 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC0C1C2C@orsmsx501.amr.corp.intel.com>
References: <4D4934FA.8070905@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D4934FA.8070905-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I just realized the librdmacm-devel (version 1.0.8-5.el5 is installed on
> the system I hit that) is dependent on librdmacm, and wasn't sure if its
> a bug or a feature... the dependency is created through
> /usr/lib64/librdmacm.so which is soft link to the obj file installed by
> librdmacm.

What is librdmacm-devel?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
