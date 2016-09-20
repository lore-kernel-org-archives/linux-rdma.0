From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/8] Export vendors specific ABIs
Date: Tue, 20 Sep 2016 16:38:58 -0600
Message-ID: <20160920223858.GB16049@obsidianresearch.com>
References: <1474195823-10429-1-git-send-email-leon@kernel.org>
 <0b8136eb-d9da-5543-8622-482afe92e5fa@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0b8136eb-d9da-5543-8622-482afe92e5fa-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 20, 2016 at 10:32:49AM -0700, Adit Ranadive wrote:
> What happens if this shared functionality is split between multiple
> files? Can we just add them in the same folder (so
> uapi/rdma/provider-abi1.h, uapi/rdma/provider-abi2.h, etc.)?

Sure, I guess, but there should be a reasonably good reason why you
want the file split ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
