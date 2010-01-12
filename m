From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_qos.c: merge SL2VL mapping capability check
Date: Tue, 12 Jan 2010 12:35:17 +0200
Message-ID: <20100112103517.GI26089@me>
References: <20091201194110.GA26753@comcast.net>
 <20100104170141.GK26940@me>
 <f0e08f231001070538q78453f91kd47c931087dfa735@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001070538q78453f91kd47c931087dfa735-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:38 Thu 07 Jan     , Hal Rosenstock wrote:
> 
> Change appears to be for switches to always rely on this bit rather
> than only when VLCap is 1. I wonder if there are any switches with
> VLCap > 1 that don't set the IsSLMappingSupported CapabilityMask bit.
> There shouldn't be (at least if they are IBA 1.2.1 compliant) but are
> you sure about this ?

I'm not sure about this, but think that probability of using such
hypothetical old switches for any sort of QoS is very low. And anyway it
doesn't look for me that we have any stronger SL2VL mapping capability
indication - 'VLCap > 1' by itself doesn't do this too, right?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
