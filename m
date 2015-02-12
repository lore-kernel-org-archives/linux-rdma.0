From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/ipoib: don't queue a work struct up twice
Date: Thu, 12 Feb 2015 23:35:57 +0200
Message-ID: <54DD1CBD.1050503@mellanox.com>
References: <cover.1423703861.git.dledford@redhat.com>	 <30a5bd6461381448c52af0d7408dbc14da9ac4d0.1423703861.git.dledford@redhat.com>	 <54DCF20C.3040704@mellanox.com> <1423770436.3387.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423770436.3387.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/12/2015 09:47 PM, Doug Ledford wrote:
> So, I'll keep a new branch and this branch, and I'll reorder things (like the singleton fix you brought
> up in another email being first) and squash things, and when I get done,
> I'll do a diff between the two branches to make sure that there are no
> logical differences.  That should avoid invalidating all of the
> testing/QE work that has already been done on this patchset.

yes, lets do that, for example, patches 1-21 touch 56 times the 
mcast_mutex and patch #22 removes that mutex all together, this is 
nightmare for future bisection and maintenance. Please post the 
revised/shorter series once you have it to the list and specify the 
branch too.

> In the meantime, Erez can work off of these patches knowing the end result will be the same either way.
We are almost one week into the 3.20 merge window and our WW (Sun-Thu) 
is pretty much done. Erez will try to give some post-WW feedback but 
next week is on a well-pre-planned OOO -- I'm really not sure what 
should we do here. If you have the squashed patches by the end of this 
week, and our regression system runs them early next week maybe we can 
ack them.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
