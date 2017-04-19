From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] Add mmio_memcpy_x64
Date: Wed, 19 Apr 2017 18:54:53 +0300
Message-ID: <25ceb4ac-7f30-f725-111e-54e6db2df209@dev.mellanox.co.il>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <413a6c23-2bfe-60b6-f179-ddcb82bb19ab@dev.mellanox.co.il>
 <20170418182703.GG7181@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170418182703.GG7181-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/18/2017 9:27 PM, Jason Gunthorpe wrote:
>>> +	} else if (sizeof(*dst_p) == 4) {
>>> +		const __be32 *src_p = src;
>>> +
>>> +		do {
>>> +			mmio_write32_be(dst_p++, *src_p++);
>>> +			mmio_write32_be(dst_p++, *src_p++);
>>> +			bytecnt -= 2 * sizeof(*dst_p);
>>
>> Any reason not to write at least 64 bytes here before checking byte count
>> and looping again ?
>
> icache size? I debated doing that, but the consensus of the existing
> implementations seems to be against it..
>
> We could do a 32 byte unwind which is probably a similar icache
> footprint?
>
> What would you like?

I'm fine with leaving the code as is following the existing implementation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
