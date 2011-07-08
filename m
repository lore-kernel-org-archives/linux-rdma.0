From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/4] infiniband-diags: properly resolve node guids
Date: Fri, 08 Jul 2011 17:59:01 -0400
Message-ID: <4E177DA5.9030600@dev.mellanox.co.il>
References: <20110705120815.3cc7d59b.weiny2@llnl.gov> <4E1779CE.9030502@dev.mellanox.co.il> <20110708215046.GB10216@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110708215046.GB10216-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2011 5:50 PM, Jason Gunthorpe wrote:
> On Fri, Jul 08, 2011 at 05:42:38PM -0400, Hal Rosenstock wrote:
> 
>> Should the request just be a GET rather than GET_TABLE and avoid this
>> check ? I don't think multiple nodes can register with same Node GUID,
>> can they ? Also, I think it makes eliminates this check and the missing
>> 0 check.
> 
> Multiport HCAs should (and do..) show up with multiple node
> records. There is one node record per end port, not per node. This is
> why using node GUID as an end port identifier is a bad choice.

Before this patch, it did used to use the port GUID for this.

> However, you could use GET and look at the return code to disambiguate
> no records/one record/many records.

Yes, that was getting at (and that there was no check for no records
returned with the get table code).

-- Hal

> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
