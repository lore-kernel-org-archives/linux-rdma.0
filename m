From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/scripts/ibcheckerrs.in: emulate all
 ports if necessary.
Date: Fri, 7 May 2010 00:13:28 +0300
Message-ID: <20100506211328.GI7099@me.iol.unh.edu>
References: <20100505194720.6f9d434c.weiny2@llnl.gov>
 <20100506091829.dd275edf.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100506091829.dd275edf.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Robert Woodruff <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:18 Thu 06 May     , Ira Weiny wrote:
> Upon thinking about this a bit more, and seeing Mikes patch.  I think that the
> patch which Mike sent some time ago is a better fix.  This will work fine for
> ibcheckerrs.  However ibcheckerrors will run AllPortSelect and then go on to
> query all the ports individually.  The patch below will cause a double read
> for each port which will kill ibcheckerrors performance on a large cluster.
> 
> Sasha, what is the status of Mikes patch?

Applied now.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
