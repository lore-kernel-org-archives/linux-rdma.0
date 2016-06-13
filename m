From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Mon, 13 Jun 2016 09:23:04 -0400 (EDT)
Message-ID: <413325551.41981776.1465824184380.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Monday, June 13, 2016 2:32:53 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> On 06/12/2016 03:40 PM, Laurence Oberman wrote:
> > Jun  8 10:12:52 jumpclient kernel: mlx5_core 0000:08:00.1: swiotlb buffer
> > is full (sz: 266240 bytes)
> > Jun  8 10:12:52 jumpclient kernel: swiotlb: coherent allocation failed for
> > device 0000:08:00.1 size=266240
> 
> Hello,
> 
> I think the above means that the coherent memory allocation succeeded
> but that the test dev_addr + size - 1 <= DMA_BIT_MASK(32) failed. Can
> someone from Mellanox tell us whether or not it would be safe to set
> coherent_dma_mask to DMA_BIT_MASK(64) for the mlx4 and mlx5 drivers?
> 
> Thanks,
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Leon

Are you able to answer Bart's question here re the possibility of using DMA_BIT_MASK(64)
For now I have disabled this warning and dump stack while I continue to test.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
