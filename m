From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core release?
Date: Wed, 12 Oct 2016 19:45:32 -0600
Message-ID: <20161013014532.GA12670@obsidianresearch.com>
References: <20161012105103.GA30534@infradead.org>
 <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w@mail.gmail.com>
 <59ebde13-0fcd-0640-e750-bb6e57bfb921@redhat.com>
 <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
 <20161012163149.GA20174@infradead.org>
 <20161012164759.GB18838@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE23B5D@ORSMSX115.amr.corp.intel.com>
 <20161012183548.GA31053@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE23BA8@ORSMSX115.amr.corp.intel.com>
 <ddda9ec9-1690-4d0a-07c8-980cac16304e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ddda9ec9-1690-4d0a-07c8-980cac16304e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 12, 2016 at 06:15:11PM -0400, Doug Ledford wrote:

> For someone like OFED this matters too because their scripts have to be
> made aware of all possible package names so they know to remove the
> inbox packages before they install their own.  For the foreseeable
> future, the OFED scripts will have to be aware of both a monolithic
> build and a split out build just so it can do the removal successfully.
> They are then free to install the packages however they see fit.

ofed may wish to consider just a very simple monolithic
rdma-core-{libs,devel,bin} which conflicts with all possible distro
package names...

Also, I hope that several of the 'loose' things ofed has like the init
scripts and what not will migrate into rdma-core and be more
consistent across distros. OFED may prefer to patch such things 
into rdma-core than to continue producing 'loose' stuff.

> There will be some education issues to resolve.  Even though we are
> likely to split up the package output on EL 7, there is not a 1 to 1
> correspondence.  For example, there will only be one debuginfo package
> for the entire build, so people who thought they could do yum install
> libmlx4-debuginfo are going to be wondering why it isn't available.  But
> there isn't much we can do about that.  Fortunately, it's only the
> debuginfo and src rpm that will change this way, we can create all of
> the other split out packages so things will look mostly the same way.

That should be doable, I was able to do it for Debian.

Do you think the new providers could go into some kind of combined rpm
in EL 7 with the same name that FC/EL 8 will have?

Ideally I'd like to get to a point where adding new providers is not a
pain point requiring distro approval and eval of new package names/etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
