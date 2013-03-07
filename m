From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4 module loading fail
Date: Thu, 7 Mar 2013 18:22:43 +0200
Message-ID: <5138BED3.30506@mellanox.com>
References: <96353B6F8A3DAE4BBC51047BD0E6BAC20913A5@DEWDFEMB17A.global.corp.sap> <5138B372.4020201@mellanox.com> <96353B6F8A3DAE4BBC51047BD0E6BAC20914D9@DEWDFEMB17A.global.corp.sap>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <96353B6F8A3DAE4BBC51047BD0E6BAC20914D9-v0w1aZ/WxVLTw0Kyn31wWKuC/IaeJB0jHWlK3eZauXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hudzia, Benoit" <benoit.hudzia-y6kNeMnOB+c@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/03/2013 18:06, Hudzia, Benoit wrote:
> We didn't change that code  as our code is  sitting above the rdma_ucm  bit.  ( we do not touch any of the core RDMA function or drivers, just using them). We are using the default OFED setup ( driver are loaded with the default config ) and there is nothing special. I will investigate the MAX_ORDER aspect asap and test with 3.9rc1 also.

Do you use plain upstream bits or install driver from external source?


>
> However I did a quick test and by removing physically HALF the ram of the server ( basically moving from 1TB to 512GB) everything works fine..
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
