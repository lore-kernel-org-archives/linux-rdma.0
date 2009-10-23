From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/5] infiniband-diags/libibnetdisc: Introduce a context
 object.
Date: Fri, 23 Oct 2009 19:45:43 +0200
Message-ID: <20091023174543.GB5764@me>
References: <20090813204306.dffc3237.weiny2@llnl.gov>
 <20090816110200.GS25501@me>
 <20090817083023.da17378b.weiny2@llnl.gov>
 <20090823120609.GG9547@me>
 <20090831170144.da0e7185.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090831170144.da0e7185.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:01 Mon 31 Aug     , Ira Weiny wrote:
> 
> The discussion on the list has digressed from this patch.  I still think this
> patch is valid and adds a level of flexibility which is needed regardless of
> what is decided about libibmad.  Do you agree?

Not really. I still think that needed level of flexibility is available
for us without adding new mandatory APIs.

> Also, the last patch in the series ([PATCH 5/5] infiniband-diags/libibnetdisc:
> remove members of the fabric struct which are used in the scan only) cleans up
> some stuff from the external interface.  If you really don't want to introduce
> a context object, then I can regenerate that final patch without the context.

Yes, since this patch is unrelated logically to a context stuff. It would
be good to rebase it back and repost as independent change.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
