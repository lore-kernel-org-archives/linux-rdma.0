From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-rc 03/14] RDMA/core: Remove unimplemented node_types and
 node transport
Date: Mon, 31 Jul 2017 09:32:14 -0400
Message-ID: <63a8961c-7341-80c2-c417-67d4e6fd4702@intel.com>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-4-leon@kernel.org>
 <2e1b38f9-ae7a-4f5e-9cac-168f1f9b56af@dev.mellanox.co.il>
 <20170731121823.GV13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731121823.GV13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/31/2017 8:18 AM, Leon Romanovsky wrote:
> On Mon, Jul 31, 2017 at 08:01:51AM -0400, Hal Rosenstock wrote:
>> On 7/31/2017 3:09 AM, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> There is no need to carry code, which is not implemented in any
>>> underlying hardware.
>>
>> AFAIK there are Linux based IB switch implementations and there may be
>> IB router implementation(s) whose drivers have not been pushed upstream
>> so it would be better to leave at least those 2 node types in.
> 
> So if they care, this code will be pushed together with needed fields.
> Right now, this code is not connected in current linux kernel code,
> not tested and can't be exposed.
> 
> It is dead code from upstream point of view.
> 
> Thanks
> 

I would be fine leaving the code in for a driver which was in the works 
or fairly new. For instance the bnxt patch (11/14), perhaps there are 
plans to implement that stuff soonish. I'll let that driver's maintainer 
make that case though.

However these things are not new and unless someone is working on code 
to implement those things I would lean toward removing.

There is a fine line between dead code and code waiting to be written.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
