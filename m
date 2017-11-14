From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 0/5] Add thread domain support
Date: Tue, 14 Nov 2017 14:09:35 +0200
Message-ID: <ef4ab602-694d-f3be-9473-3fca4d97f6f2@dev.mellanox.co.il>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <20171113200651.GG22610@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113200651.GG22610-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/13/2017 10:06 PM, Jason Gunthorpe wrote:
> On Sun, Nov 12, 2017 at 11:41:38PM +0200, Yishai Hadas wrote:
>> This RFC series is based on some initial discussion that was in the mailing
>> list to support resource domain.
>>
>> The series includes detailed man pages of the suggested APIs and initial
>> patches in both verbs and mlx5 driver to demonstrate the expected usage.
>>
>> The motivation behind the series is to allow an application finer
>> grain control over share hardware resources and locks when the
>> resources are used by the same thread.
> 
> I think I'm basically fine with this approach.

Fine, good news.

> I assume you'll also add a create_cq_ex to accept a PD instead of a
> device?
> 

Future looking:
1) ibv_cq_init_attr_ex may be extended to get also parent_domain when 
there will be some driver code that will implement it, prefer not to 
introduce an un-supported API.

2) As TD may include some other properties as of core/numa information, 
need to have its creation API extended from day one by having a 
comp_mask in place.

struct ibv_td_init_attr {	
	uint32_t comp_mask;
};

struct ibv_td *ibv_alloc_td(struct ibv_context *context,
                               struct ibv_td_init_attr *attr)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
