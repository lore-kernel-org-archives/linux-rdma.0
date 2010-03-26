From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 13:29:09 -0500
Message-ID: <4BACFCF5.6030501@opengridcomputing.com>
References: <4BACD985.1070906@opengridcomputing.com>	<DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com>	<4BACE28A.2080409@opengridcomputing.com> <adazl1vxb7p.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazl1vxb7p.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Roland Dreier wrote:
> We need a way to "revoke" that
> mmap and have it point at a dummy page until userspace releases it --
> and last I looked I wasn't sure how to do that.

do_mremap()?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
