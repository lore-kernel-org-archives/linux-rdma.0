From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Wed, 24 Jul 2013 19:47:04 +0300
Message-ID: <51F00508.10908@mellanox.com>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com> <1374153931-7313-8-git-send-email-ogerlitz@mellanox.com> <51ED1B8E.7070703@acm.org> <51ED2F97.2080400@mellanox.com> <51EE6FFE.8040802@acm.org> <CAJZOPZ+1TLQ-vwsZG8dgxhP332CQeDNOWfzGRdTbwRxLRhL95w@mail.gmail.com> <51EE9773.9050003@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51EE9773.9050003-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 23/07/2013 17:47, Bart Van Assche wrote:
>
> Sorry but I had overlooked the bounce buffer patch. Regarding page 
> sizes: is an InfiniBand HCA required to support a page size of 512 
> bytes ? To me it seems like the smallest page size supported by e.g. 
> the ocrdma driver is 4KB. From ocrdma_query_device():
>
>     attr->page_size_cap = 0xffff000;

I don't think supporting "block lists" that is pages size of 512B for 
memory registration is mandated by the IB spec, even though ConnectX2/3 
HCAs do support it,

#ibv_devinfo -v | grep page_size_cap
         page_size_cap:                  0xfffffe00

# ibv_devinfo -v | grep _id
hca_id: mlx4_0
         vendor_id:                      0x02c9
         vendor_part_id:                 26428
         board_id:                       MT_0D81120009


>
> Still regarding page sizes: shouldn't ib_alloc_fast_reg_page_list() 
> and ib_alloc_fast_reg_mr() multiply the SG list length by PAGE_SIZE / 
> SIZE_4K to compensate for page size differences on architectures where 
> virtual memory pages are larger than 4KB ?

My understanding of the API is that it assumes that the HW is capable to 
change the page shift (size) associated with certain fast_reg MR for 
each mapping.

This is indeed a bit different from the kernel FMR API where the page 
shift is provided when the FMR is created.

For mlx4, the relevant field is struct mlx4_mpt_entry->entity_size which 
is written with the page_shift provided by the ULP
for FMRs in mlx4_mr_enable and with 0 for fast_reg mrs. Later when fast 
reg WR is posted to the HW,
struct mlx4_wqe_fmr_seg->page_size is written with the page shift 
provided by the ULP and the HW treats it the same as it
was that entity_size field...

Or.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
