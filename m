From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 17:40:30 -0700
Message-ID: <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022002846.GU14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>The local loopback case uses PRs?

Yes - the rdma cm makes no distinction when resolve route is called.  It does a
PR query.

>Even so, it still seems OK to me:
>
>Path:
> addr4_resolve_remote
>  $ ip route get 10.0.0.11 from 192.168.122.1
>    local 10.0.0.11 from 192.168.122.1 dev lo
>  srcIP = 192.168.122.1
>  rdma_translate_ip(dst_ip = 10.0.0.11)
>   rdma_copy_addr("eth0");
>    src_dev_addr = eth0.dev_addr  (ie GID of 10.0.0.11)
>  memcpy(dst_dev_addr = src_dev_addr) (ie GID of 10.0.0.11)
>
>So everthing is bound to the GID of 10.0.0.11 which matches the listen
>of 10.0.0.11, which seems OK.

The source could have called rdma_bind_addr(192.168.122.1) prior to calling
rdma_resolve_addr().  (DAPL does this.)  This would have returned a different
RDMA device than binding to 10.0.0.11.  The client app could have allocated
resources on that device, but the CM REQ will carry the gid/lid of the other
device.  The endpoints won't be able to communicate.

Yes, it's weird, and may not be optimal, but if a source address is explicitly
given, then its mapping to a specific RDMA device should be honored.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
