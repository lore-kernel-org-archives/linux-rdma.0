From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 13/16] Remove Debian and RPM packaging files
Date: Wed, 21 Sep 2016 09:52:39 -0600
Message-ID: <20160921155239.GB1510@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474409425-15769-14-git-send-email-jgunthorpe@obsidianresearch.com>
 <2447bfda-5a48-18db-94b3-d031d5913a8e@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2447bfda-5a48-18db-94b3-d031d5913a8e-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 21, 2016 at 05:00:41PM +0300, Yishai Hadas wrote:
> On 9/21/2016 1:10 AM, Jason Gunthorpe wrote:
> >These no longer apply to the combined build.
> 
> Taking this patch without introducing an alternative leaves the system
> without an option to build RPMs as it removes all packaging files.

The packaging was largely broken at the merge commit when we renamed
the sub trees. It was rendered totally useless by commit 11 which
deleted the build system it relied on. There is no reason to keep the
files at this point in the git history.

> What is the plan here ?

As I explined in the cover letter my preview tree contains
RPM and DEB packaging. It will take a bit before all the prerequists
for those patches go through the review process. Use my preview tree
to test packaging please.

This is only the first 16 out of 80 patches.

> In addition, did we come to a decision re having RPM per component ?

This is not our decision. The distros will follow their internal
policies. I recommend the layout seen in the debian/ sample packaging.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
