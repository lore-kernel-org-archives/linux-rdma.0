From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 03/18] staging/rdma/hfi1: Add aeth name syndrome decode
Date: Fri, 20 Nov 2015 21:43:12 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259BDD83@fmsmsx120.amr.corp.intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
 <1447472236-622-3-git-send-email-jubin.john@intel.com>
 <20151120010940.GC11695@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151120010940.GC11695-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Add aeth name syndrome decode
> 
> Again, why?
> 

This fix is to enhance debugging.

The IBTA RC ACK contains an ACK extended transport header.

Part of that header is the syndrome field that qualifies the RC ACK as an ACK, NAK, or RNR NAK.

Without the patch here is the syndrome decode:
aeth syn 0x00

Here is the decode with the fix:
aeth syn 0x00 ACK

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
