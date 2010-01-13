From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_qos.c: merge SL2VL mapping capability check
Date: Wed, 13 Jan 2010 15:13:09 -0500
Message-ID: <f0e08f231001131213r4a743d6boc1b07e9fadc773ac@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20100104170141.GK26940@me>
	 <f0e08f231001070538q78453f91kd47c931087dfa735@mail.gmail.com>
	 <20100112103517.GI26089@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112103517.GI26089@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2010 at 5:35 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> On 08:38 Thu 07 Jan     , Hal Rosenstock wrote:
>>
>> Change appears to be for switches to always rely on this bit rather
>> than only when VLCap is 1. I wonder if there are any switches with
>> VLCap > 1 that don't set the IsSLMappingSupported CapabilityMask bit.
>> There shouldn't be (at least if they are IBA 1.2.1 compliant) but are
>> you sure about this ?
>
> I'm not sure about this, but think that probability of using such
> hypothetical old switches for any sort of QoS is very low.

Low but not zero... I'm also not sure it's just old switches...
I've seen many rejections (status 7) since you made this change.

> And anyway it
> doesn't look for me that we have any stronger SL2VL mapping capability
> indication - 'VLCap > 1' by itself doesn't do this too, right?

It does. There's a requirement that SL2VL mapping is required when VLCap > 1.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
