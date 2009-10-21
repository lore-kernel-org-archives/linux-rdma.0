From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 16:58:02 -0700
Message-ID: <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091021233639.GS14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>$ ip route get 10.0.0.11 from 192.168.122.1
>local 10.0.0.11 from 192.168.122.1 dev lo
>    cache <local>  mtu 16436 advmss 16396 hoplimit 64
>
>(192.168.122.1 is bound to a different device on my system than
>10.0.0.11)
>
>The new case trips the if == loopback and does
>rdma_translate_ip(10.0.0.11)
>
>The old case does rdma_translate_ip(192.168.122.1)
>
>I don't think this is a significant difference, both behaviors are
>reasonable choices and the code/complexity savings are worth it, IMHO.
>[Alternatively, I suppose one could call rdma_translate_ip(rt->rt_src)
>and if that fails then do rdma_translate_ip(dst_in) but why bother?]

I agree this usage case is weird, but I'm still not sure about the patch.  If
the destination service is listening on 10.0.0.11, then the listen is bound to a
different gid than the source gid that we're trying to connect from.  The
src_dev_addr and dst_dev_addr need to reflect this, so that a PR gives us a path
that routes the CM REQ correctly.

- Sean 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
