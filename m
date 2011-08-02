From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Tue, 2 Aug 2011 16:28:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373136F935C@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
 <201108011508.06521.jackm@dev.mellanox.co.il>
 <20110802053824.GA23512@obsidianresearch.com>
 <201108021053.05311.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108021053.05311.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If I understand correctly, the various additions which would normally be made
> to libibverbs
> would then be made by third-party libraries which extend libibverbs to support
> their additions.

It may help to read about extensions in opengl:

http://www.opengl.org/registry/doc/rules.html

Additions can be made to both.  Obviously Roland has the final say on any changes to ibverbs, but what I envision is:

If a feature is based on an industry standard and all necessary kernel changes are upstream, then the feature should be integrated into ibverbs.  An application would simply call ibv_new_feature() to make use of the feature (or call an existing function with some new enum value).  Internally, ibverbs may need to obtain a new interface from the provider library.

If there is no published specification for a feature (maybe it's still under development), kernel patches are needed, and there are customers who want to use the feature immediately, then a vendor can define an extension.  In this case, the application may call vendor_ops = ibv_get_ext_ops(), followed by vendor_ops->new_feature().  Or the app may call ibv_some_existing_function() using a vendor specific enum value.

> These additions would include the new ibv_cmd_xxx functions
> (the core functions reside in src/cmd.c), and new, additional, enum values of
> the form IBV_USER_VERBS_CMD_XXXX, of which the core enum is in file
> include/infiniband/kern_abi.h.

If an app uses an extension, then there are no changes to ibverbs.  The provider library either needs to use an existing ibv_cmd_* call or call into the kernel itself.  If the provider needs a new command, it could declare it as:

	enum {
		MLX4_USER_VERBS_CMD_BASE = IBV_EXTENSION_VENDOR <<
						IBV_EXTENSION_BASE_SHIFT,
		MLX4_USER_VERBS_CMD_NEW_FEATURE ...
	};

This requires a kernel patch to uverbs maintained by the vendor.  Note that this means that the vendor can continue to support their version of a feature (with continued kernel patches) even once the feature is merged into ibverbs.
 
> Each new third-party package would need such a library.
> While this will lead to a multiplicity of new libraries (one per addition),
> the core libibverbs package would remain as is.

I didn't follow this.  The new feature could be integrated directly into the provider library (e.g. mlx4).
 
> Am I correct?  If so, shouldn't the current XRC userspace implementation do
> the same (and
> take the XRC-specific additions out of libibverbs and put them into a separate
> library)?

XRC could be added as an extension, but since it's based on a published specification, IMO it makes more sense being integrated directly into ibverbs with the necessary kernel changes pushed upstream.  Extensions are more difficult for apps to use than an integrated feature.

> Note that coordination between third parties would still be required to insure
> that there is
> no collision of enum values between the various packages.

The use of enum ibv_extension_type should prevent collisions.  It may be that different vendors use the same value for different objects, but that doesn't result in a collision.  The scope of a vendor specific value is per device.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
