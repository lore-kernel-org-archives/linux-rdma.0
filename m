From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure
 dynamic
Date: Tue, 17 May 2016 09:19:51 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605170918080.9956@east.gentwo.org>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com> <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com> <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org> <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com>
 <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org> <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com> <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org> <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <102cd100-55f7-fa85-cd75-ba0db5b9fa34-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Mon, 16 May 2016, Doug Ledford wrote:
>
> Thanks, this looks good now.  When the other two patches come through

The patch can stand on its own and there has been the expectation
expressed by Mellanox that they want to see this merged first. Guess this
is to reduce the amount of rewrite they would have to do if things change.
Then also the team from Mellanox can directly merge the driver changes
without my involvement.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
