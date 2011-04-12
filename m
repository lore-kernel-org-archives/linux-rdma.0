From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ibsim] increase max nodes and switches to support similation
 of	larger fabrics
Date: Tue, 12 Apr 2011 13:56:36 -0400
Message-ID: <4DA49254.2050506@dev.mellanox.co.il>
References: <1302629145.21002.12.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302629145.21002.12.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 4/12/2011 1:25 PM, Albert Chu wrote:
> The maximum number of nodes and switches allowed by ibsim was too small
> for some of our larger fabrics, so I increased the size.
> 
> Longer term, there shouldn't be a fixed size for these and the arrays
> should grow in size as needed, however I'll leave that for another day.

These are really just defaults. There are command line options to take
larger values. Maybe an ibsim man page would be nice...

-- Hal

> Al

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
