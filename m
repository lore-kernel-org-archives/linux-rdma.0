From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Mon, 15 May 2017 13:22:59 -0400
Message-ID: <AE3152CC-B7C8-4C51-ADDE-C3822533BB94@oracle.com>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net> <20170515145757.GI3616@mtr-leonro.local> <02AFF424-A387-47F7-BD24-61C7734B9008@oracle.com> <20170515170021.GJ3616@mtr-leonro.local>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515170021.GJ3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On May 15, 2017, at 1:00 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> On Mon, May 15, 2017 at 11:09:06AM -0400, Chuck Lever wrote:
>> 
>>> On May 15, 2017, at 10:57 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> 
>>> On Mon, May 15, 2017 at 10:52:44AM -0400, Chuck Lever wrote:
>>>> The fourth parameter of the module_param_named macro is a set of
>>>> file permissions. Passing 0 there means that module parameter is
>>>> not created and that adding "options ib_core force_mr=1" to a
>>>> modprobe.conf file has no effect.
>>>> 
>>>> The default setting of rdma_rw_force_mr continues to be 0, or false.
>>>> 
>>>> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
>>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> 
>>> Chuck,
>>> 
>>> Do we really need this parameter?
>> 
>> Hi Leon-
>> 
>> Christoph and Sagi introduced this with the new rdma_rw API.
>> The default behavior is to avoid the use of FRWR, even for
>> devices that can support FRWR but also work without. FRWR is
>> used only for iWARP devices, which require it; but FRWR can
>> have a (slight) negative performance impact, which is why it
>> is not the default.
>> 
>> The purpose of this module parameter is to enable the use of
>> FRWR for devices that can go either way, as a way to test the
>> FRWR capability when using those devices.
>> 
>> I'm not sure we _need_ to have the module parameter. But I've
>> certainly used it while developing the NFSD conversion to use
>> the rdma_rw API, since I have no iWARP devices here.
> 
> I asked that question because commit a060b5629ab0 was added a year ago
> and since then no one noticed that it is not usable, including authors.

I noticed a while ago, but haven't had time to track it down
until now.


> I think that we can safely remove it and for development, we can set
> rdma_rw_force_mr internally in the code.

It is safe to remove. Since it was never exposed to user
space due to this bug, removal would not result in a kernel
API breakage.

I find the feature useful. But it is correct to say that such
development knobs are often left to kernel compile-time, as
it is not especially useful to end users.

In this case, the module parameter is global: one has to take
some care when there are multiple HCAs in a system and they
each have different MEMMGT capabilities. Instead of removing
the setting altogether, one might replace it with a driver-
mediated per-device-port attribute.

I will let Sagi and Christoph have the last word.


> Thanks
> 
>> 
>> 
>>>> ---
>>>> drivers/infiniband/core/rw.c |    2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>> 
>>>> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
>>>> index dbfd854..1cc8f07 100644
>>>> --- a/drivers/infiniband/core/rw.c
>>>> +++ b/drivers/infiniband/core/rw.c
>>>> @@ -23,7 +23,7 @@ enum {
>>>> };
>>>> 
>>>> static bool rdma_rw_force_mr;
>>>> -module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
>>>> +module_param_named(force_mr, rdma_rw_force_mr, bool, 0644);
>>>> MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
>>>> 
>>>> /*
>>>> 
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> --
>> Chuck Lever
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
