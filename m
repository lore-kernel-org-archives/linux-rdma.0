From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] Indirect Fast Memory registration support
Date: Mon, 13 Oct 2014 11:01:14 +0300
Message-ID: <543B86CA.9070809@dev.mellanox.co.il>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <EE7902D3F51F404C82415C4803930ACD40C4114B@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD40C4114B-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/8/2014 2:06 PM, Devesh Sharma wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
>> Sent: Tuesday, October 07, 2014 8:18 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: bvanassche-HInyCGIudOg@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org;
>> ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
>> Subject: [PATCH RFC 0/2] Indirect Fast Memory registration support
>>
>> This patch set introduces support for registering a scattered memory area in
>> an indirect manner.
>>
>> Current supported fast registration support has a known limitation where the
>> memory must be page aligned, meaning memory scatters must be in chunks
>> of page size except the first which may be in some offset from the start of a
>> page and the last which may end before the page boundary.
>>
>> This can make life hard for ULPs which may serve a scattered list without the
>> above limitations. Two immediate examples are iSER and SRP that have some
>> extra logic or work-arounds to handle an arbitrary scatter list of buffers
>> (which is supported in the entire stack above them).
>>
>> The proposed API attempts to follow the well-known fast registration
>> scheme while allowing the ULP to pass an sg vector rather than a page list
>> (u64 vector).
>> I expect ULPs to make use of the global DMA key to populate the lkey of the
>> sg vector. for example for a scatter list sg of 3 elements the indirect ib_sge
>> vector will look like:
>> ib_sge[0]: {dma_key, sg[0]->dma_addr, sg[0]->length}
>
> Here each sge can be of max 4G like regular SGEs?

Correct. This is a normal ib_sge.

> And can lkey in each SGE be different?

Yes of course. Generally each lkey can be a different pre-registered
memory. I specifically used this example to show how a ULP would utilize
the global DMA lkey to register an arbitrary scatterlist.

>
>> ib_sge[1]: {dma_key, sg[1]->dma_addr, sg[1]->length}
>> ib_sge[2]: {dma_key, sg[2]->dma_addr, sg[2]->length}
>>

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
