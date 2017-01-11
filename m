From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/vmw_pvrdma: Dont hardcode QP header page
Date: Wed, 11 Jan 2017 14:27:31 -0800
Message-ID: <258eb6bc-1322-e30e-7571-bd214975a08d@vmware.com>
References: <cover.1484075557.git.aditr@vmware.com>
 <2035e9eca59810687d9b53d7d6e603b765729b1f.1484075557.git.aditr@vmware.com>
 <20170111070952.GB5620@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111070952.GB5620-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 09:09:53AM +0200, Yuval Shaia wrote:
> On Tue, Jan 10, 2017 at 11:15:41AM -0800, Adit Ranadive wrote:
> > Moved the header page count to a macro [1]. In a future patch we will
> > separate out the allocation for the header page. Thanks Yuval.
> > Also, clear out the alloc_ucontext user response [2]. Thanks Dan.
> 
> Though i appreciate the above acknowledgment i'm not sure it can be part of
> the commit message.

Okay.

Doug, if possible please update the commit message as follows:
--
Moved the header page count to a macro. Also, clear out the alloc_ucontext
user response.
--

If you prefer I can send a new series with the updated message.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
