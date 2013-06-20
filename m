From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Thu, 20 Jun 2013 10:53:05 -0600
Message-ID: <20130620165305.GA19800@obsidianresearch.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51C32EFC.8060202-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2013 at 12:34:04PM -0400, Doug Ledford wrote:
> On 06/20/2013 10:21 AM, Jeff Squyres wrote:
> > Keep IBV_MTU_* enums values as they are, but pass MTU values around as
> > int's.  This is an ABI-compatible change; legacy applications will use
> > the enum values,
> 
> I'm not really concerned with what the legacy apps use so much as what
> they are presented with.  In other words, I'm sure they won't request
> anything other than an MTU represented by one of the enum values.  The
> problem though, is what if they are run on a link with a non-IB MTU and
> they are presented with it?  Let's look at one of the ports you did in
> this patch as an example:

Remember, apps will only see a wonky value if they are being used on
one of Jeff's new not-IB, not-ROCE, not-iWARP transports. Who knows if
they will even work on this new transport unmodified anyhow??

An app update to suport future transports is not unreasonable, it
happened for iwarp, rocee, etc.

> > diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
> > index 21c551d..5a0656f 100644
> > +++ b/examples/ud_pingpong.c
> > @@ -332,7 +332,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> >  			fprintf(stderr, "Unable to query port info for port %d\n", port);
> >  			goto clean_device;
> >  		}
> > -		mtu = 1 << (port_info.active_mtu + 7);

.. and this is sketchy anyhow, the above maths are not defined to work
anywhere, it just happens to work with the constants that have been
defined so far. This would break equally if we added any new constant
to the enum. So no, these maths are not important.

> One possible solution to this problem is to use ld.linux's symbolic
> symbol versions to solve this problem for us.  Fortunately, Roland has
> been excellent in the past about keeping all of libibverbs symbols
> versioned.  That can save us here.

There is a huge resistance to reving the symbol versions in
ibverbs. See the whole extension mess.

Further, the symbol versions don't work well in verbs, the internal
structures are too exposed. The existing support is already broken and
only works in very limited cases.

What you propose breaks in fairly common use cases, eg if
librdmacm/etc and the app link to different ibverbs versions then
things go wrong. rdmacm and the app pass pointers to verbs structures
across their boundary but they are unware they are versioned
differently, and will pass them back to the wrong verbs entry
point. This has already been seen to fail with the existing symbol
version support.

Basically: the verbs ABI was not designed to work with symbol
versions.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
