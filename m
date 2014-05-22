From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libmlx4 V3 1/2] Add RoCE IP based addressing support for
 UD QPs
Date: Thu, 22 May 2014 12:19:22 +0300
Message-ID: <537DC11A.8080505@mellanox.com>
References: <1400405952-14388-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx> <1400405952-14388-2-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx> <20140521200043.GB26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140521200043.GB26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 21/5/2014 11:00 PM, Jason Gunthorpe wrote:
> On Sun, May 18, 2014 at 12:39:11PM +0300, Or Gerlitz wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> In order to implement IP based addressing for UD QPs, we need a way to
>> resolve the addresses internally.
>> The L2 params are passed to the provider driver using an extension verbs
>> - drv_ibv_create_ah_ex.
>     ^^^^^^
> The name changed
>

Thanks!

>> +struct ibv_ah *mlx4_create_ah_ex(struct ibv_pd *pd,
>> +				 struct ibv_ah_attr_ex *attr_ex)
>> +{
>> +	struct ibv_port_attr port_attr;
>> +	struct ibv_ah *ah;
>> +	struct mlx4_ah *mah;
>> +
>> +	if (ibv_query_port(pd->context, attr_ex->port_num, &port_attr))
>> +		return NULL;
>> +
>> +	ah = mlx4_create_ah_common(pd, (struct ibv_ah_attr *)attr_ex,
>> +				   port_attr.link_layer);
>> +
>> +	if (NULL == ah)
>> +		return NULL;
>
> I'm seeing a real lack of error reporting here.
>

Correct, ibv_query_port error should be captured to errno,
In addition, we need to add an error for an incorrect link layer type.

> My prior question was never answered: Should we be consistently using
> errno for functions that return pointers? If yes, you need to make
> sure errno is set on these failure paths, and document the possible
> values errno can take.
>
>> +	/* check that ll is provided and valid */
>> +	if (attr_ex->comp_mask & IBV_AH_ATTR_EX_LL) {
>> +		if (ARPHRD_ETHER != attr_ex->ll.sa.sa_family ||
>                    ^^^^^^^^^^^
> As I mentioned before, ARPHDR_ETHER is not correct for sa_family.
>

I don't want to tie this mechanism to Ethernet. If you prefer in-lining 
the data (rather than using a pointer), we might just introduce a new 
type of a big sockaddr_storage like buffer with a link_layer type enum.
What do you think?

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
