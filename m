From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Thu, 18 Aug 2016 13:02:21 +0300
Message-ID: <27c4b5b8-a244-abda-9759-3554bdcd0717@dev.mellanox.co.il>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
 <10ce4067-7657-7898-cbb0-92327e254d0d@mellanox.com>
 <445de9a4-1132-3e5e-07ae-cfe60e26cd30@dev.mellanox.co.il>
 <9baa7044-2108-cb36-b25c-0d6349f95385@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9baa7044-2108-cb36-b25c-0d6349f95385-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/18/2016 11:28 AM, Or Gerlitz wrote:
> On 8/18/2016 10:26 AM, Yishai Hadas wrote:
>> n 8/18/2016 9:11 AM, Or Gerlitz wrote:
>>> On 7/28/2016 3:19 PM, Yishai Hadas wrote:
>>>> +        struct {
>>>> +            void               *hdr;
>>>> +            uint16_t        hdr_sz;
>>>> +            uint16_t        mss;
>>>> +        } tso;
>>>
>>> can't this be placed within the struct ibv_send_wr :: wr union ?
>>
>> No, union 'wr' includes 'ud' which may be used potentially with TSO.
>> This is not the case for bind_mw, see commit message as well.
>
>
> FWIW, doing this as the below, AFAIU doesn't enlarge the wr union, thoughts?
>
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index ccf1d51..6652750 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -795,8 +795,17 @@ struct ibv_send_wr {
>                         struct ibv_ah  *ah;
>                         uint32_t        remote_qpn;
>                         uint32_t        remote_qkey;
> +                       void            *hdr;
> +                       uint16_t        hdr_sz;
> +                       uint16_t        mss;
>                 } ud;
> +               struct {
> +                       void            *hdr;
> +                       uint16_t        hdr_sz;
> +                       uint16_t        mss;
> +               } lso_raw;

No reason to duplicate, better put in one place as introduced by the patch.

>         } wr;
> +
>         union {
>                 struct {
>                         uint32_t    remote_srqn;
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
