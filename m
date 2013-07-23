From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Tue, 23 Jul 2013 16:47:15 +0200
Message-ID: <51EE9773.9050003@acm.org>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com> <1374153931-7313-8-git-send-email-ogerlitz@mellanox.com> <51ED1B8E.7070703@acm.org> <51ED2F97.2080400@mellanox.com> <51EE6FFE.8040802@acm.org> <CAJZOPZ+1TLQ-vwsZG8dgxhP332CQeDNOWfzGRdTbwRxLRhL95w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+1TLQ-vwsZG8dgxhP332CQeDNOWfzGRdTbwRxLRhL95w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/23/13 16:21, Or Gerlitz wrote:
> Bart, iSER's FMR and FRWR code works under the assumption that an SG
> list is "4K aligned". For SGs which don't obey that assumption we're
> using bounce buffer.
>
> Note that the SG "page" size used by FMRs/FRWRs doesn't have to be 1:1
> with the OS page size, so in that respect && down the road, we will
> get rid of the bounce buffer thing with having another FMR/FRWR pool
> whose "page" size is 512B and will be used for SG which are not "4K
> aligned".

Sorry but I had overlooked the bounce buffer patch. Regarding page 
sizes: is an InfiniBand HCA required to support a page size of 512 bytes 
? To me it seems like the smallest page size supported by e.g. the 
ocrdma driver is 4KB. From ocrdma_query_device():

	attr->page_size_cap = 0xffff000;

Still regarding page sizes: shouldn't ib_alloc_fast_reg_page_list() and 
ib_alloc_fast_reg_mr() multiply the SG list length by PAGE_SIZE / 
SIZE_4K to compensate for page size differences on architectures where 
virtual memory pages are larger than 4KB ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
