From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 03/16] IB/core: Introduce counter set describe
 verb
Date: Sun, 22 Oct 2017 15:00:55 +0300
Message-ID: <7a11c4f2-f887-16b8-08ed-434ae4aaa1e0@dev.mellanox.co.il>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <1508424118-27205-4-git-send-email-yishaih@mellanox.com>
 <alpine.DEB.2.20.1710200541250.10736@nuc-kabylake>
 <AM6PR0502MB37838B19976EDF1D04C74751BD400@AM6PR0502MB3783.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM6PR0502MB37838B19976EDF1D04C74751BD400-md96bDB8+JV1k1TWM4Wt8cDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/21/2017 3:29 AM, Guy Shattah wrote:
> 
> 
>> On Thu, 19 Oct 2017, Yishai Hadas wrote:
>>
>>> +#define IB_COUNTER_NAME_LEN 64
>>> +struct ib_counter_set_describe_attr {
>>> +	/* Type that this set refers to, use enum ib_counter_set_type */
>>> +	u8 counted_type;
>>
>> Gap here of 7 bytes. Maybe move the field to get a more compact structure?
>>
>>> +	/* Number of instances of this counter-set available in the hardware
>> */
>>> +	u64 num_of_cs;
>>
>> u16 or u32 should be enough right?
> 
> Future API might be added to create user-customizable  sets.
> How many potential subsets are for a set of 32 counters? More than 2^64.
> We might want to be able to support it.
> 
>>
>>> +	/* Attributes of the set, use enum ib_counter_set_attributes */
>>> +	u32 attributes;
>>> +	/* Number of counters in this set */
>>> +	u8 entries_count;
>>
>> A counter set is limited to 255? Could there be counter sets that have a
>> thousand or so?
> 
> A counter set is merely a set. I can't see a reason why would a user want to query a set
> which contains more than 256 counters. All at the same time.
> However, I agree that we could modify it to u16 or u32.

Thanks Christoper for looking at the series.

In V1 will change this field to be u16 and re-order the fields in struct 
ib_counter_set_describe_attr to be more compact as you suggest.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
