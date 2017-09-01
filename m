From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] util: Fix check_snprintf to use __rc__ for
 local
Date: Fri, 1 Sep 2017 09:00:13 -0600
Message-ID: <20170901150013.GA21378@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170901045632.GJ10539@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170901045632.GJ10539-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 01, 2017 at 07:56:32AM +0300, Leon Romanovsky wrote:
> On Thu, Aug 31, 2017 at 02:50:56PM -0600, Jason Gunthorpe wrote:
> > To avoid clashing with user variables.
> >
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >  util/util.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/util/util.h b/util/util.h
> > index cbf0deca2dde7b..30d32ee6b51e24 100644
> > +++ b/util/util.h
> > @@ -8,8 +8,8 @@
> >   * error */
> >  #define check_snprintf(buf, len, fmt, ...)                                     \
> >  	({                                                                     \
> > -		int rc = snprintf(buf, len, fmt, ##__VA_ARGS__);               \
> > -		(rc < len && rc >= 0);                                         \
> > +		int __rc__ = snprintf(buf, len, fmt, ##__VA_ARGS__);           \
> 
> It can't clash, because it is declared in the scope {..} of that define and
> it is local to check_snprintf macro.

This triggers a -Wshadow warning:

 int rc;
 check_snprinf(str, sizeof(str), ..)

And rc is commonly used in callers, so it shouldn't.

Perhaps this addresses all the concerns:

/* Return true if the snprintf succeeded, false if there was truncation or
 * error */
static inline bool __good_snprintf(size_t len, int rc)
{
	return (rc < len && rc >= 0);
}

#define check_snprintf(buf, len, fmt, ...)    \
	__good_snprintf(len, snprintf(buf, len, fmt, ##__VA_ARGS__))

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
