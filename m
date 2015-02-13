From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 14/22] IB/ipoib: remove unneeded locks
Date: Fri, 13 Feb 2015 18:59:18 +0200
Message-ID: <54DE2D66.6060300@mellanox.com>
References: <cover.1423703861.git.dledford@redhat.com> <3cd3c664adb2877317c8f684ee344749b2915e45.1423703861.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3cd3c664adb2877317c8f684ee344749b2915e45.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/12/2015 03:43 AM, Doug Ledford wrote:
> During the various work I've done on this, some extra locking has crept
> in when things weren't working right.  This is one of those spots.
> Remove the unneeded spinlocks.

we need a more concrete/precise text here explaining why these locking 
spots can be removed. What you wrote is too high level and can not 
really be used in future debugging/bisection and maintenance, sorry.

> The mutex is enough to protect against what we need to protect against.

but this is the very same mutex you are removing in a downstream patch 
of the series, isn't that?!

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
