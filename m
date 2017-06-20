From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Tue, 20 Jun 2017 14:23:21 -0400
Message-ID: <C27E2410-44B7-451E-8069-DF1444048158@oracle.com>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net> <20170620073236.GO17846@mtr-leonro.local> <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com> <20170620180348.GV17846@mtr-leonro.local>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170620180348.GV17846-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: doug.ledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Jun 20, 2017, at 2:03 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> On Tue, Jun 20, 2017 at 11:43:56AM -0400, Chuck Lever wrote:
>> Hi Leon-
>> 
>> 
>>> On Jun 20, 2017, at 3:32 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> 
>>> On Mon, Jun 19, 2017 at 11:26:40AM -0400, Chuck Lever wrote:
>>>> The fourth parameter of the module_param_named macro is a set of
>>>> file permissions. Passing 0 there means that module parameter is
>>>> not created and that adding "options ib_core force_mr=1" to a
>>>> modprobe.conf file has no effect.
>>>> 
>>>> The default setting of rdma_rw_force_mr continues to be 0, or false.
>>>> 
>>>> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
>>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>> Hi Doug-
>>>> 
>>>> This doesn't seem appropriate to go through Bruce's tree for 4.13.
>>>> 
>>>> Last discussion didn't seem to conclude with full consensus.
>>>> Probably people don't care enough one way or another. But I'd like
>>>> to see this get fixed if there aren't strong objections. Would you
>>>> take it for 4.13?
>>> 
>>> I care and believe that it should be removed from exposure to users.
>>> The variable force_mr should be leaved in the code for the debug,
>>> but module_param should be removed.
>> 
>> I don't understand the technical grounds of your objection.
>> Why is
>> 
>> options mlx4_core internal_err_reset=0
>> 
>> acceptable, but
>> 
>> options ib_core force_mr=1
>> 
>> not?
> 
> That mlx4 variable was exposed before I started to follow after
> Mellanox's submissions.
> 
> The force_mr parameter is for debug of new ULP and/or conversion of
> existing ULP to RW API. This is not very common situation and it is
> for the developers and not for the users.

No disagreement on that, but that's still not an argument
not to expose it. What is the risk, as you see it?


> Thanks
> 
>> 
>> 
>>> Thanks
>>> 
>>> 
>>>> 
>>>> 
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

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
