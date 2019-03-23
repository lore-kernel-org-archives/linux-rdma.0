From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] infiniband: cxgb4: fix a potential NULL pointer
 dereference
Date: Sat, 23 Mar 2019 16:25:58 -0700
Message-ID: <26f51579-c9bc-372d-3659-5cf778845215@acm.org>
References: <20190309051921.15212-1-kjlu@umn.edu>
 <CC1E06D8-7817-4314-AAD4-434FEB8C4157@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CC1E06D8-7817-4314-AAD4-434FEB8C4157@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/22/19 7:37 PM, Kangjie Lu wrote:
>> On Mar 8, 2019, at 11:19 PM, Kangjie Lu <kjlu@umn.edu> wrote:
>> get_skb may fail and return NULL. The fix returns "ENOMEM"
>> when it fails to avoid NULL dereference.
>>
>> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>> ---
>> drivers/infiniband/hw/cxgb4/cm.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
>> index 8221813219e5..502a54d57e2c 100644
>> --- a/drivers/infiniband/hw/cxgb4/cm.c
>> +++ b/drivers/infiniband/hw/cxgb4/cm.c
>> @@ -1919,6 +1919,9 @@ static int send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
>> 	int win;
>>
>> 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
>> +	if (!skb)
>> +		return -ENOMEM;
>> +
> 
> Can someone review this patch? Thanks.

Hi Kangjie,

Please change the patch description to the imperative mood (see also 
https://git.kernel.org/pub/scm/git/git.git/tree/Documentation/SubmittingPatches). 
A good way to invite feedback is to add a relevant Cc-list to a patch. 
The output of scripts/get_maintainer.pl can be a good start.

Bart.
