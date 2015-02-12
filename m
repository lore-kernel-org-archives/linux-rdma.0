From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/ipoib: don't queue a work struct up twice
Date: Thu, 12 Feb 2015 20:33:48 +0200
Message-ID: <54DCF20C.3040704@mellanox.com>
References: <cover.1423703861.git.dledford@redhat.com> <30a5bd6461381448c52af0d7408dbc14da9ac4d0.1423703861.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <30a5bd6461381448c52af0d7408dbc14da9ac4d0.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/12/2015 03:43 AM, Doug Ledford wrote:
> In b2d408f78b3 (IB/ipoib: make delayed tasks not hold up everything) I
> added the ability to have some joins processed around delayed joins.
> Because the join task processes one join at a time, we needed to queue
> the task to run again immediately and then again at the appropriate
> delay time.  I didn't think about the fact that our work struct can only
> be on the workqueue once at a given time and instead tried to queue the
> same struct up twice.  Instead, kick the queue again immediately on a
> delayed restart attempt, when the task sees that it has nothing to do
> but delayed work, it will pick the shortest work item and queue a delay
> equal to its expiration.  Finally, in case we have delayed work, in the
> send_mcast routine we need to cancel any delayed work before kicking the
> thread immediately.
This is strictly a fix to a downstream patch of the series, lets squash 
it there somehow, I see no point to submit
commit that has a bug and later a fix in the same series.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
