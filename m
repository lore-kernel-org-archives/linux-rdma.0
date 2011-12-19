From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 11/14] ib_srp: Document sysfs attributes
Date: Sun, 18 Dec 2011 19:33:31 -0500
Message-ID: <1324254811.17849.65.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012009.12815.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012009.12815.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 20:09 +0100, Bart Van Assche wrote:
> Document the ib_srp sysfs attributes according to the rules specified
> in Documentation/ABI/README.

%s/ib_srp/SRP initiator/g

> +What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/add_target
> +Date:		January 2, 2006
> +KernelVersion:	2.6.15
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Interface for making ib_srp connect to a new target.
> +		One can request ib_srp to connect to a new target by writing
> +		a comma-separated list of login parameters to this sysfs
> +		attribute. The supported parameters are:
> +		* id_ext, a 16-digit hexadecimal number specifying the last
> +		  eight bytes of the 16-byte target port identifier sent by
> +		  ib_srp to the target in the SRP_LOGIN_REQ request.

... specifying the eight byte identifier extension portion of the SCSI
target port identifier.

First 8 or last 8 depends on io_class...

> +		* ioc_guid, a 16-digit hexadecimal number specifying the first
> +		  eight bytes of the 16-byte target port identifier sent by
> +		  ib_srp to the target in the SRP_LOGIN_REQ request.

... specifying the eight byte IOController GUID portion of the SCSI
target port identifier.

> +		* dgid, a 16-digit hexadecimal number specifying the
> +		  destination GID.
> +		* pkey, a four-digit hexadecimal number specifying the
> +		  InfiniBand partition key.
> +		* service_id, a 16-digit hexadecimal number specifying the
> +		  InfiniBand service ID used for communication with the SRP
> +		  target.

... used to establish communication with the SRP target.

> +		* max_sect, a decimal number specifying the maximum number of
> +		  sectors to be transferred via a single SRP_CMD request.

512 byte sectors, via a single SCSI command.

> +		* max_cmd_per_lun, a decimal number specifying the maximum
> +		  number of outstanding commands per LUN.

for a given LUN

> +		* io_class, a hexadecimal number specifying the SRP I/O class.
> +		  Must be either 0xff00 (rev 10) or 0x0100 (rev 16a).
> +		* initiator_ext, a 16-digit hexadecimal number specifying the
> +		  last eight bytes of the 16-byte initiator port identifier
> +		  sent by ib_srp to the target in the SRP_LOGIN_REQ request.

... specifying the identifier extension portion of the SCSI initiator
port ID.

> +		* cmd_sg_entries, the maximum number of memory descriptors
> +		  that fit in a single SRP command when using the direct data
> +		  buffer descriptor format.

s/direct/indirect/

> +		* allow_ext_sg, whether ib_srp is allowed to send SRP_CMD
> +		  requests to the target with an indirect data buffer
> +		  descriptor, that is a data buffer descriptor that has to be
> +		  obtained by the target via an additional RDMA transfer.

allow_ext_sg, set to non-zero to allow the initiator to send an indirect
data buffer descriptor with more than cmd_sg_entries; portions of this
descriptor must be obtained by the target via an additional RDMA
transfer. The default is to never send such a request, as the SRP target
must support this mode of operation.

> +		* sg_tablesize, a number specifying the maximum length of
> +		  scatter/gather lists passed by the SCSI layer to ib_srp.

... maximum length of the scatter/gather lists supported by the SRP
initiator. This value may be larger than cmd_sg_entries if allow_ext_sg
is true, or the administrator accepts the (small) risk that fast memory
registration will not be able to collapse the SG list into few enough
entries.


> +
> +What:		/sys/class/scsi_host/host<n>/allow_ext_sg
> +Date:		May 19, 2011
> +KernelVersion:	2.6.39
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Whether ib_srp is allowed to send SRP_CMD requests to the
> +		target with an indirect data buffer descriptor, that is a
> +		data buffer descriptor that has to be obtained by the target
> +		via an additional RDMA transfer. If set to zero, ib_srp will
> +		refuse to process data transfers whose scatter/gather list
> +		length exceeds cmd_sg_entries.

If true, the initiator believes the target will accept an indirect data
buffer descriptor with more than cmd_sg_entries, which requires an
additional RDMA operation. If false and memory registration mechanism
fails to collapse the SG list to few enough entries, the initiator will
fail the command.

> +
> +What:		/sys/class/scsi_host/host<n>/cmd_sg_entries
> +Date:		May 19, 2011
> +KernelVersion:	2.6.39
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	See also allow_ext_sg.

Maximum number of indirect data buffer descriptors that will fit inside
the request buffer without requiring an additional RDMA operation.

> +What:		/sys/class/scsi_host/host<n>/id_ext
> +What:		/sys/class/scsi_host/host<n>/ioc_guid

Same comments as for add_target.

> +What:		/sys/class/scsi_host/host<n>/service_id
> +Date:		June 17, 2006
> +KernelVersion:	2.6.17
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	InfiniBand service ID used for communication with the SRP
> +		target.

... for the InfiniBand connection management request used to establish
communication with the SRP target.


Interesting that we don't seem to have a sysfs entry for the initiator
ID value used.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
