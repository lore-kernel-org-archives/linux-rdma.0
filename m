From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Fix assorted memory leaks on error paths
Date: Tue, 31 May 2016 17:33:17 -0400
Message-ID: <20160531213317.GC57351@redhat.com>
References: <1463591267-29975-1-git-send-email-jarod@redhat.com>
 <20160526051010.GR25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160526051010.GR25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2016 at 08:10:10AM +0300, Leon Romanovsky wrote:
> On Wed, May 18, 2016 at 01:07:47PM -0400, Jarod Wilson wrote:
> > Clang noticed that we might leak mcg_params.ib_devname in failure paths.
> > There are additional leaks after fixing this initial one that it still
> > reported, here's hoping I've got them all now...
...
> >  	return send_destroy_ctx(&ctx,&user_param,&mcg_params);
> > +
> > +failure2:
> 
> Where is "failure1" ?
> 
> > +	free(my_dest);
> > +	free(rem_dest);
> > +	destroy_ctx(&ctx,&user_param);
> > +failure:

I considered 'failure' to be failure1, I guess. Really not picky on the
label names.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
