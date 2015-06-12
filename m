From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Thu, 11 Jun 2015 20:22:37 -0400
Message-ID: <557A264D.5030902@dev.mellanox.co.il>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>  <1433615915-24591-15-git-send-email-ira.weiny@intel.com>  <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>  <1433961446.71666.26.camel@redhat.com>  <20150610185653.GA28153@obsidianresearch.com> <1433966378.71666.44.camel@redhat.com> <1828884A29C6694DAF28B7E6B8A82373A8FEF1EA@ORSMSX109.amr.corp.intel.com> <557A18C0.6010200@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FEF321@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FEF321-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/11/2015 7:52 PM, Hefty, Sean wrote:
>>> I agree that the node type enum isn't particularly useful and should be
>> retired.
>>
>> Are you referring to kernel space or user space or both ?
> 
> Short term, kernel space.  User space needs to keep something around for backwards compatibility.
> 
> But the in tree code will never expose this value up.
> 
>>> But even if we do, I'm not sure this is the correct approach.  I don't
>> know this for a fact,
>>> but it seems more likely that someone would embed Linux on an IB switch
>> than they would plug an IB switch
>>> into a Linux based system.  The code is designed around the latter.
>> Making this a system wide setting might simplify the code and optimize the
>> code paths.
>>
>> I think we need to discuss how user space would be addressed.
> 
> This is an issue with out of tree drivers.  We're having to guess what things might be doing.  
> Are all devices being exposed up as a 'switch', or is there ever a case where there's a 'switch' device 
> and an HCA device being reported together, or (highly unlikely) a switch device and an RNIC?

Gateways are comprised of switch + HCA devices. There are other more
complex cases of multiple devices.

> If the real use case is to embed Linux on a switch, then we could look at making that a system wide setting, 
> rather than per device.  This could clean up the kernel without impacting the uABI.

I think that system wide is too limiting and it needs to be on a per
device basis.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
