From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: intel iommu causing performance drop in mlx4 ipoib (OFFLIST)
Date: Mon, 16 May 2016 15:46:04 +0300
Message-ID: <5739C10C.6040805@kyup.com>
References: <5739A347.20807@kyup.com>
 <1463396094.2484.194.camel@infradead.org> <5739BEEC.3070308@kyup.com>
 <1463402381.2484.202.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463402381.2484.202.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/16/2016 03:39 PM, David Woodhouse wrote:
> On Mon, 2016-05-16 at 15:37 +0300, Nikolay Borisov wrote:
>>
>> Oops, turned out I had intel_iommu=on, though I'm sure some days ago I
>> didn't and performance suffered. I now tried with this option removed
>> and performance is again back to normal. All in all this driver +
>> intel_iommu is a bad combination I guess. Anyway, sorry for the noise
>> and thanks for the prompt reply.
> 
> I would be very interested to see your results with the latest code
> from git://git.infradead.org/intel-iommu.git (and with the IOMMU still
> enabled).

Would I be able to apply this cleanly on 4.4, since this is the version
I'm currently using?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
