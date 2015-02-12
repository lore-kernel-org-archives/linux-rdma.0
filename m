From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 19/22] IB/ipoib: make sure we reap all our ah on shutdown
Date: Thu, 12 Feb 2015 20:35:09 +0200
Message-ID: <54DCF25D.3050307@mellanox.com>
References: <cover.1423703861.git.dledford@redhat.com> <14ee2e7737123c7d37465ac52be5c026240c9985.1423703861.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14ee2e7737123c7d37465ac52be5c026240c9985.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 02/12/2015 03:43 AM, Doug Ledford wrote:
> The introduction of garbage collection for neighbors in the ipoib stack
> caused a leak of resources.  In particular, an ah can have a refcount
> from a mcast struct, from a neigh struct, and from a path struct.  When
> we put an ah ref, the ah gets moved to a dead list to be reaped later if
> the refcount goes to 0.
see my reply on this patch in it's singleton version which you sent 
couple of weeks ago
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
