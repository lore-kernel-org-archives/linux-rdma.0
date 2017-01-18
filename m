From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/3] util: Add common code for provider
 debug
Date: Wed, 18 Jan 2017 11:44:11 -0700
Message-ID: <20170118184411.GA5020@obsidianresearch.com>
References: <1484682413-56580-1-git-send-email-tatyana.e.nikolova@intel.com>
 <20170118053130.GS32481@mtr-leonro.local>
 <20170118164444.GA14198@obsidianresearch.com>
 <20170118183104.GH32481@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118183104.GH32481-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 08:31:04PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 18, 2017 at 09:44:44AM -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 18, 2017 at 07:31:30AM +0200, Leon Romanovsky wrote:
> > > > +#define PRINT_ERR(fmt, ...)								\
> > > > +do {											\
> > > > +	fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);		\
> > > > +} while (0)
> > > > +
> > > > +#define PRINT_DBG(dbg_mask, dbg_level, fmt, ...)					\
> > > > +do {											\
> > > > +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> > > > +		fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> > > > +} while (0)
> > > > +
> > > > +#define LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ...)					\
> > > > +do {											\
> > > > +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> > > > +		fprintf(dbg_fp, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> > > > +} while (0)
> > > > +
> > > > +#define LOG_DBG_FLUSH(dbg_fp, dbg_mask, dbg_level, fmt, ...)				\
> > > > +do {											\
> > > > +		LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ##__VA_ARGS__);		\
> > > > +		if (dbg_fp != stderr)							\
> > > > +			fflush(dbg_fp);							\
> > > > +} while (0)
> > >
> > > IMHO, these macros should be inline functions, and better to avoid global variables.
> >
> > It is more expensive at the call site to inline something that calls
> > via va_args than via ..., so these should remain as macros.
> 
> These macros/functions need to be compiled in for DEBUG mode only, in
> such case you can pay extra CPU cycles.

One of the reasonable ways to use this is to always compile in *error
case* debug prints, as these are intrinsically on the slow error path
already - however for that use we certainly want to minimize icache
consumption at the call site.

If we don't want to micro-optimize the DEBUG enabled case then I
recommend this approach for the macro:

#define LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ...)
    ({
      static const struct verbs_log_loc loc = {
       .dbg_mask = dbg_mask,
       .dbg_level = dbg_level,
       .fmt = fmt,
       .line = __LINE__,
       .func = __func__ };
    __check_fmt_args(fmt, ## __VA_ARGS__);
    verbs_log_dbg(dbg_fp, &loc, ## __VA_ARGS__);
   })

verbs_log_dbg would be implemented out of line.

That has the lowest call-site icache overhead as most of the required
data is pushed into the .rodata pointer (instead of in .text) and we
can continue to use the register calling convention for the va_args.

We can probably also eliminate dbg_fp as an argument, there is no
reason to have the providers store that, IHMO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
