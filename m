From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Fri, 26 Jul 2013 11:27:05 +0200
Message-ID: <51F240E9.5000600@acm.org>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com> <1374153931-7313-8-git-send-email-ogerlitz@mellanox.com> <51ED1B8E.7070703@acm.org> <51ED2F97.2080400@mellanox.com> <51EE6FFE.8040802@acm.org> <CAJZOPZ+1TLQ-vwsZG8dgxhP332CQeDNOWfzGRdTbwRxLRhL95w@mail.gmail.com> <51EE9773.9050003@acm.org> <51F000CB.3050808@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F000CB.3050808-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/24/13 18:28, Or Gerlitz wrote:
> On 23/07/2013 17:47, Bart Van Assche wrote:
>> Still regarding page sizes: shouldn't ib_alloc_fast_reg_page_list()
>> and ib_alloc_fast_reg_mr() multiply the SG list length by PAGE_SIZE /
>> SIZE_4K to compensate for page size differences on architectures where
>> virtual memory pages are larger than 4KB ?
>
> My understanding of the API is that it assumes that the HW is capable to
> change the page shift (size) associated with certain fast_reg MR for
> each mapping.

I think you have a point here. Although I'm not sure this is what you 
had in mind, using PAGE_SIZE / PAGE_SHIFT instead of SIZE_4K / SHIFT_4K 
should work better on architectures with a page size larger than 4KB. On 
mlx4 the largest supported page list length is 511 
(MLX4_MAX_FAST_REG_PAGES). So the former option should allow to support 
larger sg lists on such architectures (up to length 511) compared to the 
latter (up to length 511/(64/4) = 31 for 64KB pages).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
