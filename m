From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 07/16] IB/core: Introduce counter set query
 verb
Date: Fri, 20 Oct 2017 05:48:44 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1710200547100.10736@nuc-kabylake>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com> <1508424118-27205-8-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-8-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Oct 2017, Yishai Hadas wrote:

> A counter set must be first attached to an IB object in order to
> be queried for its underlay counters, downstream patches will
> present bind and query methods for flow counters.
> The user has an option as part of the query verb to force reading
> the up-to-date hardware values instead of reading some cached
> values by using the IB_COUNTER_SET_FORCE_UPDATE flag.

What does "cached" mean in this context? Accurate to the last second? Or
just return what was returned earlier? Semantics look a bit unclear to me.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
