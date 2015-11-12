From: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 12/13] staging/rdma/hfi1: Read EFI variable for device
 description
Date: Thu, 12 Nov 2015 12:31:51 +0000
Message-ID: <4AF12E8016D2BF46BCDFCE8FAA77A3580BC1C5EF@FMSMSX102.amr.corp.intel.com>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
 <1447227213-15122-12-git-send-email-jubin.john@intel.com>
 <20151111084439.GA18797@mwanda>
 <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19F69@FMSMSX102.amr.corp.intel.com>
 <20151111143921.GG18797@mwanda>
 <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19FC8@FMSMSX102.amr.corp.intel.com>
 <20151111172411.GA20481@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151111172411.GA20481-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Wednesday, November 11, 2015 11:24 AM

> > If you move the variables to the top and have the early return as you suggest,
> then in some CONFIG cases, there will be all those automatic variables declared
> but they are never used - the compiler has short-circuited the rest of the
> function.  Will not the compiler complain about unused variables in those cases?
> That is the situation I was trying to avoid.
> 
> Try it and see (hint, I don't think so...)

I tested this - you are correct, no compiler warnings.  Looks like my fears were premature.  The failure logic will be inverted per Dan's comments.


Dean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
