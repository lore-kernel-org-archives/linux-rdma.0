From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 01/24] IB/core: Introduce new fast registration API
Date: Tue, 29 Sep 2015 09:42:36 +0300
Message-ID: <560A32DC.4040808@mellanox.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <1442482947-27785-2-git-send-email-sagig@mellanox.com>
 <5601C65F.8060403@sandisk.com> <5603A841.70509@dev.mellanox.co.il>
 <5609A9D0.8030607@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5609A9D0.8030607-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/28/2015 11:57 PM, Bart Van Assche wrote:
> On 09/24/2015 12:37 AM, Sagi Grimberg wrote:
>> On 9/23/2015 12:21 AM, Bart Van Assche wrote:
>>> On 09/17/2015 02:42 AM, Sagi Grimberg wrote:
>>>> +            } else if (last_page_off + dma_len < mr->page_size) {
>>>> +                /* chunk this fragment with the last */
>>>> +                last_end_dma_addr += dma_len;
>>>> +                last_page_off += dma_len;
>>>> +                mr->length += dma_len;
>>>> +                continue;
>>>
>>> Shouldn't this code update last_page_addr ?
>>
>> Actually I think it doesn't since it is only relevant for the else
>> statement where we are passing the page_size boundary.
>
> Hello Sagi,
>
> Suppose that the following sg-list is passed to this function as {
> offset, length } pairs and that this list has not been coalesced by the
> DMA mapping code: [ { 0, page_size / 4 }, { page_size / 4, page_size / 4
> }, { 2 * page_size / 4, page_size / 2 } ]. I think the algorithm in
> patch 01/24 will map the above sample sg-list onto two pages. Shouldn't
> that sg-list be mapped onto one page instead ?

It seems to... In order to get that correct we'd need to change the
condition to (last_page_off + dma_len <= mr->page_size)

I'll change for v2.

Thanks.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
