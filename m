From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next 0/8] Export device and port properties
Date: Thu, 24 Aug 2017 16:07:47 -0400
Message-ID: <1503605267.78641.40.camel@redhat.com>
References: <20170815091431.12822-1-leon@kernel.org>
         <20170823162718.GS1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823162718.GS1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-23 at 19:27 +0300, Leon Romanovsky wrote:
> On Tue, Aug 15, 2017 at 12:14:23PM +0300, Leon Romanovsky wrote:
> > Hi,
> > 
> > This is the third part of RDMAtool infrastructure changes. In this
> > series,
> > I'm exporting various device and port properties which are parsed
> > in
> > RDMAtool.
> > 
> > Due to the fact, that the "IB/hfi1: Document phys port state bits
> > not
> > used in IB", I embed its content into the actual patches.
> > 
> > As part of this series, I performed small code cleanup to improve
> > our
> > static checker situation.
> > 
> > Thanks
> > 
> > Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > ----------------------------------------------------------------
> 
> Doug,
> To be clear, this PR is not needed.

Dropped.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
