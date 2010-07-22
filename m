From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Thu, 22 Jul 2010 11:18:51 +0300
Message-ID: <4C47FEEB.5010805@Voltaire.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com>	<20100720001436.GH7920@obsidianresearch.com> <4C454F80.1060808@Voltaire.com>	<4C45E701.7030501@opengridcomputing.com> <4C47053B.3000802@Voltaire.com> <4C4716D8.2040902@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4716D8.2040902-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve Wise wrote:
> Actually the dst entry ref/deref is really done in iw_cxgb3.  The
> dst/neigh entries are referenced in iwch_connect() and pass_accept_req()
> by calling ip_route_output() via find_route(). 

okay, I see now (more or less) how this part works, thanks for the pointer.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
