From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 12/18] ib_srp: Document sysfs attributes
Date: Sun, 26 Feb 2012 01:33:25 -0500
Message-ID: <1330238006.1026.87.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2235458.XAcSoXLofn@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2235458.XAcSoXLofn@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:51 +0000, Bart Van Assche wrote:
> +		* cmd_sg_entries, a number in the range 1..255 that specifies
> +		  the maximum number of direct data buffer descriptors in an

s/direct/indirect/

> +		  SRP_CMD. Direct data buffer descriptors are communicated via
> +		  the SRP_CMD header. With allow_ext_sg=0 the parameter

So are indirect buffer descriptors, which is actually what this
parameter controls.

> +		  cmd_sg_entries defines the maximum S/G list length for a
> +		  single SRP_CMD. Also, commands whose S/G list length exceeds

s/. Also,/ and/

> +		  this limit after S/G list collapsing will fail.
> +		* allow_ext_sg, whether ib_srp is allowed to use indirect data
> +		  buffer descriptors when communicating with an SRP target.

allow_ext_sg, if true, the initiator is allowed to use more indirect
data buffer descriptors than will fit in the SRP_CMD, allowing for
larger requests to be handled. If false (the default), the length of the
S/G list after merging is limited to cmd_sg_entries. Target support for
retrieving the indirect descriptor table via RDMA is required to set
this to true.

> +		* sg_tablesize, a number in the range 1..2048 specifying the
> +		  maximum S/G list length the SCSI layer is allowed to pass to
> +		  ib_srp. Specifying a value that exceeds cmd_sg_entries is
> +		  only safe with indirect data buffer support enabled
> +		  (allow_ext_sg=1).

s/only safe/only completely safe/

If this value exceeds cmd_sg_entries and a failure occurs while
collapsing the list into fewer S/G entries, the command will fail. This
failure case only appears to be possible on IBM HCAs.

> +What:		/sys/class/scsi_host/host<n>/allow_ext_sg
> +Date:		May 19, 2011
> +KernelVersion:	2.6.39
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Whether ib_srp is allowed to use indirect data buffer
> +		descriptors when communicating with an SRP target.

Whether the initiator is allowed to use more S/G entries than will fit
in the command request when communicating with an SRP target.

> +What:		/sys/class/scsi_host/host<n>/cmd_sg_entries
> +Date:		May 19, 2011
> +KernelVersion:	2.6.39
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Maximum number of direct data buffer descriptors to send to
> +		the target in a single SRP_CMD.

s/direct/indirect/


> +What:		/sys/class/scsi_host/host<n>/failed_reconnects
>+What:		/sys/class/scsi_host/host<n>/reconnect_tmo

These attributes does not exist at this point in the patch series.
Perhaps this patch should be the last one in the series?


-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
