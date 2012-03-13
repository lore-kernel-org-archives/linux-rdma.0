From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Tue, 13 Mar 2012 08:31:50 -0400
Message-ID: <4F5F3E36.9010600@dev.mellanox.co.il>
References: <1331064594.10889.8.camel@auk75.llnl.gov> <1331071949.17729.11.camel@auk75.llnl.gov> <4F59FECE.4030107@dev.mellanox.co.il> <20120309180459.GB29961@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120309180459.GB29961-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/9/2012 1:04 PM, Jason Gunthorpe wrote:
> On Fri, Mar 09, 2012 at 07:59:58AM -0500, Hal Rosenstock wrote:
> 
>> What mkey model is being proposed here ? It looks to me like it is a
>> single mkey for all ports in the subnet which is the simplest but least
>> flexible model. If so, I think we need something more flexible as IBA
>> allows each port to have it's own different mkey.
> 
> I would like to see some general agreement on a generator for mkey,
> something like:
> 
>   MKey = HMAC(Subnet_KEY,PortGUID)
> 
> This blinds the mkey incase a port is compromised but still lets
> privileged entities compute it from a single key.

As there is no standard for this and there are various different
requirements here, I'm not sure that one algorithm fits all so IMO it's
best to make this as flexible as possible and allow for various
algorithms/approaches to be open sourced.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
