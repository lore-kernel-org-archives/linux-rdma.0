From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [infiniband-diags] [libibmad] Support new ibccquery congestion
 control tool
Date: Wed, 21 Sep 2011 11:09:48 -0700
Message-ID: <20110921110948.6f3d46ff.weiny2@llnl.gov>
References: <1316469989.25283.728.camel@auk59.llnl.gov>
	<CAKzyTsxKD0r9194fd1haQ0u=1kXLDhrRXLL8q+=+inV5BM1mog@mail.gmail.com>
	<20110921084934.b300e682.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110921084934.b300e682.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 21 Sep 2011 08:49:34 -0700
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> On Wed, 21 Sep 2011 07:17:38 -0700
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Hi Al,

<snip>

> 
> > 
> > On 0001-Support-ibccquery-congestion-control-query-tool.patch, I'm
> > worried about the following:
> > +		/* XXX: Q3/2010 errata lists first entry offset at 80, but we assume
> > +		 * will be updated to 96 once CurrentTimeStamp field is word aligned.
> > +		 * In addition, assume max 13 log events instead of 16.  Due to
> > +		 * errata changes increasing size of CA log event, 16 log events is
> > +		 * no longer possible to fit in max MAD size.
> > +		 */
> > 
> > As far as the 13 v. 16 entries, this appears correct to me (MAD size)
> > but I'm concerned about changing the offset from 80 to 96 for better
> > alignment as this is putting the cart before the horse a little as
> > since these changes have not been finalized AFAIK at the IBTA.
> 
> Yes, it is a bit premature.  I have submitted the above alignment as a comment
> to the IBTA but as you say it is not published.  Most importantly the
> miss-alignment breaks the convention of the spec.  So I don't think the IBTA
> will reject the comment.
> 
> Second the current alignment breaks libibmad.  So it would be a lot more code
> to support the miss-alignment and would probably have to be changed anyway.
> 
> > 
> > Also, would you comment on what testing has been done with this ?
> > 
> 
> Right, the real question is what does current hardware do?
> 
> We have been unable to determine if any of the vendors support the errata
> fully or specifically the miss-aligned CurrentTimeStamp.  When I asked the
> vendors I got concrete answers back, so we proceeded with trying to reverse
              ^^^
I meant to say "no concrete" answers here.

Sorry,
Ira

> engineer it.  Right now the query succeeds, that is all we know.
> 
> Perhaps someone on the list can help us find out?  :-D
> 
> In the meantime we wanted to get comments on the patches.
> 
> Ira
> 
> > -- Hal
> > 
> > > Al
> > >
> > > --
> > > Albert Chu
> > > chu11-i2BcT+NCU+M@public.gmane.org
> > > Computer Scientist
> > > High Performance Systems Division
> > > Lawrence Livermore National Laboratory
> > >
> > >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> Ira Weiny
> Member of Technical Staff
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
