From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.35
Date: Mon, 17 May 2010 20:28:42 -0700
Message-ID: <adawrv1nb11.fsf@roland-alpha.cisco.com>
References: <adaiq6mo58m.fsf@roland-alpha.cisco.com>
	<7943A3B0D2C7416186D6A61FE071D640@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7943A3B0D2C7416186D6A61FE071D640-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Mon, 17 May 2010 12:58:59 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I just wanted to make sure that this didn't get dropped off the radar for 2.6.36
 > review.  I have a set of patches to add support for AF_IB to the rdma_cm.  At
 > this point, all received feedback has been incorporated.  I won't repost the
 > entire patch set unless requested, but it's also available from:
 > 
 > 	git://git.openfabrics.org/~shefty/rdma-dev.git af_ib

Sorry, yes, I forgot to add two more topics that, to be honest, I did
not even have a chance to start thinking about.  Namely this AF_IB stuff
and also the raw QP stuff for iWARP/datagram acceleration.  Again,
hopefully for 2.6.36.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
