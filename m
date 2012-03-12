From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-3.3 0/6] IB: set of fixes and additions
Date: Mon, 12 Mar 2012 18:29:19 +0200
Message-ID: <4F5E245F.3070303@mellanox.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/11/2012 6:52 PM, Or Gerlitz wrote:
> This patch comes to address the long pending patch for 4k mtu
> along the lines of what was requested over the last review
> [PATCH 4/6] net/mlx4: allow for dynamic mtu configuration for IB ports
>
> This patch is simple and comes to unify the approach for checksum
> indication with possible / hopefully soon changes in libibverbs
> [PATCH 5/6] IB: change CQ TCP/IP checksum offload mark to use bit flag indication instead of integer
>
> This patch extends the IPoIB child scheme, and will serve as
> a building block when using IPoIB in the Virtualization space.
> [PATCH 6/6] IB/ipoib: add support for clones / multiple childs on the same partition
>

Hi Roland,

I see that you've picked patches 1-3 to for-next, thanks! as for the 
rest of the patches, well, I submitted this series on Nov 1st, 2011 and 
since then haven't heard from you. So 3.3 is on rc7 now which means we 
don't have much time, for this to be reviewed towards 3.4 - so I'd like 
to get feedback and fix if needed.

Specifically, the 4k mtu thing for mlx4 is pending over this list for 
about two years now, not that if I were you I would accepted V0... but I 
have changed it along the lines of what you asked and now adopted that 
to SR-IOV, so... awaiting your feedback. If you somehow lost track of 
patches 4-6 they are @

4/6 4k mtu http://marc.info/?l=linux-rdma&m=132630178816757&w=2
5/6 csum flag bit http://marc.info/?l=linux-rdma&m=132630196616819&w=2
6/6 ipoib clones http://marc.info/?l=linux-rdma&m=132630202116857&w=2

thanks,


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
