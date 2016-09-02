From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 9/9] ib_verbs: Add a new qp create flag to request
 features for Ethernet over IB
Date: Fri, 02 Sep 2016 07:04:30 +0200
Message-ID: <1472792670.9410.276.camel@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
         <1472774969-18997-10-git-send-email-knut.omang@oracle.com>
         <20160902021729.GE30057@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160902021729.GE30057-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-09-01 at 20:17 -0600, Jason Gunthorpe wrote:
> On Fri, Sep 02, 2016 at 02:09:29AM +0200, Knut Omang wrote:
> > Some Infiniband HCAs need to know if a QP is going to
> > be used for Ethernet over IB (EOIB).
> 
> You will have to send this after your driver. I recommend a patch
> proposing this functionality with your driver as the example
> implementation, along with a kernel user, as mellanox typically does.

It's a bit of a chicken and egg situation since the driver 
depends on the patches. If I can 'tick off' this bit soon, I can move ahead and 
get to the send the driver too.

There's not much info in the driver - it just forwards that bit to a hardware bit
and it all happens from there. But hardware needs to know when to set that bit,
as it is only valid when operating as transport for Ethernet.

Please - it would be a big help for me (saving a lot of work down the line that 
is better spent working with the community than with handling more version issues later) 
if I can get an indication that just that bit would be acceptable 8-D ...

Thanks,
Knut


> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
