From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Ignore PortInfo data on down port.
Date: Tue, 23 Mar 2010 12:19:53 +0200
Message-ID: <20100323101953.GC4808@me>
References: <20100319111943.80ae2e24.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100319111943.80ae2e24.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:19 Fri 19 Mar     , Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Thu, 18 Mar 2010 18:35:34 -0700
> Subject: [PATCH] infiniband-diags: Ignore PortInfo data on down port.
> 
> According to C14-24.2.1:
> If PortInfo:PortState == Down then only PortInfo:PortState and
> PortInfo:PortPhysicalState _must_ be valid.  Other fields may be invalid
> depending on the vendor.  Therefore ignore all PortInfo data other than those
> fields when reporting PortInfo on a down port.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
