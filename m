From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [infiniband-diags] [1/2] support libibnetdisc caching
	overwrite flag
Date: Mon, 19 Apr 2010 09:40:51 -0700
Message-ID: <1271695251.17987.194.camel@auk31.llnl.gov>
References: <1271375547.17987.178.camel@auk31.llnl.gov>
	 <20100419150410.GA23994@me>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100419150410.GA23994@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sasha,

> Wouldn't it be better to make it in opposite direction - overwrite 
> file by default and drop an error when "exclusive" flag is specified?
> 
> For me it looks as more "intuitive" behavior (similar to other
> editors).

Now that you mention it, it would make more sense.  It would make more
sense for ibnetdiscover too when it tries to cache to the same filename.

I'll tweak and resubmit the patch series.

Al

On Mon, 2010-04-19 at 08:04 -0700, Sasha Khapyorsky wrote:
> Hi Al,
> 
> On 16:52 Thu 15 Apr     , Al Chu wrote:
> > diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
> > index 480a0a2..6cf7d4d 100644
> > --- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
> > +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
> > @@ -876,9 +876,20 @@ int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
> >  		return -1;
> >  	}
> >  
> > -	if (!stat(file, &statbuf)) {
> > -		IBND_DEBUG("file '%s' already exists\n", file);
> > -		return -1;
> > +	if (flags & IBND_CACHE_FABRIC_FLAG_OVERWRITE) {
> > +		if (!stat(file, &statbuf)) {
> > +			if (unlink(file) < 0) {
> > +				IBND_DEBUG("error removing '%s': %s\n",
> > +					   file, strerror(errno));
> > +				return -1;
> > +			}
> > +		}
> > +	}
> > +	else {
> > +		if (!stat(file, &statbuf)) {
> > +			IBND_DEBUG("file '%s' already exists\n", file);
> > +			return -1;
> > +		}
> >  	}
> 
> Wouldn't it be better to make it in opposite direction - overwrite file
> by default and drop an error when "exclusive" flag is specified?
> 
> For me it looks as more "intuitive" behavior (similar to other
> editors).
> 
> Sasha
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
