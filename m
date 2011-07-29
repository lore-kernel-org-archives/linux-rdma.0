From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/3] opensm/osm_helper: Add rate related routines
Date: Fri, 29 Jul 2011 08:33:46 -0400
Message-ID: <4E32A8AA.1010007@dev.mellanox.co.il>
References: <4E2EDBF7.3080509@dev.mellanox.co.il> <20110729081439.GA2055@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110729081439.GA2055-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 7/29/2011 4:14 AM, Alex Netes wrote:
> Hi Hal,
> 
> On 11:23 Tue 26 Jul     , Hal Rosenstock wrote:
>>
>> for proper comparison and selector operation
>>
>> Rate enum was never is ascending order of actual underlying rates
>> but even worse with newly added extended link speeds.
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/include/opensm/osm_helper.h b/include/opensm/osm_helper.h
>> index f11fdee..a2c1dea 100644
>> --- a/include/opensm/osm_helper.h
>> +++ b/include/opensm/osm_helper.h
>> @@ -1,6 +1,6 @@
>>  /*
>>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>> + * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
>>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
>>   *
>> @@ -582,5 +582,85 @@ const char *osm_get_sm_mgr_state_str(IN uint16_t state);
>>  * SEE ALSO
>>  *********/
>>  
>> +/****f* IBA Base: Types/ib_path_compare_rates
>> +* NAME
>> +*	ib_path_compare_rates
>> +*
>> +* DESCRIPTION
>> +*	Compares the encoded values for two path rates and
>> +*	return value is based on the ordered comparison of
>> +*	the path rates (or path rate equivalents).
>> +*
>> +* SYNOPSIS
>> +*/
>> +int ib_path_compare_rates(IN const int rate1, IN const int rate2);
>> +
>> +/*
>> +* PARAMETERS
>> +*	rate1
>> +*		[in] Encoded path rate 1.
>> +*
>> +*	rate2
>> +*		[in] Encoded path rate 2.
>> +*
>> +* RETURN VALUES
>> +*	Returns an int indicating less than (-1), equal to (0), or
>> +*	greater than (1) rate1 as compared with rate2.
>> +*
>> +* NOTES
>> +*
>> +* SEE ALSO
>> +*********/
>> +
>> +/****f* IBA Base: Types/ib_path_rate_get_prev
>> +* NAME
>> +*	ib_path_rate_get_prev
>> +*
>> +* DESCRIPTION
>> +*	Obtains encoded rate for the rate previous to the one requested.
>> +*
>> +* SYNOPSIS
>> +*/
>> +int ib_path_rate_get_prev(IN const int rate);
>> +
>> +/*
>> +* PARAMETERS
>> +*	rate
>> +*		[in] Encoded path rate.
>> +*
>> +* RETURN VALUES
>> +*	Returns an int indicating encoded rate or
>> +*	0 if none can be found.
>> +*
>> +* NOTES
>> +*
>> +* SEE ALSO
>> +*********/
>> +
>> +/****f* IBA Base: Types/ib_path_rate_get_next
>> +* NAME
>> +*	ib_path_rate_get_next
>> +*
>> +* DESCRIPTION
>> +*	Obtains encoded rate for the rate subsequent to the one requested.
>> +*
>> +* SYNOPSIS
>> +*/
>> +int ib_path_rate_get_next(IN const int rate);
>> +
>> +/*
>> +* PARAMETERS
>> +*	rate
>> +*		[in] Encoded path rate.
>> +*
>> +* RETURN VALUES
>> +*	Returns an int indicating encoded rate or
>> +*	0 if none can be found.
>> +*
>> +* NOTES
>> +*
>> +* SEE ALSO
>> +*********/
>> +
>>  END_C_DECLS
>>  #endif				/* _OSM_HELPER_H_ */
>> diff --git a/opensm/libopensm.map b/opensm/libopensm.map
>> index 68d5b17..ca7d236 100644
>> --- a/opensm/libopensm.map
>> +++ b/opensm/libopensm.map
>> @@ -57,5 +57,8 @@ OPENSM_1.5 {
>>  		osm_get_lsa_str;
>>  		osm_get_sm_mgr_signal_str;
>>  		osm_get_sm_mgr_state_str;
>> +		ib_path_compare_rates;
>> +		ib_path_rate_get_prev;
>> +		ib_path_rate_get_next;
>>  	local: *;
>>  };
>> diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
>> index ec1099c..aed95f8 100644
>> --- a/opensm/osm_helper.c
>> +++ b/opensm/osm_helper.c
>> @@ -439,6 +439,27 @@ static const char *ib_sa_attr_str[] = {
>>  
>>  #define OSM_SA_ATTR_STR_UNKNOWN_VAL (ARR_SIZE(ib_sa_attr_str) - 1)
>>  
>> +static int ordered_rates[] = {
>> +	0, 0,	/*  0, 1 - reserved */
>> +	1,	/*  2 - 2.5 Gbps */
>> +	3,	/*  3 - 10  Gbps */
>> +	6,	/*  4 - 30  Gbps */
>> +	2,	/*  5 - 5   Gbps */
>> +	5,	/*  6 - 20  Gbps */
>> +	8,	/*  7 - 40  Gbps */
>> +	9,	/*  8 - 60  Gbps */
>> +	11,	/*  9 - 80  Gbps */
>> +	12,	/* 10 - 120 Gbps */
>> +	4,	/* 11 -  14 Gbps (17 Gbps equiv) */
>> +	10,	/* 12 -  56 Gbps (68 Gbps equiv) */
>> +	14,	/* 13 - 112 Gbps (136 Gbps equiv) */
>> +	15,	/* 14 - 158 Gbps (204 Gbps equiv) */
>> +	7,	/* 15 -  25 Gbps (31.25 Gbps equiv) */
>> +	13,	/* 16 - 100 Gbps (125 Gbps equiv) */
>> +	16,	/* 17 - 200 Gbps (250 Gbps equiv) */
>> +	17	/* 18 - 300 Gbps (375 Gbps equiv) */
>> +};
>> +
>>  static int sprint_uint8_arr(char *buf, size_t size,
>>  			    const uint8_t * arr, size_t len)
>>  {
>> @@ -2295,3 +2316,55 @@ const char *osm_get_sm_mgr_state_str(IN uint16_t state)
>>  	    sm_mgr_state_str[state] :
>>  	    sm_mgr_state_str[ARR_SIZE(sm_mgr_state_str) - 1];
>>  }
>> +
>> +int ib_path_compare_rates(IN const int rate1, IN const int rate2)
>> +{
>> +	int orate1 = 0, orate2 = 0;
>> +
>> +	if (rate1 <= IB_MAX_RATE)
> 
> I guess there should be also check for rate1 >= IB_MIN_RATE

I don't think this is necessary as 0 is returned for those rates <
IB_MIN_RATE.

> Don't you want to add CL_ASSERT macro here?

OK (in a v2 of this patch).

>> +		orate1 = ordered_rates[rate1];
>> +	if (rate2 <= IB_MAX_RATE)
>> +		orate2 = ordered_rates[rate2];
>> +	if (orate1 < orate2)
>> +		return -1;
>> +	if (orate1 == orate2)
>> +		return 0;
>> +	return 1;
>> +}
>> +
>> +static int find_ordered_rate(IN const int rate)
>> +{
>> +	int i;
>> +
>> +	for (i = 2; i <= IB_MAX_RATE; i++) {
> 
> Shouldn't it be for (i=1; i <= IB_MAX_RATE; i++) ?

I don't think so but rather than 2 it would be better as IB_MIN_RATE.

> For ib_path_rate_get_next(rate = 5Gbps), you'll get 0, instead of 2.5Gbps.

Do you mean get_prev rather than get_next ? Anyhow, I think it does the
right thing. Note that the 64/66 rates are adjusted for comparison with
the 8b/10b rates as the comments aside the ordered rates indicate.

testing get_prev
0 prev 0
1 prev 0
2 prev 0
3 prev 5
4 prev 6
5 prev 2
6 prev 11
7 prev 15
8 prev 7
9 prev 12
10 prev 9
11 prev 3
12 prev 8
13 prev 16
14 prev 13
15 prev 4
16 prev 10
17 prev 14
18 prev 17

testing get_next
0 next 0
1 next 0
2 next 5
3 next 11
4 next 15
5 next 3
6 next 4
7 next 8
8 next 12
9 next 10
10 next 16
11 next 6
12 next 9
13 next 14
14 next 17
15 next 7
16 next 13
17 next 18

-- Hal

>> +		if (ordered_rates[i] == rate)
>> +			return i;
>> +	}
>> +	return 0;
>> +}
>> +
>> +int ib_path_rate_get_prev(IN const int rate)
>> +{
>> +	int orate;
>> +
>> +	if (rate <= IB_MIN_RATE)
>> +		return 0;
>> +	if (rate > IB_MAX_RATE)
>> +		return 0;
>> +	orate = ordered_rates[rate];
>> +	orate--;
>> +	return find_ordered_rate(orate);
>> +}
>> +
>> +int ib_path_rate_get_next(IN const int rate)
>> +{
>> +	int orate;
>> +
>> +	if (rate < IB_MIN_RATE)
>> +		return 0;
>> +	if (rate >= IB_MAX_RATE)
>> +		return 0;
>> +	orate = ordered_rates[rate];
>> +	orate++;
>> +	return find_ordered_rate(orate);
>> +}
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
