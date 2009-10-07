From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: remove limitation on LSO header size
Date: Wed, 07 Oct 2009 15:45:16 -0700
Message-ID: <adaocoiombn.fsf@cisco.com>
References: <20090930090701.GA2385@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20090930090701.GA2385@mtls03> (Eli Cohen's message of "Wed, 30
	Sep 2009 11:07:01 +0200")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, general-list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > +	*blh = unlikely(halign > 64) ? 1 : 0;

This idiom of "(boolean condition) ? 1 : 0" looks odd to me... doesn't
(halign > 64) already evaluate to 1 or 0 anyway?  Does the unlikely()
actually affect code generation here?

With that said, see below...

 > +	int blh = 0;

I assume this initialization is to avoid a compiler warning.  But the
code is actually correct without initializing blh -- so I think that we
save a tiny bit of code by doing uninitialized_var() instead?

 > +			(blh ? cpu_to_be32(1 << 6) : 0);

...given that the only use of blh is as a flag to decide what constant
to use here, does it generate better code to make blh be __be32 and set
the value directly in build_lso_seg, ie do:

	*blh = unlikely(halign > 64) ? cpu_to_be32(1 << 6) : 0;

and then use blh without ?: in mlx4_ib_post_send...

 - R.
