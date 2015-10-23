From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 14/22] staging/rdma/hfi1: Implement Expected Receive
 TID caching
Date: Fri, 23 Oct 2015 06:53:37 +0300
Message-ID: <20151023035337.GT7340@mwanda>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
 <1445307097-8244-15-git-send-email-ira.weiny@intel.com>
 <20151022104158.GL7340@mwanda>
 <20151022231819.GB4019@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151022231819.GB4019-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2015 at 07:18:19PM -0400, ira.weiny wrote:
> This follows the rest of the style of the case statement in this function.  We
> prefer to leave this as is for a number of reasons.
> 
> 1) This is consistent with the coding style elsewhere in this driver.

Don't try to match existing style if it is wrong.  If 99 lines are
consistent and 1 line is correct style then at least that's better than
no lines being correct.  I am worried that you will feel you have to do
this the wrong way forever for a silly reason...

> 2) It is functionally equivalent.

It is a style issue and I only complained about it because in the
next lines the bad style causes a bug.  If anyone finds this kind of
info leak in released code, then we always give them a CVE for it btw.
It's a headache.


> 3) I have a long list of patches which need to be processed and this may cause
>    later merge conflicts.
> 

Yes, that's fine.  I'm not insisting that you redo everything because of
a style issue.

Let me explain a little more why success handling is an anti-pattern.
Failure handling looks like this:

	ret = one();
	if (ret)
		return ret;
	ret = two();
	if (ret)
		goto undo_one;
	ret = three();
	if (ret)
		goto undo_two;

	return 0;

undo_two:
	undo_two();
undo_one:
	undo_one();
	return ret;

In this example the success path is always at indent level one.  The
code is a series of statements with no if conditions or indenting.  This
is how most kernel code looks.

With success handling it looks like:

	ret = one();
	if (!ret) {
		ret = two();
		if (!ret)
			ret = three();
	}
	return ret;

It is fewer lines but it is way more complicated.  It very quickly
starts to bump into the 80 character limit.

regards,
dan carpenter


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
