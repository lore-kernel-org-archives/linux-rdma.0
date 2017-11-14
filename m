From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 5/5] mlx5: Handles QP creation with a given
 parent domain
Date: Tue, 14 Nov 2017 13:23:39 +0200
Message-ID: <8cda3f4e-d427-6703-48dc-502eb3314c78@dev.mellanox.co.il>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-6-git-send-email-yishaih@mellanox.com>
 <20171113200518.GF22610@ziepe.ca>
 <CAFgAxU_ZPcB-oZ6DrDtHdVeOpT5S_CTvYxn4VUcU3t7S4PCJHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFgAxU_ZPcB-oZ6DrDtHdVeOpT5S_CTvYxn4VUcU3t7S4PCJHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/13/2017 10:24 PM, Alex Rosenbaum wrote:
> On Mon, Nov 13, 2017 at 10:05 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>> On Sun, Nov 12, 2017 at 11:41:43PM +0200, Yishai Hadas wrote:
>>
>> I thought the plan was to have API entry points under mlx5dv to
>> access and set the UAR on the TD? Is that still the case?
> 
> It is not needed for now. the UAR index maps nicely to the td object.

Correct, see patch #3 around TD creation which maps UAR to a TD. (i.e 
mlx5_attach_dedicated_bf()). Application will not control which UAR 
index will be used but will control the option to share same UAR between 
QPs by using same TD object upon QP creation.

> the uar index hint was needed for cases where there are very few uar's
> in the HW to allocate for potential too many threads.
> 
> we will expose the MAX uar's available for a context via DV API.
>

Correct, this will give the application an hint what is the max 
ibv_td(s) that can be created as each of is mapped to a dedicated UAR 
under the cover. As this is some mlx5 specification implementation 
detail it will be exposed by the DV API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
