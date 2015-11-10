From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] staging/rdma/hfi1: set Gen3 half-swing for integrated devices
Date: Tue, 10 Nov 2015 18:51:27 -0500
Message-ID: <20151110235126.GA347@phlsvsds.ph.intel.com>
References: <1447112288-28327-1-git-send-email-ira.weiny@intel.com> <20151110095929.GW18797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110095929.GW18797@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 12:59:29PM +0300, Dan Carpenter wrote:
> Gar...  No.  Please please get rid of the PC() macro.  It makes the code
> impossible to understand because instead of hitting CTRL-[ you have
> decode it and then manually type out
> 
> :cs find g CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_SHIFT
> 
> which is the length of a typical college essay.  I meant just put a
> comment like this:
> 
> /*
>  * In the hardware spec these are prefixed with:
>  * CCE_PCIE_CTRL_...
>  * But it is too long to use in code.
>  */
> #define XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK 0x1ull
> 
> Or probably even better:
> 
> #define CCE_PCIE_CTRL (CCE + 0x0000000000C0)
> #define LANE_BUNDLE_MASK	0x3ull /* CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_MASK */
> #define LANE_BUNDLE_SHIFT	0      /* CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_SHIFT */
> #define LANE_DELAY_MASK		0xFull /* CCE_PCIE_CTRL_PCIE_LANE_DELAY_MASK */
> #define LANE_DELAY_SHIFT	2      /* CCE_PCIE_CTRL_PCIE_LANE_DELAY_SHIFT */
> #define MARGIN_OVERWRITE_SHIFT	8      /* CCE_PCIE_CTRL_XMT_MARGIN_OVERWRITE_ENABLE_SHIFT */
> #define MARGIN_SHIFT		9      /* CCE_PCIE_CTRL_XMT_MARGIN_SHIFT */
> #define MARGIN_G1G2_OVERWRITE_MASK 0x1ull /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK */
> #define MARGIN_G1G2_OVERWRITE_SHIFT 12    /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_SHIFT */
> #define MARGIN_G1G2_MASK	0x7ull /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_MASK */
> #define MARGIN_G1G2_SHIFT	13     /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_SHIFT */
> 
> Those lines go over the 80 character limit but it's fine.

My apologies for not understanding what you meant.  I took your meaning to be
that we had to honor the checkpatch checks so while the PC macro was
undesirable it was ok if I just made some comments...

FWIW I don't like the PC macro either.  But we have a tool which is generating
these names to be identical to the hardware spec.  And we really want to
preserve those as a reference back to the spec.  Creating additional names which
are in the code is a bit cumbersome but what if we do something like this:

<auto generated from spec>
...
#define CCE_PCIE_CTRL (CCE + 0x0000000000C0)
#define CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_MASK 0x3ull
#define CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_SHIFT 0
...



<Defined for use in the code>
#define LANE_BUNDLE_MASK    CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_MASK
#define LANE_BUNDLE_SHIFT   CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_SHIFT
...


?????



An alternative would be to define some helper functions such as:

static inline u64 extract_xmt_margin_g1g2(u64 reg)
{
	return (reg >> CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_SHIFT)
		& CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_MASK;
}

...


...
	xmt_margin = extract_xmt_margin_g1g2(pcie_ctrl);
...

I prefer the second option as it preserves the register names right in the
code.  So you can reference the hardware spec without looking anything up in a
header file.

I again apologize for misunderstanding your previous meaning.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
