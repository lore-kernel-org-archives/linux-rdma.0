From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 5/5] RDMA/core: Add runchecks.cfg for
 drivers/infiniband/core
Date: Mon, 18 Dec 2017 11:03:51 -0800
Message-ID: <1513623831.31581.121.camel@perches.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <0ce3c307255b22d23f49d13213b76044647e6f60.1513430008.git-series.knut.omang@oracle.com>
         <20171218080223.GB18894@mtr-leonro.local>
         <1513600586.22938.29.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513600586.22938.29.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-12-18 at 13:36 +0100, Knut Omang wrote:
> On Mon, 2017-12-18 at 10:02 +0200, Leon Romanovsky wrote:
[]
> > Also, I agree with other reviewers, there is no excuse for adding
> > checkpatch specifics per-subsystem/folder, the differences are better
> > to be treated in checkpatch.pl itself.

What other reviewers are those?

As a checkpatch maintainer, I don't believe it's appropriate
to add many per-subsystem specific rules to checkpatch.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
