From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v3 1/3] Add new call ibv_cmd_create_ah_ex
 which supports extra parameters
Date: Tue, 20 Sep 2016 09:51:36 -0600
Message-ID: <20160920155136.GF32020@obsidianresearch.com>
References: <cover.b0b7418bec346c028215053b3e58e097aa822563.1474352400.git-series.knut.omang@oracle.com>
 <d551c3792e884443903c67212f505082cd53b135.1474352400.git-series.knut.omang@oracle.com>
 <550041ef-b105-c079-068c-d96278ec34f1@dev.mellanox.co.il>
 <1474371459.8837.32.camel@oracle.com>
 <20160920132945.GO26673@leon.nu>
 <1474380350.20134.162.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474380350.20134.162.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, ". Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 20, 2016 at 04:05:50PM +0200, Knut Omang wrote:

> The problem is that libsif is stuck under a BSD only license imposed by 
> the first set of lawyers involved, and to be compatible, we need it 
> to be dual license GPLv2 + BSD like the rest of the provider libraries.

Here is some (not a lawyer) information you may find helpful.

Oracle is an OFA member and part of the purpose of groups of OFA is to
manage license issues across companies collaborating on the same code
base. Oracle will have agreed to various things on this topic when
they became a member. The OFA may be able to help you with your legal.

The OFA may choose to not distribute improperly licensed code in
OFED/etc.

GPLv2 compatability is important. Not just for the consolidated tree,
but for everyone. Distors will have complicated questions if asked to
ship a GPLv2 incompatible plugin at the same time as shipping a GPLv2
program that uses the plugin. You may find your module undistributed.

That said, it is widely regarded that the BSD 2 and 3 clause license
varients are GPLv2 compatible on their own without any additional
language.

My view on the OFA dual license scheme is that it is used to
provide absolute certainty that the code is GPLv2 compatible.
Many other projects rely on the compatibility without being explicit.

I would have no objection to a BSD 2/3 clause licensed provider in the
consolidated tree.  (while being confused why adding the GPLv2 option
is such a difficult problem, and re-emphasising the view that the code
will be used and distributed under the GPLv2 in some situations.)

A GPLv2 incompatible option like the CDDL, Apache license, etc is not
acceptable. Do not get creative and add new clauses to the stanard BSD
license.

So, in short, I would urge you to work with your legal to use the OFA
dual license. If that is completely impossible then a standard BSD
license will work to some degree. Remember, it is very hard to change
licenses after the fact.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
