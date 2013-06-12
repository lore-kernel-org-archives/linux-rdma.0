From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 2/6] ibstat.c: fix buffer-not-null-terminated
Date: Wed, 12 Jun 2013 18:06:33 -0400
Message-ID: <51B8F0E9.90508@dev.mellanox.co.il>
References: <51B87DD4.9040005@dev.mellanox.co.il> <20130612141948.c4760f2856d2e4435be2b0a7@intel.com> <51B8F03C.8010004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B8F03C.8010004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/12/2013 6:03 PM, Hal Rosenstock wrote:
> On 6/12/2013 5:19 PM, Ira Weiny wrote:
>> On Wed, 12 Jun 2013 09:55:32 -0400
>> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>
>>> From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>
>>> Buffer may not have a null terminator if the source string's length is
>>> equal to the buffer size.
>>
>> Good catch, but I think this is an issue in umad_get_cas_names!
>>
>>>
>>> Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>  src/ibstat.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/src/ibstat.c b/src/ibstat.c
>>> index 665bb0a..acb9e8e 100644
>>> --- a/src/ibstat.c
>>> +++ b/src/ibstat.c
>>> @@ -279,6 +279,7 @@ int main(int argc, char *argv[])
>>>  	int dev_port = -1;
>>>  	int n, i;
>>>  
>>> +	memset(names, 0, sizeof(names[0][0] * UMAD_MAX_DEVICES * UMAD_CA_NAME_LEN));
>>
>> I don't think you need this as it will not fix umad_get_cas_names.
> 
> The proper memset is already in the tree.

It isn't in the tree; I was looking at modified source...

>>>  	const struct ibdiag_opt opts[] = {
>>>  		{"list_of_cas", 'l', 0, NULL, "list all IB devices"},
>>>  		{"short", 's', 0, NULL, "short output"},
>>> @@ -314,7 +315,7 @@ int main(int argc, char *argv[])
>>>  		if (i >= n)
>>>  			IBPANIC("'%s' IB device can't be found", argv[0]);
>>>  
>>> -		strncpy(names[i], argv[0], sizeof names[i]);
>>> +		strncpy(names[i], argv[0], sizeof names[i]-1);
>>
>> This is actually dead code.  IBPANIC exits, if your linking to libibmad.  Do you have a different IBPANIC which does not exit?  Do you have a use case which hits this bug?
>>
>> [root@iqa-136 sbin]# ./ibstat myverylongca_name_0123456789_0123456789
>> ibpanic: [9262] main: 'myverylongca_name_0123456789_0123456789' IB device can't be found: Success
>> [root@iqa-136 sbin]# ./ibstat notfoundca
>> ibpanic: [9273] main: 'notfoundca' IB device can't be found: Success
> 
> I think the change is to quiet a Coverity detected error but Dan is the
> definitive source for this change.
> 
> -- Hal
> 
>> Ira
>>
>>>  		n = 1;
>>>  	}
>>>  
>>> -- 
>>> 1.7.8.2
>>>
>>
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
