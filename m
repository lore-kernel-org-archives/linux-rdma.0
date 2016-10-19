From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Introduction of libqedr to the Consolidated Userspace RDMA
 Library Repo
Date: Wed, 19 Oct 2016 11:24:10 -0600
Message-ID: <20161019172410.GB29879@obsidianresearch.com>
References: <SN1PR07MB22073DF8F016A275DA036F8EF8C70@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161006163427.GG1224@obsidianresearch.com>
 <SN1PR07MB2207B8BA2C9C9A1FC610DE9FF8D90@SN1PR07MB2207.namprd07.prod.outlook.com>
 <SN1PR07MB22074FE9B280DDDCE439FBA9F8DC0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161013162942.GA5468@obsidianresearch.com>
 <SN1PR07MB220745646BCC093BCB5A4553F8DF0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161014164229.GB6258@obsidianresearch.com>
 <SN1PR07MB220719CE0C668A321520311DF8D20@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB220719CE0C668A321520311DF8D20-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 04:08:12PM +0000, Amrani, Ram wrote:
> Hi Jason,
> I've created a user account on github, forked rdma_plumbing and added libqedr in multiple patches,
> after I've verified that it builds warning free and in-line with previous cleanups.
> I've sent a pull request to linux-rdma rather than rdma-plumbing. Is that OK?

So far so good.

As Leon said, post your patches to the mailing list.

You also need to make sure it builds, Travis says the 32 bit builds
are no good (look at the pull request and click on the red X)

The github process from here is to make changes and then update your
branch on your github, that will reflect in the pull request. Eg you
can immediately fix the 32 bit issues and see that travis goes green.

I left some minor notes for you on github, the build system stuff
looks fine to me, and I didn't notice anything too unusual in a casual
browse. Didn't check if the code was any good..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
