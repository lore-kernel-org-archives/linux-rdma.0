From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RFCv3: Consolidated userspace RDMA library repo
Date: Wed, 7 Sep 2016 09:45:08 -0600
Message-ID: <20160907154508.GA2878@obsidianresearch.com>
References: <20160907040925.GA27361@obsidianresearch.com>
 <20160907062508.GA3639@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160907062508.GA3639-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 07, 2016 at 09:25:08AM +0300, Leon Romanovsky wrote:
> On Tue, Sep 06, 2016 at 10:09:25PM -0600, Jason Gunthorpe wrote:
> > Hello Everyone,
> >
> > I've updated the repo, and I think we are now at the point to begin to
> > engage the distribution packagers and collect their feedback. As Doug
> > has suggested, there are many modifications that the distros have done
> > that could be folded back upstream.
> >
> > It is available at:
> >   https://github.com/jgunthorpe/rdma-plumbing
> 
> The simple git pull from v2 on master fails. Do I need to clone it
> again?

The tree is still in the rebase phase, so 'git fetch --all' followed
by 'git reset --hard origin/master' or 'git rebase -i origin/master +
fiddling' to preserve local commits

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
