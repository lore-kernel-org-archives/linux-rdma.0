From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/22] IB/ipoib: Fixups for multicast issues
Date: Thu, 12 Feb 2015 00:25:08 -0500
Message-ID: <54DC3934.3010401@mellanox.com>
References: <cover.1423703861.git.dledford@redhat.com>	 <54DC303C.2020207@mellanox.com> <1423716906.3424.74.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423716906.3424.74.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/11/2015 11:55 PM, Doug Ledford wrote:
> I tried, but the most appropriate squashes were things like patch 18 and
> 19 squashed into patch 3, and some other similar jumping around of
> patches.  The number of conflicts that created in both the original
> squash and the follow on patches was perverse.  So, since the original
> 20 patches as I submitted previously are what has gone through our QA, I
> left them as they were.  If I fixed them up and squashed them, and if
> some overlooked fixup failure snuck in there, it would invalidate all of
> that testing.

I see. Does this sequence bisect-able? namely the driver builds and 
functions after applying patch by patch? note this is hard requirement 
when modifying existing upstream drivers.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
