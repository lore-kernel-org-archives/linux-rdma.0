From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Wed, 9 May 2018 22:08:52 -0600
Message-ID: <06375fd7-f241-74ad-70ce-a670100bf060@gmail.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/7/18 9:53 AM, Steve Wise wrote:
> @@ -152,7 +153,10 @@ int main(int argc, char **argv)
>  			pretty_output = true;
>  			break;
>  		case 'd':
> -			show_details = true;
> +			if (show_details)
> +				show_driver_details = true;
> +			else
> +				show_details = true;
>  			break;
>  		case 'j':
>  			json_output = true;

The above change should be reflected in the man page.

Also, the set needs to be respun after I merged master where Stephen
brought in updates to the uapi files.
