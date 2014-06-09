From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 00/24] Series short description
Date: Mon, 9 Jun 2014 09:11:45 -0400
Message-ID: <5395B291.9050501@netapp.com>
References: <20140528142521.23214.39655.stgit@manet.1015granger.net>	<005501cf7b5f$4e4359a0$eaca0ce0$@opengridcomputing.com> <CAJZOPZ+SBT=yX3v4kvzg4TsZU2=L-05r3=ht-4y86Ox44M3mpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+SBT=yX3v4kvzg4TsZU2=L-05r3=ht-4y86Ox44M3mpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/09/2014 05:55 AM, Or Gerlitz wrote:
> On Thu, May 29, 2014 at 7:59 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>> I tested this series over cxgb4 and mlx4, running cthon04, fio read/rand-rw, and xfstests, and over mthca cthon04.  No regressions.
> 
> Steve, Chuck, all
> 
> Where this series stands? I don't see it in Roland's tree for-next
> branch... is this planned to go upstream through another maintainer
> tree? if not, I think we're good to go, so Roland, are you picking it
> up?
> 
> Or.

This is going through the NFS tree (Trond should already have it).

Anna
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
