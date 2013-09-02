From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Write combining support in the upstream kernel
Date: Mon, 2 Sep 2013 10:15:00 +0300
Message-ID: <20130902101500.287c1c58@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This is a re-posting (and rewording) of a question I sent you on July 6,
2009.

I've been looking at the write-combining support in the kernel,
and it looks good. The caller simply invokes pgprot_writecombine() and
if write combining is available, the region is mapped for it (if wc is
not available, the regions is mapped as non-cached).

However, the API silently activates write combining without providing
any architecture-independent means of knowing whether write combining
is enabled or not. 

For example, in X86 the procedure pgprot_writecombine is as follows:
 pgprot_t pgprot_writecombine(pgprot_t prot)
 {
         if (pat_enabled)
                 return __pgprot(pgprot_val(prot) | _PAGE_CACHE_WC);
         else
                 return pgprot_noncached(prot);
 }

Note that pat_enabled is an architecture-dependent variable!

Silent activation of WC is OK in situations where for feature X, if
write-combining is available, X works better and the driver's
performance improves. (the driver simply calls pgprot_writecombine(),
and if WC is available it is activated for the region; if it is not
available, the region is mapped in the usual fashion).

However, what about situations where we wish to enable feature X ONLY
if write combining is available? (In this case the driver cannot simply
call pgprot_writecombine() not knowing if write-combining is really
used or not).

The required logic here is:
	if (write-combining is available)
		Activate feature X, and use pgprot_writecombine() for
		its regions;
	else
		Do NOT activate feature X.

In MLNX_OFED, to get around this problem, I introduced some
architecture-dependent wrapper functions to take care of this (where
these functions simply indicate in a fixed manner whether write
combining is enabled for specific architectures):

#include <linux/pci.h>
#include "wc.h"

#if defined(__i386__) || defined(__x86_64__)

pgprot_t pgprot_wc(pgprot_t _prot)
{
        return pgprot_writecombine(_prot);
}

int mlx4_wc_enabled(void)
{
        return 1;
}

#elif defined(CONFIG_PPC64)

pgprot_t pgprot_wc(pgprot_t _prot)
{
        return __pgprot((pgprot_val(_prot) | _PAGE_NO_CACHE) &
                                     ~(pgprot_t)_PAGE_GUARDED);
}

int mlx4_wc_enabled(void)
{
        return 1;
}

#else   /* !(defined(__i386__) || defined(__x86_64__)) */

pgprot_t pgprot_wc(pgprot_t _prot)
{
        return pgprot_noncached(_prot);
}

int mlx4_wc_enabled(void)
{
        return 0;
}

#endif

I then use mlx4_wc_enabled() to determine whether or not to use
blueflame (which is feature X in this case):

static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct
ib_device *ibdev, struct ib_udata *udata)
{

....
===>	if (mlx4_wc_enabled()) {
		resp.bf_reg_size      = dev->dev->caps.bf_reg_size;
		resp.bf_regs_per_page = dev->dev->caps.bf_regs_per_page;
	} else {
		resp.bf_reg_size      = 0;
		resp.bf_regs_per_page = 0;
	}

I would like, though, to have the capability in the kernel API to
determine if write-combining is available on a given host.

I thought of possibly comparing the result returned by
pgprot_writecombine(prot) to that returned by pgprot_noncached(prot)
-- if they are identical, then assume that write-combining is not
supported. (pgprot_noncached() is the default mapping of
pgprot_writecombine if it is not defined under the arch directory --
see file include/linux/pgtable.h).

This has a problem, however, in that I have no way of determining what
value of "prot" to use when doing this comparison -- there may be some
architectures which use bits of the prot structure to determine per
specific call whether or not to use write-combining (i.e.,
pgprot_writecombine(prot) could invoke pgprot_noncached(prot) if
certain bits were set in the prot structure, or return a
write-combining prot value if those bits are not set).

Using a zeroed-out pgprot structure in the comparison, for example, may
not be appropriate. (we may be allowing blueflame when it should not
be, or preventing blueflame when it should be allowed).

Do you have any ideas for how to determine if in fact write-combining
is available? How about introducing an external variable (say
extern int write_combining_active) which would be initialized by the
kernel (per architecture) to be 1 or 0? 

-Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
