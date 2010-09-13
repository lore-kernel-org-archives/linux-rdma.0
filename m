From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2.6.37 09/11] RDMA/cxgb4: Support on-chip SQs.
Date: Mon, 13 Sep 2010 11:25:23 -0500
Message-ID: <4C8E5073.2020908@opengridcomputing.com>
References: <20100910161442.6829.91594.stgit@build.ogc.int>	<20100910161530.6829.89294.stgit@build.ogc.int>	<4C8A8DC1.4040302@opengridcomputing.com> <adaiq29wrjm.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiq29wrjm.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  I just emailed it out...

Steve.


On 9/13/2010 11:13 AM, Roland Dreier wrote:
>   >  Oops, cought this during regression testing:  The above line should be
>   >  indexing by wq->rq.size, not wq->sq.size.  This error caused
>   >  intermittent post failures and I missed it on my first round of
>   >  testing.
>
> Steve, can you send a fixed version of this patch?
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
