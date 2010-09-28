From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/11 v2] RDMA/cxgb4: Support on-chip SQs.
Date: Tue, 28 Sep 2010 10:57:35 -0700
Message-ID: <adad3rx699s.fsf@cisco.com>
References: <20100913162357.20948.28267.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100913162357.20948.28267.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Mon, 13 Sep 2010 11:23:57 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

As I said, I applied this, but I wonder:

 > +static inline pgprot_t t4_pgprot_wc(pgprot_t prot)
 > +{
 > +#if defined(__i386__) || defined(__x86_64__)
 > +	return pgprot_writecombine(prot);
 > +#elif defined(CONFIG_PPC64)
 > +	return __pgprot((pgprot_val(prot) | _PAGE_NO_CACHE) &
 > +			~(pgprot_t)_PAGE_GUARDED);
 > +#else
 > +	return pgprot_noncached(prot);
 > +#endif
 > +}
 > +
 > +static inline int t4_ocqp_supported(void)
 > +{
 > +#if defined(__i386__) || defined(__x86_64__) || defined(CONFIG_PPC64)
 > +	return 1;
 > +#else
 > +	return 0;
 > +#endif
 > +}

Is there any way to avoid this ifdef-ery?  It seems at least the powerpc
case should be wrapped up in an arch/powerpc version of pgprot_writecombine.
Also doing this by hand as here leaves out for example ia64, which seems
to have a definition of pgrprot_writecombine.

However I don't know what (if anything) we should do for the
ocqp_supported test ...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
