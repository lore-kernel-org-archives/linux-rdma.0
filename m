From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/src/ibqueryerrors.c: fix bug when
 attempting a sub-fabric scan
Date: Tue, 29 Sep 2009 13:04:23 +0200
Message-ID: <20090929110423.GN26931@me>
References: <20090923144555.9efa2c75.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090923144555.9efa2c75.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: OpenFabrics <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:45 Wed 23 Sep     , Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Wed, 23 Sep 2009 14:26:55 -0700
> Subject: [PATCH] infiniband-diags/src/ibqueryerrors.c: fix bug when attempting a sub-fabric scan
> 
> 	Also ibd_sm_id is never valid in this tool as the "-s" option is used
> 	for "suppress"
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
