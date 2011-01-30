From: Sasha Khapyorsky <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC: Splitting of the management git tree in Open Fabrics
Date: Sun, 30 Jan 2011 19:41:20 +0200
Message-ID: <20110130174120.GG25002@me>
References: <20100831125159.98e6d201.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100831125159.98e6d201.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

On 12:51 Tue 31 Aug     , Ira Weiny wrote:
> 
> On openfabrics.org/git split management.git into the following trees.
> 
> openfabrics.org/git/infiniband-diags.git
> openfabrics.org/git/libibumad.git
> openfabrics.org/git/libibmad.git
> openfabrics.org/git/opensm.git
>  
> Sasha can populate those from the current management tree.  We believe there
> are git commands which will do this without losing any history from the git
> trees.

As was already discussed. I'm going to split management tree into
separate libibumad, libibmad, opensm and infiniband-diags trees and
will publish this soon (few days). The history will be preserved as per
sub-tree.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
