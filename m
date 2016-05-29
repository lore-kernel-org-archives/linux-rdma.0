From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Sun, 29 May 2016 11:37:13 +0300
Message-ID: <574AAA39.3000708@grimberg.me>
References: <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il>
 <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com>
 <C0AE237D-5E5A-4F94-B717-F3A3B4B4D4A8@oracle.com>
 <574728EC.9040802@grimberg.me> <57473025.5020801@grimberg.me>
 <20160526192351.GV25500@leon.nu>
 <alpine.DEB.2.20.1605261511230.8857@east.gentwo.org>
 <574A941D.9050404@grimberg.me> <20160529071749.GB24347@infradead.org>
 <574AA4BE.2060207@grimberg.me> <20160529081527.GA5839@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160529081527.GA5839-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> But this is specific to mlx4 which supports up 511 pages per MR, mlx5
>> will need a coherent allocation anyways right (it supports up to 64K
>> pages per MR)?
>
> Why does that make a difference?

Chuck's original bug report said that the problem with the current
code is that dma_map_single expects the pages array to fit in a single
page:

"
See what mlx4_alloc_priv_pages does with this memory
allocation:

   mr->page_map = dma_map_single(device->dma_device, mr->pages,
                                 size, DMA_TO_DEVICE);

dma_map_single() expects the mr->pages allocation to fit
on a single page, as far as I can tell.
"

But when I revisited dma_map_single in some archs I didn't
see this expectation. So actually now I don't really see what
is the problem in the first place (or how your patch fixes it)...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
