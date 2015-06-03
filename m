From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: NFSoRDMA bi-weekly developers meeting minutes (5/28/15)
Date: Wed, 3 Jun 2015 12:55:18 -0400
Message-ID: <20150603165518.GB8441@fieldses.org>
References: <55675A52.1010700@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55675A52.1010700-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Charles EDWARD Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org" <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dominique.martinet-KCE40YydGKI@public.gmane.org" <dominique.martinet-KCE40YydGKI@public.gmane.org>, "jeffrey.c.becker-NSQ8wuThN14@public.gmane.org" <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "skc-YOWKrPYUwWM@public.gmane.org" <skc-YOWKrPYUwWM@public.gmane.org>, "sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 11:11:30AM -0700, Shirley Ma wrote:
> NFSD workqueue mode vs. threading mode performance impacts: (Shirley)
> ---------------------------------------------------------------------
> Shirley has spent sometime test/fix/evaluating NFSD workqueue mode
> originally implemented by Jeff Layton. NFSD workqueue patchset NFSD
> workqueue modes benefit some workloads while global threading mode
> benefits some other workloads. workqueue mode is better than per-cpu
> threading mode in general. workqueue is per-cpu workqueue while global
> threading mode is not per-cpu based. There might be some room to make
> NFSD workqueue not worse than global threading mode, but this requires
> to do more in depth performance investigation work.
> 
> Feel free to reply here for anything missing or incorrect. Thanks
> everyone for joining the call and providing valuable inputs/work to
> the community to make NFSoRDMA better.

Are you planning to repost those patches to the list with a summary of
the results so far?

I don't necessarily expect that we'll have all performance problems
worked out before merging, but we do need to judge the risk that the new
threading mode never overcomes those regressions so that we're stuck
supporting both old and new threading modes indefinitely.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
