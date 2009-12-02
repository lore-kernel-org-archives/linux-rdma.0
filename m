From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Sun V880 + Infiniband?
Date: Wed, 02 Dec 2009 09:55:19 -0800
Message-ID: <adaocmhuupk.fsf@roland-alpha.cisco.com>
References: <200912021045.02970.pat@computer-refuge.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200912021045.02970.pat-bdq14YP6qtQCo4FBHZViTkB+6BGkLq7r@public.gmane.org> (Patrick Finnegan's
	message of "Wed, 2 Dec 2009 10:45:02 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Patrick Finnegan <pat-bdq14YP6qtQCo4FBHZViTkB+6BGkLq7r@public.gmane.org>
Cc: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > [   99.664193] ib_mthca 0003:01:00.0: Missing DCS, aborting.
 > 
 > I'm using a kernel compiled off of Linus's git tree as of a few days ago 
 > (to fix other SPARC issues).  From what I've seen from google searches, 
 > this means that the first BAR isn't mapped or visible to the driver, so 
 > maybe this is a SPARC related thing?

I think the problem is related to:

 >         Memory at fffff80500000000 (64-bit, non-prefetchable) [size=1]
 >         Memory at fffff80500000000 (64-bit, prefetchable) [size=1]
 >         Memory at fffff80500000000 (64-bit, prefetchable) [size=1]

So it says you have 3 BARs at the same address, all with size 1 (?!)
which means the PCI setup or probing is messed up.  The mthca driver
checks that the first BAR has size 1 megabyte as it should, and it's
bailing out because the kernel is telling it that it's the wrong size.

 - R.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
