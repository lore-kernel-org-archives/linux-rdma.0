From: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 1/1] opensm/main.c: opensm cannot be killed while asking
 for port guid
Date: Fri, 13 Nov 2009 12:55:27 -0600
Message-ID: <4AFDAB9F.6020900@sgi.com>
References: <4AF46DEB.7090105@sgi.com> <20091113025527.GE7192@me> <20091112192422.E16537@viper.engr.sgi.com> <20091113130308.GM7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091113130308.GM7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sammy Wilborn <samm-sJ/iWh9BUns@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Higdon <jeremy-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Sasha Khapyorsky wrote:
> On 19:24 Thu 12 Nov     , Sammy Wilborn wrote:
>>>> -		printf("\nError: Lame choice!\n");
>>>> +		printf("\nError: Please try again.\n");
>>> "Try again" is good, but it is useful to provide a reason too, so let's
>>> do it even more "professional":
>>>
>>> 	printf("\nError: Lame choice! Please try again.\n");
>> How about the following?
>>
>>  	printf("\nError: Invalid choice! Please try again.\n");
> 
> This works too. Would you care about the patch?

I think the point is to not upset the customer by suggesting that
they are "lame".  OFED, meet customer spending LOTS of money.  Customer,
meet OFED!  :)  Do you need a patch submitted making that change?

And, thanks for the comment about using the current master branch.
I'll try to do that in the future.  I'm still coming up to speed on
processes and remain mostly "git" illiterate.

Thanks,
 Mike

> 
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
