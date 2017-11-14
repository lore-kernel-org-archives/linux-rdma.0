From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 0/5] Add thread domain support
Date: Tue, 14 Nov 2017 12:18:30 -0700
Message-ID: <20171114191830.GJ4263@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <20171113200651.GG22610@ziepe.ca>
 <ef4ab602-694d-f3be-9473-3fca4d97f6f2@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ef4ab602-694d-f3be-9473-3fca4d97f6f2-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:09:35PM +0200, Yishai Hadas wrote:
> On 11/13/2017 10:06 PM, Jason Gunthorpe wrote:

> 2) As TD may include some other properties as of core/numa information, need
> to have its creation API extended from day one by having a comp_mask in
> place.
> 
> struct ibv_td_init_attr {	
> 	uint32_t comp_mask;
> };

Yes OK, let's do that

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
