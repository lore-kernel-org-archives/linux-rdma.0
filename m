From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings
 in GCC 7.1
Date: Thu, 13 Jul 2017 12:15:36 -0600
Message-ID: <20170713181536.GA4771@obsidianresearch.com>
References: <20170713133935.1206-1-leon@kernel.org>
 <20170713175122.GD11069@obsidianresearch.com>
 <1499968451.2740.14.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499968451.2740.14.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 05:54:12PM +0000, Bart Van Assche wrote:
> On Thu, 2017-07-13 at 11:51 -0600, Jason Gunthorpe wrote:
> > Can you follow the same approach as I used in
> > 
> > commit 47cd2efcd4cd416ead0a1a48153aa27a2e178ce5
> > Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Date:   Tue Jan 31 14:55:50 2017 -0700
> > 
> >     Annotate correct switch fall throughs with SWITCH_FALLTHROUGH
> > 
> > Or convert those cases to this approach?
> > 
> > >  			 * LE platform be32toh will do the job.
> > >  			 */
> > >  			hdr->key_immd = htole32(be32toh(wr->imm_data));
> > > +			/* FALLTHROUGH */
> > 
> > Use the SWITCH_FALLTHROUGH; macro
> 
> Hello Jason,
> 
> Both Coverity and gcc 7 understand fall-through comments. Do we
> really need a macro to annotate fall-through in switch statements?

Probably not, but I added it a while ago already based on some other
documentation..

The advantage of the macro is that all compilers verify it is spelled
correctly, while it is easy to make a mistake with comments..

In any case, let us do it consistently throughtout..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
