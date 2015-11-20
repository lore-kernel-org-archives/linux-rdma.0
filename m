From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: HFI1 code duplication todo
Date: Fri, 20 Nov 2015 09:13:46 -0800
Message-ID: <20151120171346.GA14829@kroah.com>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com>
 <564F3F1C.4020508@redhat.com>
 <20151120163935.GA10091@kroah.com>
 <564F512A.1060808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564F512A.1060808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 11:58:18AM -0500, Doug Ledford wrote:
> On 11/20/2015 11:39 AM, Greg KH wrote:
> > On Fri, Nov 20, 2015 at 10:41:16AM -0500, Doug Ledford wrote:
> >> To that end, I've opened my 4.4-rc branch and deleted the three
> >> deprecated drivers from staging and moved hfi1 to the rdma tree.  I've
> >> sent an email to Linus to see if he's ok taking those changes, and if
> >> so, I'll get them submitted and then open up my for-4.5 branch early to
> >> be able to start taking for-next patches.
> > 
> > I think it's too late for that, especially given that I have 34+ patches
> > for the staging rdma drivers already in my tree in linux-next.
> 
> For hfi1 rename detection should work, for the other three, patches to
> removed files are easily resolved as simply dropped patches.  So I don't
> think it's that large of an issue.  Correct me if I'm wrong.

I don't know what kind of conflicts will happen, if the changes will
propagate over if you rename a file in one branch and expect the changes
made to the file in a different branch to come over.  Haven't done that
in years.

> >  And the
> > hfil1 code really doesn't look like its ready to merge into the "real"
> > portion of the kernel tree, given the horrid nature of the patches
> > submitted recently for it :(
> 
> I'm sorry, that doesn't make sense to me.  How can the quality of
> patches that aren't part of the driver yet and are just being submitted
> impune the readiness of the code the patches are supposed to be touching?

They imply that the quality of the existing code is very low, if the
authors can't submit valid changes to the existing files :)

> And that's orthogonal to the issue that the primary TODO item for this
> driver requires coordination between it, qib (in the RDMA tree), and the
> upcoming soft_roce driver.  If the driver isn't moved, then we have to
> coordinate between your tree and mine to make sure that no patches are
> taken into your tree until after the patches they depend on have landed
> in my tree.  And then you tree likely won't build unless you pull from
> my tree and merge up first.  It's not really tenable.  That was why I
> had suggested (and originally you agreed to) that I would handle the
> entire staging/rdma tree.  However, since you changed your mind on that
> issue, we now have this coordination issue.  I don't really want to deal
> with that, so I would rather move the hfi1 driver and take care of the
> all the needed patching myself going forward.

That might be the _primary_ TODO item, but really, look at the patches
being submitted so far, they are just fixing up basic things that should
have been done a long time ago to the codebase.  How about people get it
cleaned up "completely" for this merge cycle, going through my tree, and
then, when it's all cleaned up, I'll move it to your portion of the tree
and merge that into 4.5-rc1 and then the cross-driver/core changes you
are referring to can happen.  There's no big rush here to try to force
the issue.

> > I had expected the drivers to be deleted for -rc1, removing them now
> > seems a bit late in the merge window.
> 
> Yes, I know.  I've been busy.  My apologies for not getting it in prior
> to rc1.

It's not a problem, life happens (congratulations by the way), but don't
rush things now, why not just wait until the next merge window, there
are no deadlines here that require this to happen for 4.4-final.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
