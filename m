From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC rdma-core] srp_daemon: handle SM lid change
Date: Fri, 8 Dec 2017 18:35:37 +0100
Message-ID: <54480873-f674-f5b9-29a1-5ad28eff820b@suse.com>
References: <1978d0ad-909f-ed8b-5b54-e8c465d3641f@dev.mellanox.co.il>
 <82bd1d9a-7e6a-324e-1e00-43fcf130faf0@suse.com>
 <82dc0912-3ac3-9548-2c3b-703c6e1c9c95@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <82dc0912-3ac3-9548-2c3b-703c6e1c9c95-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 08/12/2017 à 14:33, Hal Rosenstock a écrit :
> On 12/8/2017 4:36 AM, Nicolas Morey-Chaisemartin wrote:
>>  
>>  int create_ah(struct ud_resources *ud_res)
>> @@ -641,7 +649,7 @@ static int register_to_trap(struct sync_resources *sync_res,
>>  			pthread_mutex_unlock(res->mad_buffer_mutex);
>>  		} while (rc == 2); // while old response.
>>  
>> -	} while (rc == 0 && ++counter < 3);
>> +	} while (rc == 0 && ++counter < 5);
>>  
>>  	if (counter==3) {
> This should be changed from 3 to 5 also. Change both to some define ?
I thought I changed that back to 3 during my tests.
No I have a big doubt that the issue is fully resolved, or just hidden because on timeout, the pr_err is never reached.
I'll retest that in Monday.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
