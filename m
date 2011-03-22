From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] Adding Congestion Control definitions.
Date: Tue, 22 Mar 2011 10:23:27 +0200
Message-ID: <20110322082327.GB5062@calypso.voltaire.com>
References: <20110321162017.GA5062@calypso.voltaire.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC7B902@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC7B902-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:37 Mon 21 Mar     , Hefty, Sean wrote:
> > +#undef DEBUG
> > +#define DEBUG   if (ibdebug)    IBWARN
> 
> I didn't see where this was used, but in general this sort of definition may not work.  It can incorrectly associate a 'else' class with the if (ibdebug) statement, rather than the intended statement.

You are right. These lines shouln't be here at the first place. I'll review
the patch and resend.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
