From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 09/30] IB/core: Modify ib_verbs and cma in order to use
 roce_gid_cache
Date: Sun, 22 Feb 2015 09:41:21 +0200
Message-ID: <54E98821.6070305@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <f91c8ed3-f6a4-4b63-85f9-870d9687a14f@CMEXHTCAS2.ad.emulex.com>
 <54E5FB57.1090803@mellanox.com> <54E601B6.5000705@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E601B6.5000705-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 19/02/2015 17:31, Matan Barak wrote:
> On 2/19/2015 5:03 PM, Haggai Eran wrote:
>> On 20/02/2015 00:02, Somnath Kotur wrote:
>>> @@ -502,9 +547,7 @@ EXPORT_SYMBOL(ib_create_qp);
>>>   static const struct {
>>>       int            valid;
>>>       enum ib_qp_attr_mask    req_param[IB_QPT_MAX];
>>> -    enum ib_qp_attr_mask    req_param_add_eth[IB_QPT_MAX];
>>>       enum ib_qp_attr_mask    opt_param[IB_QPT_MAX];
>>> -    enum ib_qp_attr_mask    opt_param_add_eth[IB_QPT_MAX];
>>>   } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
>>>       [IB_QPS_RESET] = {
>>>           [IB_QPS_RESET] = { .valid = 1 },
>>> @@ -585,12 +628,6 @@ static const struct {
>>>                           IB_QP_MAX_DEST_RD_ATOMIC    |
>>>                           IB_QP_MIN_RNR_TIMER),
>>>               },
>>> -            .req_param_add_eth = {
>>> -                [IB_QPT_RC]  = (IB_QP_SMAC),
>>> -                [IB_QPT_UC]  = (IB_QP_SMAC),
>>> -                [IB_QPT_XRC_INI]  = (IB_QP_SMAC),
>>> -                [IB_QPT_XRC_TGT]  = (IB_QP_SMAC)
>>> -            },
>>>               .opt_param = {
>>>                    [IB_QPT_UD]  = (IB_QP_PKEY_INDEX        |
>>>                            IB_QP_QKEY),
>>> @@ -611,21 +648,7 @@ static const struct {
>>>                    [IB_QPT_GSI] = (IB_QP_PKEY_INDEX        |
>>>                            IB_QP_QKEY),
>>>                },
>>> -            .opt_param_add_eth = {
>>> -                [IB_QPT_RC]  = (IB_QP_ALT_SMAC            |
>>> -                        IB_QP_VID            |
>>> -                        IB_QP_ALT_VID),
>>> -                [IB_QPT_UC]  = (IB_QP_ALT_SMAC            |
>>> -                        IB_QP_VID            |
>>> -                        IB_QP_ALT_VID),
>>> -                [IB_QPT_XRC_INI]  = (IB_QP_ALT_SMAC            |
>>> -                        IB_QP_VID            |
>>> -                        IB_QP_ALT_VID),
>>> -                [IB_QPT_XRC_TGT]  = (IB_QP_ALT_SMAC            |
>>> -                        IB_QP_VID            |
>>> -                        IB_QP_ALT_VID)
>>> -            }
>>> -        }
>>> +        },
>>>       },
>>>       [IB_QPS_RTR]   = {
>>>           [IB_QPS_RESET] = { .valid = 1 },
>>> @@ -847,13 +870,6 @@ int ib_modify_qp_is_ok(enum ib_qp_state
>>> cur_state, enum ib_qp_state next_state,
>>>       req_param = qp_state_table[cur_state][next_state].req_param[type];
>>>       opt_param = qp_state_table[cur_state][next_state].opt_param[type];
>>>
>>> -    if (ll == IB_LINK_LAYER_ETHERNET) {
>>> -        req_param |= qp_state_table[cur_state][next_state].
>>> -            req_param_add_eth[type];
>>> -        opt_param |= qp_state_table[cur_state][next_state].
>>> -            opt_param_add_eth[type];
>>> -    }
>>> -
>>>       if ((mask & req_param) != req_param)
>>>           return 0;
>>
>> I understand this patch will remove any kernel reference to these
>> modify_qp attributes. However, what about user-space? Was it previously
>> allowed to pass in these parameters?
> 
> There was no libibverbs that declared those flags. It was filled by
> ib_resolve_eth_l2_attrs. If someone wrote a custom libibverbs that
> passed those flags, they would have just been ignored. We could replace
> them as reserved flags. What do you think?

I guess if there's no existing user space it's okay. Perhaps it would be
best to add some explicit input-checking to the ib_uverbs_modify_qp()
verb to prevent such dilemmas in the future.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
