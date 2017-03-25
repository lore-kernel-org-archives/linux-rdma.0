From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/iser: Fix possible mr leak on device removal event
Date: Fri, 24 Mar 2017 22:31:38 -0400
Message-ID: <1490409098.2404.41.camel@redhat.com>
References: <1488219394-11720-1-git-send-email-sagi@grimberg.me>
         <e2a87fd9-8035-95b3-20de-2389340b9955@mellanox.com>
         <CY1PR12MB0774ECB94ADDD459809F74EABC560@CY1PR12MB0774.namprd12.prod.outlook.com>
         <CY1PR12MB077458DBD4D7EA18751C40BFBC230@CY1PR12MB0774.namprd12.prod.outlook.com>
         <3c42066d-e5b0-fcb8-c434-e5aa2d7c52b9@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3c42066d-e5b0-fcb8-c434-e5aa2d7c52b9-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-13 at 10:06 +0200, Sagi Grimberg wrote:
> > 
> > Hi Sagi,
> 
> Hi Raju,
> 
> > 
> > Can we expect this patch in next rc ?
> 
> I hope so,
> 
> Doug, care to get it in the next -rc pull request?

Done.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
