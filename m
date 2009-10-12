From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: remove limitation on LSO header size
Date: Mon, 12 Oct 2009 10:03:03 -0700
Message-ID: <adaiqekh7eg.fsf@cisco.com>
References: <20090930090701.GA2385@mtls03> <adaocoiombn.fsf@cisco.com>
	<20091011100015.GB4929@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20091011100015.GB4929@mtls03> (Eli Cohen's message of "Sun, 11
	Oct 2009 12:00:15 +0200")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, general-list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > >  > +	*blh = unlikely(halign > 64) ? 1 : 0;

 > > This idiom of "(boolean condition) ? 1 : 0" looks odd to me... doesn't
 > > (halign > 64) already evaluate to 1 or 0 anyway?  Does the unlikely()
 > > actually affect code generation here?

 > True, (halign > 64) is the same and is cleaner. As for the unlikely()
 > -- well it's already been there and besides, we're never sure if it
 > will improve anything so the same question could be asked for other
 > places in the code.

I was just wondering in this case where you are just assigning the
boolean value of the expression to a variable how unlikely affects
things.  I can understand for conditional jumps how the compiler can
choose to make the likely case more efficient, but when there are no
jumps then I was just curious how the hint could help.

 > > I assume this initialization is to avoid a compiler warning.  But the
 > > code is actually correct without initializing blh -- so I think that we
 > > save a tiny bit of code by doing uninitialized_var() instead?

 > We must initialize blh since it is used for any send request and not
 > just LSO opcodes. 

So then this patch was buggy because blh was not reinitialized as we
loop through multiple work requests?  eg an LSO request followed by a
non-LSO request?

Anyway I'll look over the newer patch.
