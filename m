From: Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Wed, 07 Jul 2010 14:22:10 +0300
Message-ID: <4C346362.30601@dev.mellanox.co.il>
References: <4C2312F0.8020308@dev.mellanox.co.il> <20100705181143.GG22860@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100705181143.GG22860@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05-Jul-10 9:11 PM, Sasha Khapyorsky wrote:
> On 11:10 Thu 24 Jun     , Yevgeny Kliteynik wrote:
>>
>> The problem is, one of the
>> fields in struct osm_event_plugin is called "delete".
>> Changing it to "destroy" and promoting the API version.
>
> This will break any existing plugin now (I know at least couple). I
> don't think that such change is appropriate for "between RCs" period.

OK, no problem - this can be applied after the next
management tarball and after OFED 1.5.2 release.

-- Yevgeny
  
> Sasha
>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
