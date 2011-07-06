From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA performance
 counters definitions
Date: Wed, 6 Jul 2011 08:51:39 -0700
Message-ID: <CAL1RGDWHYMQHbZWwkysqZ7TLrB_ZDJWSTC4YCqk1wpme_3+BrQ@mail.gmail.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1106161119120.12552@ogerlitz.voltaire.com>
 <4DFA10CC.5080002@mellanox.com> <35AAF1E4A771E142979F27B51793A4888838E71F03@AVEXMB1.qlogic.org>
 <BANLkTikpMWYaXB8Ne+FaLGHi2L5TUCNDkQ@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888838FEE740@AVEXMB1.qlogic.org>
 <4E133575.8040105@mellanox.com> <CAL1RGDX7U=PMjWadeS3Gp+xST56xJiK=qydwu1PMcvkfb7DcnA@mail.gmail.com>
 <CAJZOPZK3tT9gXP46ek-tO3xyvj7=eKyGJXBoim9uOMbJc4BtfQ@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888838FEE894@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888838FEE894-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The patch that is not yet approved is https://patchwork.kernel.org/patch/523041/
>
> The objections to date for the patch center on the use of reserved bits to key the existence of some vendor specific queries.

Hmm, I'm not a huge fan of that patch since as you say it uses bits
that the IB spec says are reserved.  I'd be more inclined to take Or's
patches which have gotten positive feedback from Sean, if we have to
choose.  Hal (and/or anyone else who has more insight into the IBTA
intentions for management architecture), what do you think of the
patch linked above?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
