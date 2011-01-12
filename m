From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp warning
Date: Wed, 12 Jan 2011 16:07:40 -0500
Message-ID: <1294866460.15826.41.camel@lap75545.ornl.gov>
References: <adalj2q587i.fsf@cisco.com>
 <1294854748.15826.26.camel@lap75545.ornl.gov> <ada8vyq57bq.fsf@cisco.com>
 <1294861341.15826.38.camel@lap75545.ornl.gov> <adaoc7l52hy.fsf@cisco.com>
 <adak4i952bk.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <adak4i952bk.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-01-12 at 14:50 -0500, Roland Dreier wrote:
> > Attached -- I'm using kind of a minimal config for build testing, so
>  > maybe I have some strange optimization enabled (CONFIG_CC_OPTIMIZE_FOR_SIZE=y?)
> 
> Indeed... unsetting CONFIG_CC_OPTIMIZE_FOR_SIZE seems to get rid of the warning.

Pushed the uninitialized_var change to

git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git srp-lock-scaling-warning
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
