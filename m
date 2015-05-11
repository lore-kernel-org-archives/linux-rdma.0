From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/ipoib: Scatter-Gather support in connecte
Date: Mon, 11 May 2015 12:55:08 +0300
Message-ID: <20150511095507.GA7099@yuval-lab>
References: <1431244297-16371-1-git-send-email-yuval.shaia@oracle.com>
 <20150511023052.GC23806@cucumber.bridge.anchor.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150511023052.GC23806-ZVKTuMS7OOyXivEjC3tOQq8arWZNjzh+cd8/XO2csNs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 11, 2015 at 12:30:52PM +1000, Christian Marie wrote:
> Yuval Shaia wrote:
> > --- 8< ---
> >
> > I'd like to thank John Sobecki <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> and Christian Marie
> > <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org> for helping me with reviewing this patch.  I will be
> > glad if you can ACK it.
> >
> > --- 8< ---
> 
> ACK. I haven't been able to test, though. Lack of hardware at the moment.
> 
> I'd be interested to know how you've tested this.
Simply added debug printouts to see that SG is actually used then check that nothing breaks, i.e. i ran some (long) perf tests and some other network utilities (such as scp).
Any other ideas are welcome.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
