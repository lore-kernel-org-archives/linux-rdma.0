From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and fork
Date: Fri, 24 Aug 2012 18:35:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8ADD4@ORSMSX101.amr.corp.intel.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
 <502A9039.4090505@us.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
 <1344968289.2101.36.camel@oc1677441337.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com>
 <1345239625.1128.20.camel@oc1677441337.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237346A89F70@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237346A89F90@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8A7A8@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW+QSXnfa5yvEsb7XqXMVbVVU6sz7BEKRPmc0tSYi8m9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDW+QSXnfa5yvEsb7XqXMVbVVU6sz7BEKRPmc0tSYi8m9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I don't think those mmap()s should be an issue with fork.... they are
> mapping adapter PCI space into userspace, but it should work across
> fork.

makes sense

Do you have any ideas on ways to identify what in the initialization paths might cause the problems?  (Assuming that is where the problem is.)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
