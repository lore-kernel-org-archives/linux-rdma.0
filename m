From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] Remove the obsolete libibcm library
Date: Tue, 2 Jan 2018 09:18:59 -0500
Message-ID: <ea55cca5-1bf9-dd54-9be1-6450ca9002ef@dev.mellanox.co.il>
References: <20171225123132.6063-1-leon@kernel.org>
 <20171227201945.GG25436@ziepe.ca> <20171228053029.GO3494@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228053029.GO3494-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/28/2017 12:30 AM, Leon Romanovsky wrote:
> On Wed, Dec 27, 2017 at 01:19:45PM -0700, Jason Gunthorpe wrote:
>> On Mon, Dec 25, 2017 at 02:31:32PM +0200, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> The libibcm library was marked as obsolete long time ago,
>>> the following patch is first step before removing ucm from
>>> the kernel.
>>
>> I understand the distros will not want to loose libibcm in their
>> stable releases.
>>
>> It might make more sense instead to just not build libibcm by default
>> with a cmake option but still keep the sources..
> 
> We are not removing it from the stable branches, so if they want to keep it
> till last person who used this library dies, they are free to do it.
> 
> The disabled build doesn't give much benefit at all. It will be dead code exactly
> as now, but without any alert that it is broken. Most possible, it will be broken
> till some distro will notice it.

Since when has it been brken and how is it broken ? Last I knew it
worked but was not used by anything in tree.

-- Hal

> Exactly as some distros have EOL, this libibcm library came to its EOL.
> 
> Thanks
> 
>>
>> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
