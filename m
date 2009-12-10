From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: [PATCH] rdmaoe/libibverbs: handle binary compatibility
Date: Thu, 10 Dec 2009 13:57:11 -0800
Message-ID: <adaein2lcg8.fsf@roland-alpha.cisco.com>
References: <20091210170536.GA3229@mtls03>
	<20091210173353.GW1966@obsidianresearch.com>
	<20091210211455.GA5166@mtls03>
	<20091210214945.GP6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20091210214945.GP6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Thu, 10 Dec 2009 14:49:45 -0700")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > >  #define IB_USER_VERBS_MIN_ABI_VERSION  1
 > > -#define IB_USER_VERBS_MAX_ABI_VERSION  6
 > > +#define IB_USER_VERBS_MAX_ABI_VERSION  7
 >  
 > Whats this about? That seems like it needs a much bigger review,
 > changing the kernel ABI version instantly breaks every existing
 > libibverbs, shouldn't be done without alot of discussion!!

Yes, I've been meaning to bring this up earlier.

There was a time, long ago, when changing this ABI was maybe OK.  I
think even when I first designed the uverbs ABI, having this version
instead of capability bits was a goof.  But I don't have a time machine.

In any case I think at this point we need to stick with ABI version 6
will full backwards compat unless we really really can't.  And I don't
think the changes here are nearly drastic enough that we can't figure
out a way forward without breaking things.

 > Why do you have IBV_LINK_LAYER_UNSPECIFIED ? That seems pointless. Why
 > should existing kernels return UNSPECIFIED when we know they are
 > always IB. I'd say drop IBV_LINK_LAYER_UNSPECIFIED and set
 > IBV_LINK_LAYER_INFINIBAND to 0.

I prefer having the UNSPECIFIED.  Not a strong preference but my
reasoning is that if you have an old kernel that doesn't answer
anything, you're better off letting the app see that.  And there's no
reason why iWARP has to run over ethernet in principle.

Maybe I'm wrong but I don't like setting "don't know" magically to IB
behind the scenes.

 - R.
