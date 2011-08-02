From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Tue, 2 Aug 2011 10:53:05 +0300
Message-ID: <201108021053.05311.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com> <201108011508.06521.jackm@dev.mellanox.co.il> <20110802053824.GA23512@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110802053824.GA23512-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday 02 August 2011 08:38, Jason Gunthorpe wrote:
> The hope is once the infrastructure is in libibverbs there will not
> be as much need to change libibverbs, just the apps and the drivers.
> 
If I understand correctly, the various additions which would normally be made to libibverbs
would then be made by third-party libraries which extend libibverbs to support their additions.

These additions would include the new ibv_cmd_xxx functions
(the core functions reside in src/cmd.c), and new, additional, enum values of
the form IBV_USER_VERBS_CMD_XXXX, of which the core enum is in file
include/infiniband/kern_abi.h.

The modified apps would then include the header files of the 3rd party additions
after the libibverbs headers when compiling.

Each new third-party package would need such a library.
While this will lead to a multiplicity of new libraries (one per addition),
the core libibverbs package would remain as is.

Am I correct?  If so, shouldn't the current XRC userspace implementation do the same (and
take the XRC-specific additions out of libibverbs and put them into a separate library)?

Note that coordination between third parties would still be required to insure that there is
no collision of enum values between the various packages.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
