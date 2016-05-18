From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow
 steering
Date: Wed, 18 May 2016 13:12:36 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605181311460.14296@east.gentwo.org>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org> <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org> <cf61efc8-e426-dd7c-7065-e46bbfb323b0@redhat.com> <alpine.DEB.2.20.1605160853050.23895@east.gentwo.org> <2994c976-8ed1-75f9-7534-2d0e5f5303b8@redhat.com>
 <alpine.DEB.2.20.1605161123170.26453@east.gentwo.org> <9fa74108-e2f8-6a42-6d71-bf50b754734d@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9fa74108-e2f8-6a42-6d71-bf50b754734d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 18 May 2016, Doug Ledford wrote:

> > One can switch the interface into promiscuous mode in addition if one
> > wants that. Then you need CAP_NET_ADMIN.
>
> I've applied your patch.  I completely reworded the commit message,
> you'll want to check that it meets your satisfaction before I issue my
> pull request.

I wish I knew how to view the patch. Its not in the kernel.org git repo.
Could you post the patches you edit or provide a link to them. See how
Andrew Morton does it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
