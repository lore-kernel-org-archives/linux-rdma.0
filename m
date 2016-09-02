From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/3] Add new call ibv_cmd_create_ah_ex which
 supports extra parameters
Date: Fri, 02 Sep 2016 09:49:42 +0200
Message-ID: <1472802582.3975.16.camel@oracle.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
         <1472713193-22397-2-git-send-email-knut.omang@oracle.com>
         <20160901164939.GD6479@obsidianresearch.com>
         <1472750558.9410.230.camel@oracle.com>
         <20160901180512.GB20098@obsidianresearch.com>
         <1472754220.9410.236.camel@oracle.com>
         <20160902020642.GA30057@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160902020642.GA30057-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-09-01 at 20:06 -0600, Jason Gunthorpe wrote:
> On Thu, Sep 01, 2016 at 08:23:40PM +0200, Knut Omang wrote:
> > 
> > > 
> > > > 
> > > > > 
> > > > > On Thu, Sep 01, 2016 at 08:59:51AM +0200, Knut Omang wrote:
> > > > > > 
> > > > > > +++ b/src/libibverbs.map
> > > > > > @@ -64,6 +64,7 @@ IBVERBS_1.0 {
> > > > > >  		ibv_cmd_post_recv;
> > > > > >  		ibv_cmd_post_srq_recv;
> > > > > >  		ibv_cmd_create_ah;
> > > > > > +		ibv_cmd_create_ah_ex;
> > 
> > For this patch backward binary compatibility is actually preserved - a vendor library 
> > continues to work even without recompiling. I deliberately avoided making
> > the ibv_cmd_create_ah function inline to ensure that. Loading libsif would of course
> > break, but with a symbol error.
> No, this patch is wrong, you added it to IBVERBS_1.0, that isn't
> allowed.
> 
> You need to do something like this:
> 
> IBVERBS_1.3 {
>         global:
> 	   ibv_cmd_create_ah_ex;

You are quite right - I'll fix the patch like you indicate, using either 1.2 or 1.3 depending on
the conclusions on the other changes you mention below, Doug, let me know what value you want,

Thanks,
Knut

> Why? RPM works by having provides like:
> 
>  libibverbs
>  libibverbs(x86-64)
>  libibverbs.so.1()(64bit)
>  libibverbs.so.1(IBVERBS_1.0)(64bit)
>  libibverbs.so.1(IBVERBS_1.1)(64bit)
> 
> And when you create a client RPM package it strips off the function name
> and uniques it to produce the Depends.
> 
> In other words, once IBVERBS_1.x is shipped in a RPM that stanza in
> the map file is set in stone. We can never add more symbols to that
> stanza. We must start a new number.
> 
> To be concrete, when your new provider links to
> ibv_cmd_create_ah_ex@IBVERBS_1.0 rpm will create a dependency
> libibverbs.so.1(IBVERBS_1.0).  *However* every RPM provides that, so
> the dependency logic in RPM stops working and will let a user install
> your provider on a system it is not compatible with. When it is set
> properly to ibv_cmd_create_ah_ex@IBVERBS_1.3 then RPM will only allow
> the provider RPM to be installed on a system that has the upgraded
> libibverbs1.
> 
> Unfortunately this has been systematically screwed up by recent
> patches (pay attention Matan and Yisahi), so our symbol versioning is
> now unusable for RPM based distros.
> 
> Debian does this differently and will not be affected. Actual linking
> should be fine too, AFAIK it is just RPM that will break.
> 
> Doug? Is it too late to fix this for the patches you accepted in 2016?
> The answer to that depends entirely on how far the RPMs have got..
> 
> The _cmd_ varients are not too bad, we could fix that in rdma-plumbing
> in a way that lets us move forward sane sanely, but
> ibv_query_device_ex@IBVERBS_1.0 should have been tagged _1.2
> 
> The fix would be to introduce a
> ibv_query_device_ex@IBVERBS_1.3 as the new default and continue to
> provide ibv_query_device_ex@IBVERBS_1.0 for compat against the same
> physical symbol. New links would then get functional rpm dependencies.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
