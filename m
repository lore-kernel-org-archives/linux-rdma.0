From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Sun, 29 May 2016 11:13:50 +0300
Message-ID: <574AA4BE.2060207@grimberg.me>
References: <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com>
 <1AFD636B-09FC-4736-B1C5-D1D9FA0B97B0@oracle.com>
 <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il>
 <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com>
 <C0AE237D-5E5A-4F94-B717-F3A3B4B4D4A8@oracle.com>
 <574728EC.9040802@grimberg.me> <57473025.5020801@grimberg.me>
 <20160526192351.GV25500@leon.nu>
 <alpine.DEB.2.20.1605261511230.8857@east.gentwo.org>
 <574A941D.9050404@grimberg.me> <20160529071749.GB24347@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160529071749.GB24347-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Really? It's used all over the stack...
>>
>> So the suggestion is to restrict the allocation does not
>> cross the page boundary (which can easily be done with making
>> MLX4_MR_PAGES_ALIGN be PAGE_SIZE or larger than PAGE_SIZE/2)?
>
> We could simply switch to alloc_pages, e.g. something like the patch below:

Patch below? :)

> But I have to admit I really like the coherent dma mapping version,
> for all sane architectures that works much better, although it sucks
> for some architetures where dma coherent mappings cause a bit of
> overhead.

But this is specific to mlx4 which supports up 511 pages per MR, mlx5
will need a coherent allocation anyways right (it supports up to 64K
pages per MR)?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
