From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/SA: Add support to query OPA path
 records
Date: Wed, 19 Apr 2017 09:54:16 -0700
Message-ID: <c2ccd3ff-ed35-de86-73da-34a5d8d17551@intel.com>
References: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1492462590-64866-7-git-send-email-dasaratharaman.chandramouli@intel.com>
 <7304d2b8-87f4-e7ec-ebe4-ccaf34c09976@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7304d2b8-87f4-e7ec-ebe4-ccaf34c09976-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hal,

On 4/19/2017 7:52 AM, Hal Rosenstock wrote:
> On 4/17/2017 4:56 PM, Dasaratharaman Chandramouli wrote:
>> When the bit 26 of capmask2 field in OPA classport info
>> query is set, SA will query for OPA path records instead
>> of querying for IB path records.
>
> If/when additional SA query types are supported for OPA, will each
> additional SA query type have separate CapMask2 bit or will they be
> combined into 1 ? For example, would SA MCMemberRecord be different for
> OPA (perhaps 32 bit MLID) and if so, would support be indicated by
> different capability bit or same one ? Is that the only other one ?

There are no plans to provide a separate capmask2 bit for each of the 
other queries.

>
> Currently, IB SA is using up through bit 13 and new features continue to
> be added (at least one more coming soon). There is some chance for
> feature collision if OPA would care about supporting such new IB feature
> if and when OPA and IB bitmasks meet with IB incrementing from bit 13
> and OPA decrementing from bit 26. I wouldn't expect that to happen for a
> while but it would be best to anticipate this if it is of any concern to
> OPA.

I see your concern. The capmask2 bits for OPA is not intended to be in 
sync with IB. If, for instance, we have a new IB feature that is exposed 
by Bit n of capmask, two things are possible. 1) OPA might not support 
the same feature. If the class port info query that is 'cached' by the 
SA is of type OPA, it implicitly means that the feature is not 
supported. This patch series adds a function 
"ib_sa_sendonly_fullmem_support" that is a good example of that case.
When a caller calls this function and if the class port info is of type 
OPA, we just return 'false' implying that OPA doesn't possess 
sendonly_fullmember suppprt. 2) OPA might support the feature. In this 
case, OPA class port info will expose the feature in the capmask2 field 
bit not necessarily in the same bit n. SA should be able to handle these 
differences.

> -- Hal
>

Thanks,
Dasa
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
