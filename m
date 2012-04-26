From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 14:12:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D860B@ORSMSX101.amr.corp.intel.com>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com>
 <1828884A29C6694DAF28B7E6B8A82373469D85A8@ORSMSX101.amr.corp.intel.com>
 <4F995001.7050306@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F995001.7050306-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Users seem to expect ibstat to show all rdma devices...

They why not change ibstat to use ibverbs or have it gather its data directly?  What other functionality does umad provide for RNICs? 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
