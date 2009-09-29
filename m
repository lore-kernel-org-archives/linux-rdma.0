From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iWCM: Do not call provider reject method with irqs disabled.
Date: Tue, 29 Sep 2009 12:39:09 -0500
Message-ID: <4AC2463D.9000101@opengridcomputing.com>
References: <20090928190328.26092.69566.stgit@build.ogc.int> <adaocotvhq4.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocotvhq4.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> Haven't looked closely... could you provide commentatry on why dropping
> the lock is safe here?  No chance of racing against something else?
>
> Anyway -ENOCHANGELOG
>
>  - R.
>   

Sorry Roland.  I'll add a changelog and repost.

The reason its ok to release the lock around the provide reject() call:

1) the provider will do nothing with this endpoint until the iwcm either 
accepts or rejects.

2) the lock is only released after the iwcm state is changed, so an 
errant iwcm user that is destroying -and- rejecting the connection 
concurrently will get a failure on one of the calls.


Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
