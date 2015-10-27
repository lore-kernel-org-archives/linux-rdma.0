From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] mlx4: Expose correct max_sge_rd limit
Date: Tue, 27 Oct 2015 18:12:35 +0200
Message-ID: <562FA273.5090700@mellanox.com>
References: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
 <1445938846-9240-2-git-send-email-sagig@mellanox.com>
 <562F8C8F.8040000@mellanox.com> <562FA05F.4050805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562FA05F.4050805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/27/2015 6:03 PM, Sagi Grimberg wrote:
> So from my discussions with the HW folks a RDMA_READ wqe cannot exceed
> 512B. The wqe control segment is 16 bytes, the rdma section is 12 bytes
> (rkey + raddr) and each sge is 16 bytes so the computation is:
>
> (512B-16B-12B)/16B = 30. 

But AFAIR, the magic number was 28... how this goes hand in hand with 
your findings?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
