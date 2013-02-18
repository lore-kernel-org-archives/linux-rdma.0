From: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add  ib_resolve_noderecord_via  API
Date: Mon, 18 Feb 2013 13:59:31 -0800
Message-ID: <5122A443.9080404@oracle.com>
References: <511AA890.8050106@oracle.com> <20130212152859.b62c4d6df7bd5bf0a393fa4a@llnl.gov> <511AD1EB.8070807@oracle.com> <20130212154949.2ff378f25c6cce7e6119137c@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130212154949.2ff378f25c6cce7e6119137c-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: HANLIN.QIAN-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, "Jia Shi (E-mail)" <JIA.SHI-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ira & Hal,

I have talked to my management about this wrapper and decided to add it to our code instead of libibmad, so for now I am dropping the merge request.

Thanks
Sarat


On 2/12/2013 3:49 PM, Ira Weiny wrote:
> On Tue, 12 Feb 2013 15:36:11 -0800
> Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
>>
>>
>> On 2/12/2013 3:28 PM, Ira Weiny wrote:
>>> On Tue, 12 Feb 2013 12:39:44 -0800
>>> Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>> Add ib_resolve_noderecord_via wrapper similar to ib_resolve_portid_str_via
>>>
>>> I have a more fundamental question: Do you have a use case for this?
>>>
>>> Ira
>>>
>> The main purpose of this wrapper to make ib_resolve_noderecord_via as a single API call to resolve a node by looking at node record.
>
> But this does not actually "resolve" anything.  AFAICT it just returns if a NodeRecord exists.
>
> Ira
>
>>  From oracle's point of view since we have
>> already included the name and signature of this ib_resolve_noderecord_via in our executable we thought it would be helpful to have this wrapper so that we can just drop the new
>> library without changing/rebuilding our binaries.
>>
>> Thanks
>> Sarat
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
