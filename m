From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libibverbs changes broke usnic libfabric provider
Date: Mon, 23 Jan 2017 16:18:32 -0700
Message-ID: <20170123231832.GD21744@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB0DF06C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0DF06C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Ben Turrubiates (bturrubi)" <bturrubi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "'David Goodell (dgoodell)' (dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 23, 2017 at 10:24:52PM +0000, Hefty, Sean wrote:

> prov/usnic/src/usnic_direct/usd_ib_cmd.c: In function 'usd_ib_cmd_modify_qp':
> prov/usnic/src/usnic_direct/usd_ib_cmd.c:739:8: error: 'struct ibv_modify_qp'
> has no member named 'qp_handle'
>      icp->qp_handle = qp->uq_qp_handle;
>         ^
> prov/usnic/src/usnic_direct/usd_ib_cmd.c:740:8: error: 'struct ibv_modify_qp'
> has no member named 'attr_mask'
>      icp->attr_mask = IBV_QP_STATE;
>         ^
> prov/usnic/src/usnic_direct/usd_ib_cmd.c:741:8: error: 'struct ibv_modify_qp'
> has no member named 'qp_state'
>      icp->qp_state = state;
>         ^
> make[1]: *** [prov/usnic/src/usnic_direct/src_libfabric_la-usd_ib_cmd.lo] Error 
> 1
> make[1]: *** Waiting for unfinished jobs....
> make[1]: Leaving directory `/var/tmp/OFED_topdir/BUILD/libfabric-1.3.0'
> 
> 
> This results from recent changes to kern-abi.h.  :/

FWIW, there was a decision to stop supporting out of tree drivers and
so ther drive API and ABI is now considered internal to
rdma-core. Plan for kern-abi.h and related to go away someday.

It doesn't look like usd_ib_cmd.c is using the libibverbs driver API
so it should use the kernel header /usr/include/rdma/ib_user_verbs.h,
not the libibverbs header.

> Jeff, I'm not sure how you want to fix this.  Do you need libibverbs
> installed, or just the header files?  If just the latter, you may
> want to use a private copy, since compatibility won't be guaranteed
> anymore.

If you copy libibverbs headers then do not link to libibverbs. We
certainly will not support that.

A private copy of the kernel uapi header is OK..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
