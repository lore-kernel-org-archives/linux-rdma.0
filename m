From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/11] xprtrdma: Add ro_unmap_sync method for FRWR
Date: Wed, 16 Dec 2015 10:09:44 -0500
Message-ID: <1ED402CD-72B6-4F44-A8FD-88FD379551BA@oracle.com>
References: <20151214211317.16295.70115.stgit@manet.1015granger.net> <20151214211827.16295.76338.stgit@manet.1015granger.net> <56716DE4.8080403@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56716DE4.8080403-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Dec 16, 2015, at 8:57 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> 
>> +static void
>> +__frwr_dma_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>> +		 int rc)
>> +{
>> +	struct ib_device *device = r_xprt->rx_ia.ri_device;
>> +	struct rpcrdma_mw *mw = seg->rl_mw;
>> +	int nsegs = seg->mr_nsegs;
>> +
>> +	seg->rl_mw = NULL;
>> +
>> +	while (nsegs--)
>> +		rpcrdma_unmap_one(device, seg++);
> 
> Chuck, shouldn't this be replaced with ib_dma_unmap_sg?

Looks like this was left over from before the conversion
to use ib_dma_unmap_sg. I'll have a look.

> Sorry for the late comment (Didn't find enough time to properly
> review this...)

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
