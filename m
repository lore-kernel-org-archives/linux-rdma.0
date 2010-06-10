From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.35
Date: Thu, 10 Jun 2010 13:28:26 -0700
Message-ID: <ada4ohaljit.fsf@roland-alpha.cisco.com>
References: <adaiq6mo58m.fsf@roland-alpha.cisco.com>
	<4C0D778C.8070108@oracle.com> <adar5kgm64d.fsf@roland-alpha.cisco.com>
	<4C114223.1010309@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C114223.1010309-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> (Andy Grover's message of "Thu, 10
	Jun 2010 12:50:59 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > However, I haven't replied to these patches in detail but in general I
 > > don't like this approach of "pick a random vector" since it is
 > > non-deterministic and not likely to end up with an optimal result.

 > What is the optimal way to do this, if it isn't to spread CQs evenly
 > across all available vectors? (least attached vector != random.)

Since there is no way to know whether a given vector has a bunch of CQs
that generate very few events or maybe a single CQ that generates a
heavy load of events, the number of attached CQs is really pretty
useless as a basis to decide.  I think it's much better to try and
attach your CQ to a vector that is directed at the CPU where you want to
process the work.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
