From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC rdma-core] srp_daemon: handle SM lid change
Date: Fri, 8 Dec 2017 08:56:38 -0500
Message-ID: <dce98958-a6e2-b289-2a58-609d1914affb@intel.com>
References: <1978d0ad-909f-ed8b-5b54-e8c465d3641f@dev.mellanox.co.il>
 <82bd1d9a-7e6a-324e-1e00-43fcf130faf0@suse.com>
 <82dc0912-3ac3-9548-2c3b-703c6e1c9c95@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <82dc0912-3ac3-9548-2c3b-703c6e1c9c95-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/8/2017 8:33 AM, Hal Rosenstock wrote:
>>   int create_ah(struct ud_resources *ud_res)
>> @@ -641,7 +649,7 @@ static int register_to_trap(struct sync_resources *sync_res,
>>   			pthread_mutex_unlock(res->mad_buffer_mutex);
>>   		} while (rc == 2); // while old response.
>>   
>> -	} while (rc == 0 && ++counter < 3);
>> +	} while (rc == 0 && ++counter < 5);
>>   
>>   	if (counter==3) {
> 
> This should be changed from 3 to 5 also. Change both to some define ?

Yes please change these to a #define with a some what descriptive name. 
That would make the code much better to read.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
