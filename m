From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 11/14] ib_srp: Document sysfs attributes
Date: Thu, 1 Dec 2011 20:09:12 +0100
Message-ID: <201112012009.12815.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011954.25811.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Document the ib_srp sysfs attributes according to the rules specified
in Documentation/ABI/README.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-driver-ib_srp |  141 ++++++++++++++++++++++++++
 1 files changed, 141 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-ib_srp

diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
new file mode 100644
index 0000000..6b74c09
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
@@ -0,0 +1,141 @@
+What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/add_target
+Date:		January 2, 2006
+KernelVersion:	2.6.15
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Interface for making ib_srp connect to a new target.
+		One can request ib_srp to connect to a new target by writing
+		a comma-separated list of login parameters to this sysfs
+		attribute. The supported parameters are:
+		* id_ext, a 16-digit hexadecimal number specifying the last
+		  eight bytes of the 16-byte target port identifier sent by
+		  ib_srp to the target in the SRP_LOGIN_REQ request.
+		* ioc_guid, a 16-digit hexadecimal number specifying the first
+		  eight bytes of the 16-byte target port identifier sent by
+		  ib_srp to the target in the SRP_LOGIN_REQ request.
+		* dgid, a 16-digit hexadecimal number specifying the
+		  destination GID.
+		* pkey, a four-digit hexadecimal number specifying the
+		  InfiniBand partition key.
+		* service_id, a 16-digit hexadecimal number specifying the
+		  InfiniBand service ID used for communication with the SRP
+		  target.
+		* max_sect, a decimal number specifying the maximum number of
+		  sectors to be transferred via a single SRP_CMD request.
+		* max_cmd_per_lun, a decimal number specifying the maximum
+		  number of outstanding commands per LUN.
+		* io_class, a hexadecimal number specifying the SRP I/O class.
+		  Must be either 0xff00 (rev 10) or 0x0100 (rev 16a).
+		* initiator_ext, a 16-digit hexadecimal number specifying the
+		  last eight bytes of the 16-byte initiator port identifier
+		  sent by ib_srp to the target in the SRP_LOGIN_REQ request.
+		* cmd_sg_entries, the maximum number of memory descriptors
+		  that fit in a single SRP command when using the direct data
+		  buffer descriptor format.
+		* allow_ext_sg, whether ib_srp is allowed to send SRP_CMD
+		  requests to the target with an indirect data buffer
+		  descriptor, that is a data buffer descriptor that has to be
+		  obtained by the target via an additional RDMA transfer.
+		* sg_tablesize, a number specifying the maximum length of
+		  scatter/gather lists passed by the SCSI layer to ib_srp.
+
+What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/ibdev
+Date:		January 2, 2006
+KernelVersion:	2.6.15
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	HCA name (<hca>).
+
+What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/port
+Date:		January 2, 2006
+KernelVersion:	2.6.15
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	HCA port number (<port_number>).
+
+What:		/sys/class/scsi_host/host<n>/allow_ext_sg
+Date:		May 19, 2011
+KernelVersion:	2.6.39
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Whether ib_srp is allowed to send SRP_CMD requests to the
+		target with an indirect data buffer descriptor, that is a
+		data buffer descriptor that has to be obtained by the target
+		via an additional RDMA transfer. If set to zero, ib_srp will
+		refuse to process data transfers whose scatter/gather list
+		length exceeds cmd_sg_entries.
+
+What:		/sys/class/scsi_host/host<n>/cmd_sg_entries
+Date:		May 19, 2011
+KernelVersion:	2.6.39
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	See also allow_ext_sg.
+
+What:		/sys/class/scsi_host/host<n>/dgid
+Date:		June 17, 2006
+KernelVersion:	2.6.17
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	InfiniBand destination GID used for communication with the SRP
+		target. Differs from orig_dgid if port redirection has happened.
+
+What:		/sys/class/scsi_host/host<n>/id_ext
+Date:		June 17, 2006
+KernelVersion:	2.6.17
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Last eight bytes of the 16-byte target port identifier sent by
+		ib_srp to the target in the SRP_LOGIN_REQ request.
+
+What:		/sys/class/scsi_host/host<n>/ioc_guid
+Date:		June 17, 2006
+KernelVersion:	2.6.17
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	First eight bytes of the 16-byte target port identifier sent
+		by ib_srp to the target in the SRP_LOGIN_REQ request.
+
+What:		/sys/class/scsi_host/host<n>/local_ib_device
+Date:		November 29, 2006
+KernelVersion:	2.6.19
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Name of the InfiniBand HCA used for communicating with the
+		SRP target.
+
+What:		/sys/class/scsi_host/host<n>/local_ib_port
+Date:		November 29, 2006
+KernelVersion:	2.6.19
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of the HCA port used for communicating with the
+		SRP target.
+
+What:		/sys/class/scsi_host/host<n>/orig_dgid
+Date:		June 17, 2006
+KernelVersion:	2.6.17
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	InfiniBand destination GID specified in the parameters
+		written to the add_target sysfs attribute.
+
+What:		/sys/class/scsi_host/host<n>/pkey
+Date:		June 17, 2006
+KernelVersion:	2.6.17
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	A 16-bit number representing the InfiniBand partition key used
+		for communication with the SRP target.
+
+What:		/sys/class/scsi_host/host<n>/req_lim
+Date:		October 20, 2010
+KernelVersion:	2.6.36
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of requests ib_srp can send to the target before it has
+		to wait for more credits. For more information see also the
+		SRP credit algorithm in the SRP specification.
+
+What:		/sys/class/scsi_host/host<n>/service_id
+Date:		June 17, 2006
+KernelVersion:	2.6.17
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	InfiniBand service ID used for communication with the SRP
+		target.
+
+What:		/sys/class/scsi_host/host<n>/zero_req_lim
+Date:		September 20, 2006
+KernelVersion:	2.6.18
+Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Number of times the initiator had to wait with sending a
+		request to the target because it ran out of credits. For more
+		information see also the SRP credit algorithm in the SRP
+		specification.
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
