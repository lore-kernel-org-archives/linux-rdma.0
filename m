From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core] util: fix bad argument passed to
 s390_mmio_write
Date: Mon, 21 Aug 2017 16:26:33 +0200
Message-ID: <75eaeecd-68f0-ac8f-a948-e972ed9d5ec9@suse.de>
References: <a30f4084-1f1b-44c3-ac03-c627586e0604@suse.de>
 <20170804153528.GB9472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804153528.GB9472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

This is an easy enough compilation fix.
Could we get it in for v15 ?

Nicolas

Le 04/08/2017 à 17:35, Jason Gunthorpe a écrit :
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> On Fri, Aug 04, 2017 at 11:20:47AM +0200, Nicolas Morey-Chaisemartin wrote:
>> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
>>  util/mmio.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/util/mmio.h b/util/mmio.h
>> index be22fb76..101af9dd 100644
>> +++ b/util/mmio.h
>> @@ -208,7 +208,7 @@ __le64 mmio_read64_le(const void *addr);
>>  #ifdef __s390x__
>>  static inline void mmio_memcpy_x64(void *dest, const void *src, size_t bytecnt)
>>  {
>> -	s390_mmio_write(addr, src, bytecnt);
>> +	s390_mmio_write(dest, src, bytecnt);
>>  }
>>  #else
>>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
