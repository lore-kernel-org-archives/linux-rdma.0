From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.35
Date: Wed, 09 Jun 2010 11:08:02 -0700
Message-ID: <adar5kgm64d.fsf@roland-alpha.cisco.com>
References: <adaiq6mo58m.fsf@roland-alpha.cisco.com>
	<4C0D778C.8070108@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C0D778C.8070108-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> (Andy Grover's message of "Mon, 07
	Jun 2010 15:49:48 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Please also pick up the 3-patch set "Least attached vector support"
 > from Yevgeny on 2010-5-13? RDS changes depend on these.

It's now post -rc2, so these obviously wait for 2.6.36 at best.

However, I haven't replied to these patches in detail but in general I
don't like this approach of "pick a random vector" since it is
non-deterministic and not likely to end up with an optimal result.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
