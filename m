From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: fix post_recv wq overflow check
Date: Thu, 07 Jan 2010 11:01:25 +0200
Message-ID: <4B45A2E5.2070301@voltaire.com>
References: <Pine.LNX.4.64.0912231727040.19295@zuben.voltaire.com>	<adapr5nt0rc.fsf@roland-alpha.cisco.com> <4B45913C.10405@Voltaire.com> <adaocl6qrjc.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocl6qrjc.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> Actually I was planning on sending it for 2.6.33, since it's so small and obvious and we're reasonable early in the cycle.  Not sure about -stable though -- has this been hit in practice?
I agree that it should go into 2.6.33, since its so small there's no 
reason to wait for 2.6.34. As for the being hit question: note that 
without there is both bug in the overflow check and creation of extra 
contention between the post recv and poll send cq flows, for ULPs that 
have their send cq different from the recv cq, e.g IPoIB, I came a cross 
this bug when reviewing the mlx4 posting code when during some profiling.

I wonder if the overflow check could be removed all together and be left 
to the ULP (kernel is trusted environment...) is there any risk in doing 
so? this way the WR posting code will not experience contention with the 
poll WC code on the CQ lock.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
