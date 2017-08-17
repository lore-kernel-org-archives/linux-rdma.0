From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] IB/core: fix duplicated code for different branches
Date: Thu, 17 Aug 2017 18:52:03 -0500
Message-ID: <3ca51638-347f-41cc-7698-42f47c4f0c3e@embeddedor.com>
References: <20170813005235.GA30629@embeddedgus>
 <20170813063156.GP24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170813063156.GP24282@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

On 08/13/2017 01:31 AM, Leon Romanovsky wrote:
> On Sat, Aug 12, 2017 at 07:52:35PM -0500, Gustavo A. R. Silva wrote:
>> Refactor code to avoid identical code for different branches.
>>
>> This issue was detected with the help of Coccinelle.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>  drivers/infiniband/core/cm.c | 4 ----
>>  1 file changed, 4 deletions(-)
>
> I see that you used the same commit message and title for many patches,
> it will be better to have description on what exactly you are removing
> and why there is no bug in that code.
>

Thank you for the suggestion.

I will add a note saying that it is up to the maintainer to verify 
whether the code is applicable or not.

The intention of the patch is to point out a duplication of code found 
by a Coccinelle script. I'm also working on similar issues reported by 
Coverity. It was tested only by compilation as I don't have the proper 
hardware to test it on.

>
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>> index 2b4d613..b46262f 100644
>> --- a/drivers/infiniband/core/cm.c
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -590,8 +590,6 @@ static struct cm_id_private * cm_insert_listen(struct cm_id_private *cm_id_priv)
>>  			link = &(*link)->rb_right;
>>  		else if (be64_lt(service_id, cur_cm_id_priv->id.service_id))
>>  			link = &(*link)->rb_left;
>> -		else if (be64_gt(service_id, cur_cm_id_priv->id.service_id))
>> -			link = &(*link)->rb_right;
>>  		else
>>  			link = &(*link)->rb_right;
>>  	}
>> @@ -619,8 +617,6 @@ static struct cm_id_private * cm_find_listen(struct ib_device *device,
>>  			node = node->rb_right;
>>  		else if (be64_lt(service_id, cm_id_priv->id.service_id))
>>  			node = node->rb_left;
>> -		else if (be64_gt(service_id, cm_id_priv->id.service_id))
>> -			node = node->rb_right;
>
> You should remove be64_gt() too.
>

Thank you for pointing it out.

>>  		else
>>  			node = node->rb_right;
>>  	}
>> --
>> 2.5.0
>>

-- 
Gustavo A. R. Silva
