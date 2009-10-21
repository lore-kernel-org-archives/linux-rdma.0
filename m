From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 17:36:39 -0600
Message-ID: <20091021233639.GS14520@obsidianresearch.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9D257695083141E79685CB2B260D7D7C-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 04:17:01PM -0700, Sean Hefty wrote:

> This doesn't end up doing the same thing as what resolve_local did.  It only
> matches up with the 'else if' portion below: 

It does all the behaviors, it passes the input into a routing lookup
- though it is true the source needs to be passed into the routing
lookup, which I think David had in another patch. Dave; I guess you
need to include that here now.

So, first case:

> >-		if (ipv4_is_zeronet(src_ip)) {

Looks like:
$ ip route get 10.0.0.11
local 10.0.0.11 dev lo  src 10.0.0.11 
    cache <local>  mtu 16436 advmss 16396 hoplimit 64

trips through the if == loopback and does
'rdma_translate_ip(10.0.0.11)'

Same as the old code (little different path, but seems to give the
same result)

Second case:

> >-		} else if (ipv4_is_loopback(src_ip)) {

Looks like:
$ ip route get 10.0.0.11 from 127.0.0.1
local 10.0.0.11 from 127.0.0.1 dev lo 
    cache <local>  mtu 16436 advmss 16396 hoplimit 64

so trips through the if == loopback and does rdma_translate_ip(10.0.0.11)

Same as the old code

Third case:
> >-		} else {

$ ip route get 10.0.0.11 from 10.0.0.11
local 10.0.0.11 from 10.0.0.11 dev lo 
    cache <local>  mtu 16436 advmss 16396 hoplimit 64

Again, does rdma_translate_ip(10.0.0.11)

And the weird case is different:

$ ip route get 10.0.0.11 from 192.168.122.1
local 10.0.0.11 from 192.168.122.1 dev lo 
    cache <local>  mtu 16436 advmss 16396 hoplimit 64

(192.168.122.1 is bound to a different device on my system than
10.0.0.11)

The new case trips the if == loopback and does
rdma_translate_ip(10.0.0.11)

The old case does rdma_translate_ip(192.168.122.1)

I don't think this is a significant difference, both behaviors are
reasonable choices and the code/complexity savings are worth it, IMHO.
[Alternatively, I suppose one could call rdma_translate_ip(rt->rt_src)
and if that fails then do rdma_translate_ip(dst_in) but why bother?]

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
