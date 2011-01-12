From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp warning
Date: Wed, 12 Jan 2011 14:42:21 -0500
Message-ID: <1294861341.15826.38.camel@lap75545.ornl.gov>
References: <adalj2q587i.fsf@cisco.com>
 <1294854748.15826.26.camel@lap75545.ornl.gov> <ada8vyq57bq.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <ada8vyq57bq.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-01-12 at 13:02 -0500, Roland Dreier wrote:
> > Out of curiosity, what version are you using? I've been using 4.4.5 and
>  > 4.5.1.
> 
> $ gcc --version
> gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5
> 
> (on x86-64).  Not sure what changed because I don't think I saw it
> before either.

Could you send the contents of drivers/infiniband/ulp/srp/.ib_srp.o.cmd
from a build showing the warning? And probably the .config as well -- I
suspect we're using different flags as even gcc 4.1.2 seems to be happy
for me.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
