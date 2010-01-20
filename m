From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: fix post_recv wq overflow check
Date: Wed, 20 Jan 2010 17:47:09 +0200
Message-ID: <4B57257D.7020102@voltaire.com>
References: <Pine.LNX.4.64.0912231727040.19295@zuben.voltaire.com>	<adapr5nt0rc.fsf@roland-alpha.cisco.com> <4B45913C.10405@Voltaire.com>	<adaocl6qrjc.fsf@roland-alpha.cisco.com> <4B45A2E5.2070301@voltaire.com>	<adamy0kpo1m.fsf@roland-alpha.cisco.com> <4B55D441.5050000@voltaire.com> <ada8wbugjio.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada8wbugjio.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> In other words this check catches common bugs and makes them a gazillion times easier to find and fix.  So unless the performance impact is extreme, I'm inclined to leave it
okay, lets leave this like that for unless someone comes with 
performance data that shows this is really a bottleneck.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
