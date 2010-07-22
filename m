From: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH] rdma/ib_cm: check LAP state before sending an MRA
Date: Thu, 22 Jul 2010 08:43:19 -0700
Message-ID: <20100722154319.GQ28497@sgi.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAEF8@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAEF8-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 21, 2010 at 04:36:52PM -0700, Hefty, Sean wrote:
> ...
> Josh or Arthur, can either of you confirm if this patch fixes the 
> crashes that you've seen?
> 

I can't. It's been practically impossible for us to reproduce.
(Only our customer seems to have the magic recipe.) 

-- 
Arthur
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
