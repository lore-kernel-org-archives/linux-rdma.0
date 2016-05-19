From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/3] ib core: Make device counter infrastructure
 dynamic
Date: Thu, 19 May 2016 09:34:33 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605190933340.15214@east.gentwo.org>
References: <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org> <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com> <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org> <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com> <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org>
 <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com> <alpine.DEB.2.20.1605170918080.9956@east.gentwo.org> <3e9a3e19-58cb-c25f-89a1-f0e51df562d8@redhat.com> <20160517170027.GC19976@obsidianresearch.com> <bc83cc75-aa2e-6fc6-e1c6-a0190b972013@redhat.com>
 <20160518172542.GA15516@obsidianresearch.com> <12e991bc-aa9b-a8b0-3cd4-b56d58a44d60@redhat.com> <alpine.DEB.2.20.1605181401030.29313@east.gentwo.org> <038401d1b143$b68b6950$23a23bf0$@opengridcomputing.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <038401d1b143$b68b6950$23a23bf0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Good idea. Do it. This patch enables retrieval of single values from the
drivers. The way that a driver implements that is beyond the scope of
this patch.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
