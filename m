From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 09/18] staging/rdma/hfi1: Correctly limit VLs against
 SDMA engines
Date: Fri, 20 Nov 2015 14:59:51 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259BD6CD@fmsmsx120.amr.corp.intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
 <1447472236-622-9-git-send-email-jubin.john@intel.com>
 <20151120011017.GE11695@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151120011017.GE11695-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Correctly reduce the number of VLs when limited by the number of SDMA
> > engines.
> 
> why?  What does this "solve"?

The hardware has multiple egress mechanisms, SDMA and pio, and multiples of those.

These mechanisms are chosen using the VL (8)

The fix corrects a panic issue with one of the platforms that doesn't have enough SDMA (4) mechanisms for the typical number of VLs.

Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
