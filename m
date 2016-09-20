From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/8] Export vendors specific ABIs
Date: Tue, 20 Sep 2016 10:32:49 -0700
Message-ID: <0b8136eb-d9da-5543-8622-482afe92e5fa@vmware.com>
References: <1474195823-10429-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474195823-10429-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun Sep 18 2016 03:50:15 GMT-0700 (PDT), Leon Romanovsky wrote:
> The consolidate library revealed the fact that vendor specific
> structures and defines are copy/pasted between kernel and user-space.
> 
> This patch set moves these headers from internal driver directory to common
> place and unifies their name to be drivername-abi.h, so it will be easily shared
> by numerous libraries supported in https://github.com/linux-rdma/rdma-core
> 

I had asked this to Leon offline but he recommended to ask on the ML.

What happens if this shared functionality is split between multiple files? Can we 
just add them in the same folder (so uapi/rdma/provider-abi1.h,
uapi/rdma/provider-abi2.h, etc.)?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
