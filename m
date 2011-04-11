From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/4] libibmad: Distinguish timed out from other errors
Date: Mon, 11 Apr 2011 07:25:05 -0400
Message-ID: <4DA2E511.2030204@dev.mellanox.co.il>
References: <4DA07983.8060308@dev.mellanox.co.il> <20110409171239.GA4372@obsidianresearch.com> <4DA1875F.2050601@dev.mellanox.co.il> <20110410140956.GB4372@obsidianresearch.com> <4DA1D405.4040305@dev.mellanox.co.il> <20110410164459.GC4372@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110410164459.GC4372-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Kladnitsky <orenk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/10/2011 12:44 PM, Jason Gunthorpe wrote:
> On Sun, Apr 10, 2011 at 12:00:05PM -0400, Hal Rosenstock wrote:
>>> If you are going to change the ABI like this then you have to bump the
>>> SONAME.
>>
>> Typically it's been the libibmad maintainer who's bumped the versions
>> when appropriate as a release is readied.
> 
> The version should be bumped in the same commit that makes the
> incompatible change so that people testing the library don't get
> messed up by it.

That's how it used to be done but with the previous maintainer version
bumps were left until release time.

I'll add this to an updated/reworked patch but I hope we'll avoid an
extra last minute/release version bump.

-- Hal

>>> Setting a flag would work.
>>
>> Not sure what you're referring to. Setting a flag where ?
> 
> Your idea to place a `new ABI` flag in mgmClass.

> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
