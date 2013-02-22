From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various enums
Date: Fri, 22 Feb 2013 15:56:21 -0500
Message-ID: <5127DB75.60709@dev.mellanox.co.il>
References: <20130222091333.57b91bbb5957928eeb0e62a7@llnl.gov> <5127B87E.5020907@dev.mellanox.co.il> <20130222202314.GB10206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130222202314.GB10206-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/22/2013 3:23 PM, Jason Gunthorpe wrote:
> On Fri, Feb 22, 2013 at 01:27:10PM -0500, Hal Rosenstock wrote:
> 
>>> +char * umad_class_str(uint8_t mgmt_class)
>>> +{
>>> +	switch (mgmt_class) {
>>> +		case UMAD_CLASS_SUBN_LID_ROUTED:
>>> +		case UMAD_CLASS_SUBN_DIRECTED_ROUTE:
>>> +			return("Subn");
> 
> Doesn't this create a compiler warning? 

Not with my setup.

> Is -Wall turned on? 

Yes but maybe it depends on gcc version.

> The return type should be 'const char *' when returning strings from rodata.

Yes that would be better.

-- Hal

> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
