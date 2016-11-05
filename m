From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags v4] ibportstate: Fixed switch peer port probing when using DR routing
Date: Sat, 5 Nov 2016 03:52:54 -0400
Message-ID: <20161105075253.GA28462@phlsvsds.ph.intel.com>
References: <e4f9a5f6c7f55bd65574723956298f588a964f6f.1477323407.git-series.knut.omang@oracle.com> <03e641c6-d8b5-ed98-18ec-34158d4b6f9a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03e641c6-d8b5-ed98-18ec-34158d4b6f9a-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2016 at 01:18:42PM -0400, Hal Rosenstock wrote:
> On 10/24/2016 11:38 AM, Knut Omang wrote:
> > From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > ibportstate queries to a remote peer port on a switch using direct
> > routing would result in timeouts. The reason for this is that the
> > DR path was not correctly constructed.
> > 
> > Signed-off-by: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
