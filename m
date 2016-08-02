From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] infiniband: shut up a maybe-uninitialized warning
Date: Tue, 02 Aug 2016 22:05:17 +0200
Message-ID: <5746036.amdJeiC7gv@wuerfel>
References: <20160704150659.2883024-1-arnd@arndb.de> <1470159925.18081.21.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470159925.18081.21.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tuesday, August 2, 2016 1:45:25 PM CEST Doug Ledford wrote:
> On Mon, 2016-07-04 at 17:06 +0200, Arnd Bergmann wrote:
> > The powerpc64 default configuration leads to warnings for the
> > infiniband
> > core code:
> > 
> > infiniband/core/cma.c: In function 'cma_get_net_dev':
> > infiniband/core/cma.c:1242:12: warning:
> > 'src_addr_storage.sin_addr.s_addr' may be used uninitialized in this
> > function [-Wmaybe-uninitialized]
> > 
> > The code looks correct to me, and I don't see the warnings on the
> > other architectures, so this is a dumb change to add an unneeded
> > initialization to the variables in order to shut up the warning.
> > 
> > Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> > Link: http://arm-soc.lixom.net/buildlogs/mainline/v4.7-
> > rc6/buildall.powerpc.ppc64_defconfig.log.passed
> 
> I thought about taking this, but I also looked over the code and it
> looks correct to me.  This is a semi-hot path in the connection bring
> up code, so I'm loathe to put in sizeof(struct sockaddr_storage) * 2 of
> needless memory writes.  So, I dropped this patch.  Hopefully, ppc64
> compiler will straighten its warnings out soon.

Ok, no worries. Linus just disabled the warning tree-wide for
all compilers, so it's gone from the autobuilder, and newer gcc
versions (4.9 or higher) should be fine too, even if someone
enables the warning manually or by passing W=1.

Thanks for having a look,

	Arnd

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
