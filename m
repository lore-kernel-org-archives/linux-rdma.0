From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 07/11] ib_core: Add API to support IBoE from userspace
Date: Wed, 12 May 2010 13:28:31 -0700
Message-ID: <adak4r8uaog.fsf@roland-alpha.cisco.com>
References: <20100218172425.GH12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172425.GH12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:24:25 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Add ib_uverbs_get_eth_l2_addr() to allow ibv_create_ah() to resolve <sgid,
 > dgid> to <vlan, dmac> for any gid type.  Although user-space might bypass this
 > call for link-local gids, it is better not to replicate the kernel resolution
 > policy.  Port link layer is also returned by ibv_query_port().

A high-level comment/question, followed by some notes about the specific patch.

At the highest level, is having this very low-level command exposed as
part of the kernel uverbs <-> userspace API the right place to split
things?  Making the Ethernet address resolution part of the low-level
driver implies that it's not really a generic part of the verbs interface.

Maybe it is generic, and we should have a generic function instead of
calling into the low-level driver.  I see the argument that we should
keep the policy in the kernel, although I'm not sure how strong that
argument is -- once we start shipping a kernel with a certain policy
(and I guess OFED has in effect already done that), how could we ever
change that policy?  We'll have interoperability issues anyway, so it
seems having userspace and kernel use different policies doesn't cause
much further problems anyway.

Or maybe it is device-specific, and we could wrap it up into the create
AH uverbs call we already have?

Low-level comments:

 > +ssize_t ib_uverbs_get_eth_l2_addr(struct ib_uverbs_file *file, const char __user *buf,
 > +				  int in_len, int out_len)
 > +{
 > +	struct ib_uverbs_get_eth_l2_addr       cmd;
 > +	struct ib_uverbs_get_eth_l2_addr_resp  resp;
 > +	int              ret;
 > +	struct ib_pd    *pd;
 > +
 > +	if (out_len < sizeof resp)
 > +		return -ENOSPC;
 > +
 > +	if (copy_from_user(&cmd, buf, sizeof cmd))
 > +		return -EFAULT;
 > +
 > +	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
 > +	if (!pd)
 > +		return -EINVAL;
 > +
 > +	ret = ib_get_eth_l2_addr(pd->device, cmd.port, (union ib_gid *)cmd.gid,
 > +				 cmd.sgid_idx, resp.mac, &resp.vlan_id, &resp.tagged);
 > +	put_pd_read(pd);
 > +	if (!ret) {
 > +		if (copy_to_user((void __user *) (unsigned long) cmd.response,
 > +				 &resp, sizeof resp))
 > +			return -EFAULT;

This leaks kernel memory contents to userspace since the stack variable
resp is never cleared.  Also will cause problems if we ever need to use
the reserved fields for anything.

Also I'm not sure I understand why you pass the PD into this method?  It
seems you just use it to get a pointer to the device, but you already
have that from the uverbs_file structure that's passed into all commands.

 > +int ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid,
 > +		       int sgid_idx, u8 *mac, __u16 *vlan_id, u8 *tagged)
 > +{
 > +	if (!device->get_eth_l2_addr)
 > +		return -ENOSYS;
 > +
 > +	return device->get_eth_l2_addr(device, port, gid, sgid_idx, mac, vlan_id, tagged);
 > +}
 > +EXPORT_SYMBOL(ib_get_eth_l2_addr);

I don't think we need this wrapper, since uverbs can just call the
get_eth_l2_addr method directly (we already do that for quite a few
other methods, eg alloc_ucontext is a uverbs-only method that has no
in-kernel wrapper).  Also the -ENOSYS test isn't necessary, since a
device-driver shouldn't allow this method unless it actually implements
it.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
