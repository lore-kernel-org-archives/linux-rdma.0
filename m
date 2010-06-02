From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: fixing compilation issues in some header files
Date: Wed, 2 Jun 2010 04:03:14 +0300
Message-ID: <20100602010314.GZ28549@me>
References: <4BAA34B2.9060808@dev.mellanox.co.il>
 <4C04F5E7.8030904@dev.mellanox.co.il>
 <20100601192205.GV28549@me>
 <4C057940.1020106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C057940.1020106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 00:18 Wed 02 Jun     , Yevgeny Kliteynik wrote:
> >
> > AFAIR (anytype *) to (void *) casting is not needed (doing implicitly)
> > in C and this is already part of some basic standards.
> 
> True, but the problem is not (anytype *) to (void *) casting.
> It's the other way around: (void *) to (anytype *) casting.

It is the same meaning. Otherwise it would be useless.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
