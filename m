From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Introduction of libqedr to the Consolidated Userspace RDMA
 Library Repo
Date: Thu, 6 Oct 2016 10:34:27 -0600
Message-ID: <20161006163427.GG1224@obsidianresearch.com>
References: <SN1PR07MB22073DF8F016A275DA036F8EF8C70@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22073DF8F016A275DA036F8EF8C70-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 06, 2016 at 08:08:29AM +0000, Amrani, Ram wrote:
> Hi Jason,
> Yesterday the qedr (Qlogic Everest Driver for RDMA) patch was sent.

> Even before it being accepted I would like to start working on
> preparing and adding our user space library for qedr (libqedr) to
> the consolidated userspace RDMA library repo.  I see that a lot of
> work is being done by you and so I want to understand how to prepare
> the code, what is the process and when is a good time to join.

Hi Ram,

If you prepare a branch of rdma-core on github I can give it a quick
look over.

The technical steps are fairly simple, create a
provider/qedr directory, add your source code, copy the CMakeLists.txt
style from another provider, add a line to the sorted list in the top
level CMakeLists.txt, update README.md, COPYING.md and MAINTAINERS

You will want to look at the various patches I've prepared and ensure
you cover off the basic cleanups that have already been done, and that
your code compiles warning-free on FC24.

Once you feel everything is ready then post it to the mailing list and
send a pull request. For the mailing list you can just split the
patches by file..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
