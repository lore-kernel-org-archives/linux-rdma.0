From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/4] IB/core: Infra-structure to support verbs
 extensions through uverbs
Date: Wed, 26 Jun 2013 18:34:01 +0300
Message-ID: <51CB09E9.3060307@mellanox.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com> <1372251464-13394-3-git-send-email-ogerlitz@mellanox.com> <CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=t_dhV_ZA9MA@mail.gmail.com> <51CB05F3.3040409@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CB05F3.3040409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26/06/2013 18:17, Or Gerlitz wrote:
>
> Based on the bits set in the comp mask and the in_words field value, 
> the kernel which has cmdX_v2 can work towards older user space 
> libraries/applications e.g cmdX_v1 and cmdX_v0
>
> The comp mask is not part of the header, but rather the 1st field of 
> every uverbs command and response, here, in this series, it was added 
> in patch 3/4 for the uverbs flow-steering structures which are cmdX_v0 
> in this context.

The comp mask biz logic is also explained in Tzahi's OFA 2013 talk on 
verbs extensions, he is referring their to extending libibverbs API in 
user space towards applications but the concept is the same, slides here 
https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/549-extending-verbs-api.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
