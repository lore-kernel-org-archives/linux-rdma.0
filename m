From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Fri, 7 Aug 2015 00:05:35 -0700
Message-ID: <20150807070535.GA25586@infradead.org>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
 <55C38F74.7070200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55C38F74.7070200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 06, 2015 at 07:46:44PM +0300, Sagi Grimberg wrote:
> I agree that this is a shame to keep in here for everyone to carry...
> The only driver I've seen supporting XRC is mlx5 with no consumers.
> 
> If people are reluctant to remove it, you can put it in ib_xrc_send_wr
> or something...

If'll send a patch to remove it, and then we can introduce
ib_xrc_send_wr once users show up.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
