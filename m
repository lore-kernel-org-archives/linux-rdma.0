From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Thu, 28 Dec 2017 14:48:10 +0800
Message-ID: <2a0a56fb-1ec8-dfc9-3c29-c9bae7bd9bae@huawei.com>
References: <1514209039-9388-1-git-send-email-liuyixian@huawei.com>
 <1514209039-9388-3-git-send-email-liuyixian@huawei.com>
 <20171226081526.GB10734@mtr-leonro.local>
 <6f657295-ab91-a940-c1d8-8d85dcedb4ea@huawei.com>
 <20171227164407.GB25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227164407.GB25436-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/12/28 0:44, Jason Gunthorpe wrote:
> On Wed, Dec 27, 2017 at 06:01:25PM +0800, Liuyixian (Eason) wrote:
>>
>>
>> On 2017/12/26 16:15, Leon Romanovsky wrote:
>>> On Mon, Dec 25, 2017 at 09:37:19PM +0800, Yixian Liu wrote:
>>>> The array defined for doorbell is not guaranteed to be 64 bit
>>>> aligned while we write it to the hardware with 64 bit
>>>> alignment required.
>>>>
>>>> This patch fixes this problem by defining a union for doorbell
>>>> to make sure it 64 bit alignment.
>>>
>>> Are you sure that it gives you alignment?
>>> The macros ALIGN/PTR_ALIGN are usually used for that.
>>
>> Hi Leon,
>>
>> I have considered your doubt combined with Jason's previous comment.
>> With a union defined with u64 member and assign the wanted value to it,
>> then we can deref *(u64 *)doorbell for the correct value.
>>
>> In this patch set, the assignment is missed.
>> Thanks for your comment and I will fix it in v2.
> 
> You are not supposed to assign to doorbell64, you are supposed to read
> from it inside hns_roce_write64_k instead of using a case.
> 
> The compiler guarentees it can read from all union members without
> causing an alignment fault, which is all we want here. It does not
> guarantee that the union is aligned to anything particular.
> 
> The v2 patch is very confusing.
> 
> Jason
> 
> 

Hi Jason,

You are right that we could read doorbell64 inside hns_roce_write64_k,
then *(u64 *) can be deleted. I will update this in patch v3.

However, in order to get a correct value (both doorbell[0] and doorbell[1]
from doorbell64, the assignment before reading it seems necessary. I have
tested the cases w/o assignment, the results verified my conclusion.

And I also find a discussion on the usage of union. It also mentions that
we can only get the "active" member from an union.
https://stackoverflow.com/questions/2310483/purpose-of-unions-in-c-and-c

-------my test code for assignment---------------------------

Case 1 without assignment:
	int main() {
		union doorbell {
		u64 db64;
		u32 db32[2];
		} db;
	
		db.db32[0] = 0xBA98;
		db.db32[1] = 0xFEDC;
	//	db.db64 = (u64)db.db32[0] << 32 | db.db32[1];

		printf("db.db32 address is %p\n", &db.db32);
		printf("db.db64 address is %p\n", &db.db64);
		printf("db.db64 value is 0x%llx\n", db.db64);
	
		return 0;
	}

*Output1 for case 1*:
	db.db32 address is 0x7ffc0654f930
	db.db64 address is 0x7ffc0654f930
	db.db64 value is 0xba98

Case 2 with assignment: Uncomment the following line in case 1:
		db.db64 = (u64)db.db32[0] << 32 | db.db32[1];

*Output2 for case 2*:
	db.db32 address is 0x7fff63293a80
	db.db64 address is 0x7fff63293a80
	db.db64 value is 0xba980000fedc
---------------end of test-----------------------------------------
Output2 is what we want to get.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
