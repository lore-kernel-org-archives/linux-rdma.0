From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] register_to_trap(): Increase number of iterations from 3
 to 5
Date: Mon, 11 Dec 2017 10:20:51 +0100
Message-ID: <3470afdc-08b8-65fd-4010-41ffef0b084d@suse.de>
References: <20171208172237.312-1-bart.vanassche@wdc.com>
 <c92fa8ad-7d15-29fa-4c09-b7593e7160cf@dev.mellanox.co.il>
 <e06c1dc0-509e-3fc0-4b0d-49d695a1421e@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e06c1dc0-509e-3fc0-4b0d-49d695a1421e-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 08/12/2017 à 19:17, Hal Rosenstock a écrit :
> On 12/8/2017 12:38 PM, Hal Rosenstock wrote:
>> On 12/8/2017 12:22 PM, Bart Van Assche wrote:
>>> Master SM changes can take more than three seconds. Hence increase
>>> the time during which to wait for a master SM to appear from 3 to 5
>>> seconds.
>>>
>>> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
>>> Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>> Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
>>> ---
>>>  srp_daemon/srp_handle_traps.c | 11 +++++------
>>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
>>> index 6d94634ef6df..dda746a5c69d 100644
>>> --- a/srp_daemon/srp_handle_traps.c
>>> +++ b/srp_daemon/srp_handle_traps.c
>>> @@ -550,8 +550,8 @@ static int register_to_trap(struct sync_resources *sync_res,
>>>  	struct ibv_sge sg;
>>>  	struct ibv_send_wr *_bad_wr = NULL;
>>>  	struct ibv_send_wr **bad_wr = &_bad_wr;
>>> -	int counter = 0;
>>> -	int rc = 0;
>>> +	int counter;
>>> +	int rc;
>>>  	int ret;
>>>  	long long unsigned comp_mask = 0;
>>>  
>>> @@ -609,7 +609,7 @@ static int register_to_trap(struct sync_resources *sync_res,
>>>  	p_sa_mad->comp_mask = htobe64(comp_mask);
>>>  	pr_debug("comp_mask: %llx\n", comp_mask);
>>>  
>>> -	do {
>>> +	for (counter = 5, rc = 0; counter > 0 && rc == 0; counter--) {
>>>  		pthread_mutex_lock(res->mad_buffer_mutex);
>>>  		res->mad_buffer->mad_hdr.base_version = 0; // flag that the buffer is empty
>>>  		pthread_mutex_unlock(res->mad_buffer_mutex);
>>> @@ -640,10 +640,9 @@ static int register_to_trap(struct sync_resources *sync_res,
>>>  			}
>>>  			pthread_mutex_unlock(res->mad_buffer_mutex);
>>>  		} while (rc == 2); // while old response.
>>> +	}
>>>  
>>> -	} while (rc == 0 && ++counter < 3);
>>> -
>>> -	if (counter==3) {
>>> +	if (counter == 0) {
>>>  		pr_err("No response to inform info registration\n");
>>>  		return -EAGAIN;
>>>  	} 
>>>
>> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
> Given what Nicolas wrote, maybe this should be split into 2 patches with
> first being refactoring but not changing counter and leave the counter
> increase for Nicolas.
>
> -- Hal

Yep. I confirm the fix was partly due to the desync between the counter loop and the test for the error message.
Your next patch (cleanup without changing counter to 5) makes sense though.
I'll send an updated fix for my issue as soon as I have one !

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
