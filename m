From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 18:28:46 -0600
Message-ID: <20091022002846.GU14520@obsidianresearch.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BFF5CD71FFA74BF09A2EED5F3319F370-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 04:58:02PM -0700, Sean Hefty wrote:
> >$ ip route get 10.0.0.11 from 192.168.122.1
> >local 10.0.0.11 from 192.168.122.1 dev lo
> >    cache <local>  mtu 16436 advmss 16396 hoplimit 64
> >
> >(192.168.122.1 is bound to a different device on my system than
> >10.0.0.11)
> >
> >The new case trips the if == loopback and does
> >rdma_translate_ip(10.0.0.11)
> >
> >The old case does rdma_translate_ip(192.168.122.1)
> >
> >I don't think this is a significant difference, both behaviors are
> >reasonable choices and the code/complexity savings are worth it, IMHO.
> >[Alternatively, I suppose one could call rdma_translate_ip(rt->rt_src)
> >and if that fails then do rdma_translate_ip(dst_in) but why bother?]
> 
> I agree this usage case is weird, but I'm still not sure about the
> patch.  If the destination service is listening on 10.0.0.11, then
> the listen is bound to a different gid than the source gid that
> we're trying to connect from.  The src_dev_addr and dst_dev_addr
> need to reflect this, so that a PR gives us a path that routes the
> CM REQ correctly.

You've lost me.. 

The local loopback case uses PRs?

Even so, it still seems OK to me:

Path:
 addr4_resolve_remote
  $ ip route get 10.0.0.11 from 192.168.122.1
    local 10.0.0.11 from 192.168.122.1 dev lo
  srcIP = 192.168.122.1
  rdma_translate_ip(dst_ip = 10.0.0.11)
   rdma_copy_addr("eth0");
    src_dev_addr = eth0.dev_addr  (ie GID of 10.0.0.11)
  memcpy(dst_dev_addr = src_dev_addr) (ie GID of 10.0.0.11)

So everthing is bound to the GID of 10.0.0.11 which matches the listen
of 10.0.0.11, which seems OK.

The CM REP is sent to GID of 10.0.0.11 from GID of 10.0.0.11, with an
private data that indicates a source IP of 192.168.122.1 and a dest IP
of 10.0.0.11. This seems optimal to me?

By what I understand you said I would think the prior version would be
the one that is in trouble, if I am listening on 10.0.0.11 and you
make a connection sourced from 192.168.122.1, which is looped back, it
seems reasonable to me that this will succeed and the outgoing
connection would necessarily have be bound to the destination address
since the listening process is attached there.

Am I missing something?

Remember, there is still one more missing part there, the cma_bind I
was talking about has to go away. We want to bind the source device
based on the routing lookup, with loopback binding to the destination
device.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
