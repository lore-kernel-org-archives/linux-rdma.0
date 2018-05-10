From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Thu, 10 May 2018 08:20:51 -0600
Message-ID: <06d8cb88-21e0-b7cc-10e2-efa453d9adc9@gmail.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
 <06375fd7-f241-74ad-70ce-a670100bf060@gmail.com>
 <e94d0444-fcda-3a62-3b12-3b9e6ff23119@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <e94d0444-fcda-3a62-3b12-3b9e6ff23119@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/10/18 8:19 AM, Steve Wise wrote:
> 
> On 5/9/2018 11:08 PM, David Ahern wrote:
>> On 5/7/18 9:53 AM, Steve Wise wrote:
>>> @@ -152,7 +153,10 @@ int main(int argc, char **argv)
>>>  			pretty_output = true;
>>>  			break;
>>>  		case 'd':
>>> -			show_details = true;
>>> +			if (show_details)
>>> +				show_driver_details = true;
>>> +			else
>>> +				show_details = true;
>>>  			break;
>>>  		case 'j':
>>>  			json_output = true;
>> The above change should be reflected in the man page.
> 
> I did mention it in the man page:
> 
>        -d, --details
>               Output detailed information.  Adding a second -d includes
> driver-specific details.
> 
> But I wasn't sure how to show it in the syntax.  Maybe this?
> 
>  OPTIONS := { -V[ersion] | -d[etails] [-d[etails]] } -j[son] } -p[retty] }

I should have read the second patch before commenting. Didn't it have
first -d = details, a second -d = driver details? That should be fine.

> 
> 
>> Also, the set needs to be respun after I merged master where Stephen
>> brought in updates to the uapi files.
> 
> Will do.  Thanks for reviewing.
> 
> Steve.
> 
