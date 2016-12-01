From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] ibverbs: Allow vendor data response in
 create_ah command
Date: Thu, 1 Dec 2016 09:40:56 -0700
Message-ID: <20161201164056.GB24190@obsidianresearch.com>
References: <1480602353-8600-1-git-send-email-yishaih@mellanox.com>
 <1480602353-8600-2-git-send-email-yishaih@mellanox.com>
 <20161201160058.GA22216@obsidianresearch.com>
 <c9eb6ee8-e3ca-a540-82f5-0b3580b00c78@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c9eb6ee8-e3ca-a540-82f5-0b3580b00c78-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 01, 2016 at 06:30:05PM +0200, Yishai Hadas wrote:
> >> int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
> >>-		      struct ibv_ah_attr *attr)
> >>+		      struct ibv_ah_attr *attr,
> >>+		      struct ibv_create_ah_resp *resp,
> >>+		      size_t resp_size)
> >
> >NAK without changing the name of this function..
> >
> >We need to decide if we want to have comapt for ibv_cmd_ driver facing
> >entry points, or discard that idea now that we only have one tree.
> 
> The idea was that moving to one tree can drop the need to maintain 2
> different symbols, all vendors around where changed to use the new command.
> As this API is not used directly by an applications I don't see a real need
> for 2 APIs.

I'm fine with that, but we still need to change the dynamic link
symbol name when the signature is changed to ensure dynamlic linking
of wrong providers fails.

This might just be as simple as moving ibv_cmd_create_ah from
IBVERBS_1.0 to IBVERBS_1.4 in the .map file. Please test and confirm.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
