From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Thu, 12 Jan 2017 10:14:52 -0700
Message-ID: <20170112171452.GA1469@obsidianresearch.com>
References: <20170109213944.31970-1-jarod@redhat.com>
 <20170109223108.GA10850@obsidianresearch.com>
 <0e01bfc8-333d-99dd-f7d1-024422923021@redhat.com>
 <20170110161031.GB15493@obsidianresearch.com>
 <SN1PR07MB220756D06EA23CE46DEC11A2F8790@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20170112130640.GG20392@mtr-leonro.local>
 <SN1PR07MB2207AAD33488239E59339881F8790@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB2207AAD33488239E59339881F8790-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2017 at 01:15:19PM +0000, Amrani, Ram wrote:

> > They are referring to 32bit ARM in their discussion. AFAIK all devices in
> > RDMA are working and supported in 64bit ARM environment.
>  
> I understand that the thread relates to 32-bit. I wanted to make sure that it 
> doesn't impact 64-bit, as the sentence - "RDMA hardware doesn't work
> in ARM " may imply that ARM doesn't support RDMA at all and that 64-bit
> may be dropped.

hhns is already 64 bit ARM only hardware, it will be supported..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
